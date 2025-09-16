#' helpers 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
helpers <- function() {
}

#' Validate GitHub blob URL to a .tex file
is_valid_github_tex_url <- function(url) {
  pattern <- "^https://github\\.com/([^/]+)/([^/]+)/blob/[^/]+/.+\\.tex$"
  grepl(pattern, url)
}

#' Parse owner, repo, branch, and path from GitHub blob URL
parse_tex_url <- function(url) {
  pattern <- "^https://github\\.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*\\.tex)$"
  matches <- stringr::str_match(url, pattern)
  
  if (any(is.na(matches))) return(NULL)
  
  list(
    owner = matches[2],
    repo = matches[3],
    branch = matches[4],
    path = matches[5]
  )
}

#' Check if a specific .tex file exists on GitHub
#' @param owner GitHub username or org
#' @param repo GitHub repository name
#' @param path Path to the file in the repo
#' @param ref Git reference (branch or commit SHA)
#' @return TRUE if file exists, FALSE otherwise
tex_file_exists_on_github <- function(owner, repo, path, ref = "main") {
  tryCatch({
    gh::gh(
      "/repos/:owner/:repo/contents/:path",
      owner = owner,
      repo = repo,
      path = path,
      ref = ref
    )
    TRUE
  }, error = function(e) {
    FALSE
  })
}

#' Get commits affecting a specific file
get_file_commits <- function(owner, repo, path) {
  tryCatch({
    gh::gh(
      "/repos/:owner/:repo/commits",
      owner = owner,
      repo = repo,
      path = path,
      .limit = 100
    )
  }, error = function(e) list())
}

#' Get raw text content of a LaTeX file at each commit
#' @param owner, repo, path - GitHub info
#' @param commits - list of commit objects
#' @return named list of first 10 lines of raw .tex at each commit
get_raw_tex_snippets <- function(owner, repo, path, commits) {
  results <- list()
  
  for (commit in commits) {
    sha <- commit$sha
    
    try({
      raw <- gh::gh(
        "/repos/:owner/:repo/contents/:path",
        owner = owner,
        repo = repo,
        path = path,
        ref = sha,
        .send_headers = c(Accept = "application/vnd.github.v3.raw")
      )
      
      lines <- unlist(strsplit(raw, "\n"))
      snippet <- paste(utils::head(lines, 10), collapse = "\n")
      results[[sha]] <- snippet
    }, silent = TRUE)
  }
  
  return(results)
}

extract_title_and_abstract <- function(tex) {
  # Enable DOTALL mode using (?s) so . matches newlines
  title <- str_match(tex, "(?s)\\\\title\\{(.*?)\\}")[, 2]
  abstract <- str_match(tex, "(?s)\\\\begin\\{abstract\\}(.*?)\\\\end\\{abstract\\}")[, 2]
  
  # Clean up extra spacing if needed
  title <- str_trim(title)
  abstract <- str_trim(abstract)
  
  list(title = title, abstract = abstract)
}


#' Extract LaTeX metadata (title and abstract) across commits
#' @param owner, repo, path - GitHub info
#' @param commits - list of commit objects (from gh::gh)
#' @return named list of parsed data per commit SHA
get_metadata_across_commits <- function(owner, repo, path, commits) {
  results <- list()
  
  for (commit in commits) {
    sha <- commit$sha
    
    try({
      raw <- gh::gh(
        "/repos/:owner/:repo/contents/:path",
        owner = owner,
        repo = repo,
        path = path,
        ref = sha,
        .send_headers = c(Accept = "application/vnd.github.v3.raw")
      )
      
      parsed <- parse_latex_title_abstract(raw)
      results[[sha]] <- parsed
    }, silent = TRUE)
  }
  
  return(results)
}

#' Tokenize LaTeX text into words and symbols
#' @param text Character string
#' @return Character vector of tokens
split_words <- function(text) {
  stringr::str_extract_all(text, "\\\\[a-zA-Z]+|\\S+|\\s+")[[1]]
}

#' Compute word-level diff using Google's diff-match-patch
#' @param text1, text2 Strings to compare
#' @return List of diff opcodes and tokens
diff_words <- function(text1, text2) {
  dmp <- reticulate::import("diff_match_patch")$diff_match_patch()
  
  tokens1 <- split_words(text1)
  tokens2 <- split_words(text2)
  
  token_map <- list()
  token_array <- c()
  chars1 <- c()
  chars2 <- c()
  last_token_id <- 0
  
  token_to_char <- function(tok) {
    if (!tok %in% names(token_map)) {
      token_map[[tok]] <<- intToUtf8(last_token_id)
      token_array <<- c(token_array, tok)
      last_token_id <<- last_token_id + 1
    }
    # Always return a scalar string
    token <- token_map[[tok]]
    if (is.null(token)) token <- "\uFFFD"  # replacement character
    return(token)
  }
  
  chars1 <- paste0(vapply(tokens1, token_to_char, character(1)), collapse = "")
  chars2 <- paste0(vapply(tokens2, token_to_char, character(1)), collapse = "")
  
  diffs <- dmp$diff_main(chars1, chars2, FALSE)
  dmp$diff_cleanupSemantic(diffs)
  
  decoded_diffs <- list()
  for (d in diffs) {
    op <- d[[1]]
    chars <- strsplit(d[[2]], "")[[1]]
    words <- vapply(chars, function(c) {
      token_array[utf8ToInt(c) + 1]
    }, character(1))
    decoded_diffs <- append(decoded_diffs, list(list(op, words)))
  }
  
  return(decoded_diffs)
}

#' Render a diff as HTML with <ins> and <del> tags
#' @param decoded_diffs A list from diff_words()
#' @return HTML fragment (as htmltools::HTML)
render_diff_html <- function(decoded_diffs) {
  html <- ""
  for (d in decoded_diffs) {
    op <- d[[1]]
    tokens <- d[[2]]
    frag <- paste0(sapply(tokens, function(tok) {
      htmlEscape(gsub("\\\\", "\\\\\\\\", tok))
    }), collapse = "")
    if (op == -1) {
      html <- paste0(html, "<del style='color:red;'>", frag, "</del>")
    } else if (op == 1) {
      html <- paste0(html, "<ins style='color:green;'>", frag, "</ins>")
    } else {
      html <- paste0(html, frag)
    }
  }
  htmltools::HTML(paste0("<pre style='white-space:pre-wrap;'>", html, "</pre>"))
}


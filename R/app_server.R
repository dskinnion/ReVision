#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinybusy
#' @import stringr
#' @import htmltools
#' @noRd
# app_server <- function(input, output, session) {
#   
#   repo_url <- reactiveVal(NULL)
#   validation_msg <- reactiveVal("")
#   commits <- reactiveVal(NULL)  # Top-level in server
#   metadata <- reactiveVal(NULL)
#   
#   observeEvent(input$submit_url, {
#     input_url <- input$repo_url
#     
#     if (!is_valid_github_url(input_url)) {
#       validation_msg("❌ Invalid GitHub repository URL.")
#       repo_url(NULL)
#       return()
#     }
#     
#     # Extract owner/repo from URL
#     owner_repo <- parse_repo_url(input_url)
#     
#     if (!repo_exists_on_github(owner_repo)) {
#       validation_msg("❌ This repository doesn't exist or can't be accessed.")
#       repo_url(NULL)
#       return()
#     }
#     
#     found_commits <- get_commits_from_github(owner_repo)
#     
#     if (length(found_commits) == 0) {
#       validation_msg("⚠️ No commits found or could not fetch commits.")
#       repo_url(NULL)
#       return()
#     }
#     
#     # Save
#     repo_url(owner_repo)
#     commits(found_commits)
#     
#     # Example: Use the first 5 commits for now
#     commit_shas <- sapply(commits(), `[[`, "sha")[1:5]
#     
#     results <- list()
#     
#     for (sha in commit_shas) {
#       tex_files <- get_tex_files_in_commit(repo_url(), sha)
#       
#       if (length(tex_files) == 0) next
#       
#       commit_meta <- list()
#       
#       for (path in tex_files) {
#         parsed <- get_latex_metadata_from_commit(repo_url(), sha, path)
#         commit_meta[[path]] <- parsed
#       }
#       
#       results[[sha]] <- commit_meta
#     }
#     
#     metadata(results)
#     
#     validation_msg(paste("✅ Repo:", repo_url(),
#                          "| Commits:", length(commits()),
#                          "| Parsed:", length(results), "with .tex"))
#   })
#   
#   output$url_display <- renderText({
#     validation_msg()
#   })
#   
#   
# }
app_server <- function(input, output, session) {
  metadata <- reactiveVal(NULL)
  tex_snippets <- reactiveVal(NULL)
  
  observeEvent(input$submit, {
    show_modal_spinner(text = "Loading commits...", spin = "fading-circle")
    on.exit(remove_modal_spinner(), add = TRUE)
    
    url <- input$tex_url
    
    if (!is_valid_github_tex_url(url)) {
      output$result <- renderText("❌ Invalid GitHub .tex file URL.")
      return()
    }
    
    parts <- parse_tex_url(url)
    if (is.null(parts)) {
      output$result <- renderText("❌ Could not parse URL.")
      return()
    }
    
    if (!tex_file_exists_on_github(parts$owner, parts$repo, parts$path, parts$branch)) {
      output$result <- renderText("❌ The .tex file does not exist.")
      return()
    }
    
    commits <- get_file_commits(parts$owner, parts$repo, parts$path)
    if (length(commits) < 2) {
      output$result <- renderText("⚠️ Need at least 2 commits to compare.")
      return()
    }
    
    # Get .tex content from the two most recent commits
    sha_new <- commits[[1]]$sha
    sha_old <- commits[[2]]$sha
    
    raw_new <- gh::gh(
      "/repos/:owner/:repo/contents/:path",
      owner = parts$owner,
      repo = parts$repo,
      path = parts$path,
      ref = sha_new,
      .send_headers = c(Accept = "application/vnd.github.v3.raw")
    )
    
    raw_old <- gh::gh(
      "/repos/:owner/:repo/contents/:path",
      owner = parts$owner,
      repo = parts$repo,
      path = parts$path,
      ref = sha_old,
      .send_headers = c(Accept = "application/vnd.github.v3.raw")
    )
    
    parsed_new <- extract_title_and_abstract(raw_new)
    parsed_old <- extract_title_and_abstract(raw_old)
    
    output$result <- renderText({
      paste0("✅ File: ", parts$path,
             "\nCommits scanned: ", length(commits),
             "\nLatest: ", sha_new,
             "\nPrevious: ", sha_old)
    })
    
    output$diff_viewer <- renderUI({
      title_diff <- render_diff_html(diff_words(parsed_old$title, parsed_new$title))
      abs_diff <- render_diff_html(diff_words(parsed_old$abstract, parsed_new$abstract))
      
      tagList(
        tags$h3("Title Diff"),
        title_diff,
        tags$br(),
        tags$h3("Abstract Diff"),
        abs_diff
      )
    })
  })
  
  # observeEvent(input$submit, {
  #   url <- input$tex_url
  #   
  #   if (!is_valid_github_tex_url(url)) {
  #     output$result <- renderText("❌ Invalid GitHub .tex file URL.")
  #     return()
  #   }
  #   
  #   parts <- parse_tex_url(url)
  #   if (is.null(parts)) {
  #     output$result <- renderText("❌ Could not parse URL.")
  #     return()
  #   }
  #   
  #   if (!tex_file_exists_on_github(parts$owner, parts$repo, parts$path, parts$branch)) {
  #     output$result <- renderText("❌ The .tex file does not exist.")
  #     return()
  #   }
  #   
  #   commits <- get_file_commits(parts$owner, parts$repo, parts$path)
  #   
  #   if (length(commits) == 0) {
  #     output$result <- renderText("⚠️ No commits found for this file.")
  #     return() 
  #   }
  #   
  #   output$result <- renderText({
  #     paste0("Commits found: ", length(commits))
  #   })
    
    # output$diff_viewer <- renderUI({
    #   parsed <- metadata()
    #   if (is.null(parsed) || length(parsed) < 2) return(NULL)
    #   
    #   latest <- parsed[[1]]
    #   previous <- parsed[[2]]
    #   
    #   title_diff <- render_diff_html(diff_words(previous$title, latest$title))
    #   abs_diff <- render_diff_html(diff_words(previous$abstract, latest$abstract))
    #   
    #   tagList(
    #     h3("Title Diff"),
    #     title_diff,
    #     h3("Abstract Diff"),
    #     abs_diff
    #   )
    # })
    
    
    # snippets <- get_raw_tex_snippets(parts$owner, parts$repo, parts$path, commits)
    # tex_snippets(snippets)
    
    # # 🧠 Extract title/abstract across commits
    # parsed_data <- get_metadata_across_commits(parts$owner, parts$repo, parts$path, commits)
    # 
    # # Save parsed results for downstream use (e.g., slider/diff)
    # metadata(parsed_data)
    # 
    # # Show summary
    # output$result <- renderText({
    #   valid <- sum(!sapply(parsed_data, function(x) all(is.na(x))))
    #   paste0("✅ File: ", parts$path,
    #          "\nCommits scanned: ", length(commits),
    #          "\nCommits with parsed metadata: ", valid)
    # })
}




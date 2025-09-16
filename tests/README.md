Tests and Coverage
================
06 June, 2025 12:46:30

- [Coverage](#coverage)
- [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/yonicd/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                                | Coverage (%) |
|:------------------------------------------------------|:------------:|
| ReVision                                              |    94.42     |
| [R/run_app.R](../R/run_app.R)                         |     0.00     |
| [R/app_config.R](../R/app_config.R)                   |    100.00    |
| [R/app_ui.R](../R/app_ui.R)                           |    100.00    |
| [R/golem_utils_server.R](../R/golem_utils_server.R)   |    100.00    |
| [R/golem_utils_ui.R](../R/golem_utils_ui.R)           |    100.00    |
| [R/mod_name_of_module1.R](../R/mod_name_of_module1.R) |    100.00    |
| [R/mod_name_of_module2.R](../R/mod_name_of_module2.R) |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file | n | time | error | failed | skipped | warning | icon |
|:---|---:|---:|---:|---:|---:|---:|:---|
| [test-app.R](testthat/test-app.R) | 1 | 0.002 | 0 | 0 | 0 | 0 |  |
| [test-fct_helpers.R](testthat/test-fct_helpers.R) | 1 | 0.003 | 0 | 0 | 0 | 0 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R) | 16 | 0.029 | 0 | 0 | 0 | 0 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R) | 59 | 0.108 | 0 | 0 | 0 | 0 |  |
| [test-golem-recommended.R](testthat/test-golem-recommended.R) | 10 | 0.020 | 0 | 0 | 1 | 0 | 🔶 |
| [test-mod_name_of_module1.R](testthat/test-mod_name_of_module1.R) | 2 | 0.003 | 0 | 0 | 0 | 0 |  |
| [test-mod_name_of_module2.R](testthat/test-mod_name_of_module2.R) | 2 | 0.003 | 0 | 0 | 0 | 0 |  |
| [test-utils_helpers.R](testthat/test-utils_helpers.R) | 1 | 0.002 | 0 | 0 | 0 | 0 |  |

<details open>

<summary>

Show Detailed Test Results
</summary>

| file | context | test | status | n | time | icon |
|:---|:---|:---|:---|---:|---:|:---|
| [test-app.R](testthat/test-app.R#L2) | app | multiplication works | PASS | 1 | 0.002 |  |
| [test-fct_helpers.R](testthat/test-fct_helpers.R#L2) | fct_helpers | multiplication works | PASS | 1 | 0.003 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R#L2) | golem_utils_server | not_in works | PASS | 2 | 0.004 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R#L7) | golem_utils_server | not_null works | PASS | 2 | 0.003 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R#L12) | golem_utils_server | not_na works | PASS | 2 | 0.003 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R#L17_L22) | golem_utils_server | drop_nulls works | PASS | 1 | 0.002 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R#L26_L29) | golem_utils_server | %\|\|% works | PASS | 2 | 0.004 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R#L37_L40) | golem_utils_server | %\|NA\|% works | PASS | 2 | 0.003 |  |
| [test-golem_utils_server.R](testthat/test-golem_utils_server.R#L48_L50) | golem_utils_server | rv and rvtl work | PASS | 5 | 0.010 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L2) | golem_utils_ui | Test with_red_star works | PASS | 2 | 0.007 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L10) | golem_utils_ui | Test list_to_li works | PASS | 3 | 0.009 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L22_L28) | golem_utils_ui | Test list_to_p works | PASS | 3 | 0.007 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L53) | golem_utils_ui | Test named_to_li works | PASS | 3 | 0.005 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L66) | golem_utils_ui | Test tagRemoveAttributes works | PASS | 4 | 0.005 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L82) | golem_utils_ui | Test undisplay works | PASS | 12 | 0.013 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L123) | golem_utils_ui | Test display works | PASS | 4 | 0.004 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L137) | golem_utils_ui | Test jq_hide works | PASS | 2 | 0.003 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L145) | golem_utils_ui | Test rep_br works | PASS | 2 | 0.003 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L153) | golem_utils_ui | Test enurl works | PASS | 2 | 0.003 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L161) | golem_utils_ui | Test columns wrappers works | PASS | 16 | 0.016 |  |
| [test-golem_utils_ui.R](testthat/test-golem_utils_ui.R#L186) | golem_utils_ui | Test make_action_button works | PASS | 6 | 0.033 |  |
| [test-golem-recommended.R](testthat/test-golem-recommended.R#L3) | golem-recommended | app ui | PASS | 2 | 0.007 |  |
| [test-golem-recommended.R](testthat/test-golem-recommended.R#L13) | golem-recommended | app server | PASS | 4 | 0.005 |  |
| [test-golem-recommended.R](testthat/test-golem-recommended.R#L24_L26) | golem-recommended | app_sys works | PASS | 1 | 0.002 |  |
| [test-golem-recommended.R](testthat/test-golem-recommended.R#L36_L42) | golem-recommended | golem-config works | PASS | 2 | 0.004 |  |
| [test-golem-recommended.R](testthat/test-golem-recommended.R#L72) | golem-recommended | app launches | SKIPPED | 1 | 0.002 | 🔶 |
| [test-mod_name_of_module1.R](testthat/test-mod_name_of_module1.R#L31) | mod_name_of_module1 | module ui works | PASS | 2 | 0.003 |  |
| [test-mod_name_of_module2.R](testthat/test-mod_name_of_module2.R#L31) | mod_name_of_module2 | module ui works | PASS | 2 | 0.003 |  |
| [test-utils_helpers.R](testthat/test-utils_helpers.R#L2) | utils_helpers | multiplication works | PASS | 1 | 0.002 |  |

| Failed | Warning | Skipped |
|:-------|:--------|:--------|
| 🛑     | ⚠️      | 🔶      |

</details>

<details>

<summary>

Session Info
</summary>

| Field    | Value                        |
|:---------|:-----------------------------|
| Version  | R version 4.5.0 (2025-04-11) |
| Platform | aarch64-apple-darwin20       |
| Running  | macOS Sequoia 15.4.1         |
| Language | en_US                        |
| Timezone | America/New_York             |

| Package  | Version |
|:---------|:--------|
| testthat | 3.2.3   |
| covr     | 3.6.4   |
| covrpage | 0.2     |

</details>

<!--- Final Status : skipped/warning --->

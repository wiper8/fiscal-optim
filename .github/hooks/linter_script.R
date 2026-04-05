# exécuter `lintr`

message("Running lintr script")

exclusions <- system2("git", "ls-files --others", stdout = TRUE)

lint_results <- lintr::lint_dir("R") #, exclusions = exclusions)

if (length(lint_results) > 0) {
  linters_msg <- sapply(
    lint_results,
    function(lint) {
      paste0(
        "File {.field ", lint$filename, "}",
        ", line ", lint$line_number,
        ", col ", lint$column_number,
        ": [", lint$linter, "]",
        " ", lint$message
      )
    }
  )
  
  cli::cli_abort(
    c(
      "Le package `lintr` a trouvé des erreurs de linting dans le code.",
      "i" = "Au besoin, utilisez `lintr::lint_dir(\"R\")` pour identifier les erreurs dans le code.",
      setNames(linters_msg, rep("x", length(linters_msg)))
    )
  )
}

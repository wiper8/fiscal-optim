library(mockery)
library(testthat)

test_files <- list.files("R/tests", "test.*\\.R", recursive = TRUE, full.names = TRUE)

sapply(test_files, source)

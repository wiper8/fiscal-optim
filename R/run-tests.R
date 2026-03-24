library(mockery)
library(testthat)

### tests unitaires
test_files <- list.files("R/tests/unit", "test.*\\.R", recursive = TRUE, full.names = TRUE)

test_results <- sapply(test_files, source)["value", ]
test_true <- sapply(test_results, isTRUE)
print(test_true)

# lancer l'erreur si les tests ne passent pas
expect_true(all(test_true))

### test d'intégration
test_files <- list.files("R/tests/integration", "test.*\\.R", recursive = TRUE, full.names = TRUE)

test_results <- sapply(test_files, source)["value", ]
test_true <- sapply(test_results, isTRUE)
print(test_true)

# lancer l'erreur si les tests ne passent pas
expect_true(all(test_true))

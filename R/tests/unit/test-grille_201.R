source("R/src/impot/qc/grille_201.R")

expect_equal(
  grille_201(c(0, 1000, 10000, 30000, 1000000)),
  c(0, 60, 600, 1420, 1420)
)

TRUE

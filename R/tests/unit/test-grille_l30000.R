source("R/src/impot/fed/grille_l30000.R")

expect_equal(
  grille_l30000(c(0, 177882, 253414, 1000000, 200000)),
  c(16129, 16129, 14538, 14538, 15663.11),
  tolerance = 0.01,
  scale = 1
)

TRUE

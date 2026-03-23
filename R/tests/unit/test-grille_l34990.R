source("R/src/impot/fed/grille_l34990.R")

expect_equal(
  grille_l34990(c(-1000, 0, 1000, 10000, 50000, 100000, 1000000)),
  c(0, 0, 0, 57.98, 1437.98, 3162.98, 34212.98),
  tolerance = 0.01,
  scale = 1
)

TRUE

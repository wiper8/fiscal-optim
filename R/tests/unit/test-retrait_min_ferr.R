source("R/src/retrait_min_ferr.R")

expect_equal(
  retrait_min_ferr(c(20, 50, 65, 70, 71, 72, 94, 95, 96, 120)),
  c(0, 0, 0, 0, 0.0528, 0.054, 0.1879, 0.2, 0.2, 0.2)
)

expect_true(
  all(diff(retrait_min_ferr(20:120)) >= 0)
)

TRUE

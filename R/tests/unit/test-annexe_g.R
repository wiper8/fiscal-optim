source("R/src/impot/qc/annexe_g.R")

expect_equal(
  annexe_g(c(-2000, 0, 4000, 50000, 1000000)),
  c(-1000, 0, 2000, 25000, 500000)
)


TRUE

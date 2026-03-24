source("R/src/impot/fed/annexe_3.R")

expect_equal(
  annexe_3(c(-1000, 0, 1000, 1000000)),
  c(0, 0, 500, 500000)
)

TRUE

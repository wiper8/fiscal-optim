source("R/src/get_cotis_ae.R")

expect_equal(
  get_cotis_ae(c(0, 50000, 100000, 500000)),
  c(0, 655, 860.67, 860.67)
)

TRUE

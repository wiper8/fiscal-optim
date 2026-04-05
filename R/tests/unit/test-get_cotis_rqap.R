source("R/src/get_cotis_rqap.R")

expect_equal(
  get_cotis_rqap(c(0, 50000, 100000, 500000)),
  c(0, 247, 484.12, 484.12)
)

TRUE

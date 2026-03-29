source("R/src/get_cotis_rrq.R")

expect_equal(
  get_cotis_rrq(73, 80000),
  list("box17" = 0, "box17A" = 0)
)

expect_equal(
  get_cotis_rrq(30, c(3000, 4000, 60000, 71300, 75000, 80000, 90000, 100000, 1000000)),
  list(
    "box17" = c(0, 32, 3616, 4339.2, 4339.2, 4339.2, 4339.2, 4339.2, 4339.2),
    "box17A" = c(0, 0, 0, 0, 148, 348, 396, 396, 396)
  )
)

TRUE

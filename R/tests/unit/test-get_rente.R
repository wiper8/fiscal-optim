source("R/src/get_rente.R")

expect_equal(
  get_rente(65,
            0,
            0),
  0
)
expect_equal(
  get_rente(64,
            c(4000, 50000, 70000, 80000, 90000, 100000, 200000),
            2),
  0
)
expect_equal(
  get_rente(65,
            50000,
            2),
  1500
)
expect_equal(
  get_rente(70,
            70000,
            5),
  5250
)
expect_equal(
  get_rente(75,
            c(0, 78000, 0, 82000, 0, 70000, 80000, 0, 90000),
            15),
  18652.5
)
expect_equal(
  get_rente(65,
            200000,
            45),
  163957.5
)

TRUE

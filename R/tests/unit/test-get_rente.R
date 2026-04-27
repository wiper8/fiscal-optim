source("R/src/get_rente.R")

expect_equal(
  get_rente(
    65,
    0,
    0,
    1.02
  ),
  0
)
expect_equal(
  get_rente(
    64,
    c(4000, 50000, 70000, 80000, 90000, 100000, 200000),
    2,
    1.02
  ),
  0
)
expect_equal(
  get_rente(
    65,
    50000,
    2,
    1.02
  ),
  1500
)
expect_equal(
  get_rente(
    70,
    70000,
    5,
    1.02
  ),
  4755.09,
  tolerance = 0.01,
  scale = 1
)
expect_equal(
  get_rente(
    75,
    c(0, 78000, 0, 82000, 0, 70000, 80000, 0, 90000),
    15,
    1.02
  ),
  15301.55,
  tolerance = 0.01,
  scale = 1
)
expect_equal(
  get_rente(
    65,
    200000,
    45,
    1.02
  ),
  163957.5
)
# on atteint le maximum
expect_equal(
  get_rente(
    65,
    220000,
    45,
    1.02
  ),
  169050.15
)

TRUE

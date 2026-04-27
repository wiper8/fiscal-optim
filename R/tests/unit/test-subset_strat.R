source("R/src/optim/maximise_utils.R")

expect_equal(
  subset_strat(1:4, 1:1, c(1, 5) + 25),
  1:4
)
expect_equal(
  subset_strat(1:4, 1:19, c(1, 19) + 25),
  1:4
)
expect_equal(
  subset_strat(1:4, 1:21, c(1, 21) + 25),
  1:4
)
expect_equal(
  subset_strat(1:4, 1:35, c(1, 35) + 25),
  1:4
)

expect_equal(
  subset_strat(1:8, 1:35, c(1, 33, 40) + 25),
  1:8
)
expect_equal(
  subset_strat(1:8, 1:35, c(1, 36, 40) + 25),
  1:4
)

expect_equal(
  subset_strat(1:12, 1:35, c(1, 12, 36, 40) + 25),
  1:8
)

expect_equal(
  subset_strat(1:20, 1:2, 1:6 + 25),
  1:8
)
expect_equal(
  subset_strat(1:20, c(1, 3), 1:6 + 25),
  c(1:4, 9:12)
)
expect_equal(
  subset_strat(20:1, c(2, 8, 9, 14), c(25, 32, 40, 60, 65, 70)),
  c(20:17, 16:13)
)

TRUE

source("R/src/get_prest_psv.R")

stopifnot(
  all.equal(
    get_prest_psv(c(-10, 0, 5, 20, 50, 60, 64, 65, 66, 74, 75, 76, 110)),
    c(0, 0, 0, 0, 0, 0, 0, rep(8907.72, 3), rep(9798.48, 3))
  )
)

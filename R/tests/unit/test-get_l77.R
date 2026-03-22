source("R/src/impot/get_l77.R")

## les montants à la ligne 77 sont exacts
stopifnot(
  all.equal(
    get_l77(0),
    0
  )
)

stopifnot(
  all.equal(
    get_l77(25000),
    3625,
    tolerance = 0.01,
    scale = 1
  )
)

stopifnot(
  all.equal(
    get_l77(80000),
    12957.505,
    tolerance = 0.01,
    scale = 1
  )
)

stopifnot(
  all.equal(
    get_l77(150000),
    29246.25,
    tolerance = 0.01,
    scale = 1
  )
)

stopifnot(
  all.equal(
    get_l77(220000),
    48709.79,
    tolerance = 0.01,
    scale = 1
  )
)

stopifnot(
  all.equal(
    get_l77(400000),
    106773.23,
    tolerance = 0.01,
    scale = 1
  )
)

# la fonction est croissante monotone
stopifnot(
  (sapply(seq(0, 300000, 100), get_l77) |>
      diff() |>
      min()) > 0
)

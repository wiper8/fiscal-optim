source("R/src/get_droits_reer.R")

expect_equal(
  # TODO salaires entre le plafond REER et salaire qui donne un droits de REER de 0
  get_droits_reer(c(5000, 30000, 60000, 70000, 80000, 100000, 150000, 180500, 250000, 1000000)),
  c(825, 1950, 3300, 3750, 3808.5, 3808.5, 3808.5, 3808.5, 0, 0)
)

TRUE

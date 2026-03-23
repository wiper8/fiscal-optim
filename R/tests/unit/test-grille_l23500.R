source("R/src/impot/fed/grille_l23500.R")

grille_l23500 <- function(l11300, l23400) {
  l1 <- l11300 # PSV
  l15 <- l6 <- l23400 # revenu net avant rajustements <- revenu net rajusté
  l16 <- 93454 # montant de base PSV : seuil de revenu avant impôt de récupération
  l18 <- 0.15 * pmax(0, l15 - l16)
  pmin(l1, l18)
}

expect_equal(
  grille_l23500(5000, -50000),
  0
)

expect_equal(
  grille_l23500(0, 0),
  0
)

expect_equal(
  grille_l23500(0, 1000000),
  0
)

expect_equal(
  grille_l23500(5000, 0),
  0
)

expect_equal(
  grille_l23500(5000, 1000000),
  5000
)

expect_equal(
  grille_l23500(5000, 101000),
  1131.9
)

expect_equal(
  grille_l23500(5000, 150000),
  5000
)

TRUE

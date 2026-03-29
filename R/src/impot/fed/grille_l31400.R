# Montant pour revenu de pension
grille_l31400 <- function(l11500, l12900, age) {
  l5 <- 0
  l7 <- (age >= 65) * l12900
  l8 <- l11500 - l5 + l7
  pmin(2000, l8)
}

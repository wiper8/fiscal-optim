# montant en raison de l'âge
grille_l30100 <- function(age, l23600) {
  (age >= 65) * pmax(0, 9028 - 0.15 * pmax(0, l23600 - 45522))
}

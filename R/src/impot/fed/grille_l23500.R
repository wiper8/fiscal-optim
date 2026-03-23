# remboursement des prestations de programmes sociaux
grille_l23500 <- function(l11300, l23400) {
  l1 <- l11300 # PSV
  l15 <- l6 <- l23400 # revenu net avant rajustements <- revenu net rajusté
  l16 <- 93454 # montant de base PSV : seuil de revenu avant impôt de récupération
  l18 <- 0.15 * pmax(0, l15 - l16)
  pmin(l1, l18)
}

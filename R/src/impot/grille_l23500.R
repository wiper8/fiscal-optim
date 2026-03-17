grille_l23500 <- function(l11300, l23400) {
  l16 <- 93454
  pmin(
    l11300, # PSV reçue
    0.15 * pmax(0, l23400 - l16) # revenu net avant rajustement - seuil
  )
}

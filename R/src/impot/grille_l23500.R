grille_l23500 <- function(l11300, l23400) {
  l16 <- 93454
  condition_remplissage <- (l23400 > 82125) | # revenu net avant rajustement de 82125
    (l11300 > 0 & l23400 > l16) # j'ai recu PSV ET j'ai recu plus de 93454$
  if (!condition_remplissage) return(0)
  
  pmin(
    l11300, # PSV reçue
    0.15 * pmax(0, l23400 - l16) # revenu net avant rajustement - seuil
  )
}

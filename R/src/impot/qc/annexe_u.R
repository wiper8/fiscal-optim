# RRQ
annexe_u <- function(revenu_emploi, l98, l98_1, l98_2) {
  # TODO suppose que les intrants sont conformes aux cotisations selon revenu_emploi
  # TODO vérifier
  l10 <- pmin(4339.2, l98)
  l11 <- l10 * 0.156250
  l12 <- pmin(71300, l98_1)
  l13 <- 3500
  l14 <- l12 - l13
  l14_1 <- 71300
  l14_2 <- l13
  l14_3 <- pmax(0, l14_1 - l14_2)
  l17_1 <- l14_4 <- pmin(l14, l14_3)
  l15 <- 0.01 * l14_4
  l16 <- pmin(l11, l15)
  l17 <- l98
  l17_2 <- 0.064 * l17_1
  l17_3 <- pmax(0, l17 - l17_2)
  l17_4 <- l98_2
  l17_5 <- l17_3 + l17_4
  l18_5 <- l98_1
  l18_9 <- l18_6 <- l14_1
  l18_7 <- pmax(0, l18_5 - l18_6)
  l18_8 <- 81200
  l19 <- pmax(0, l18_8 - l18_9)
  l20 <- pmin(l18_7, l19)
  l21 <- 0.04 * l20
  l22 <- pmin(l17_5, l21)
  l22_1 <- l16
  l22 + l22_1
}

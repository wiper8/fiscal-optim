# RRQ
# TODO possible entre 60 et 70 ans de choisir de cesser de cotiser au RRQ
annexe_8 <- function(age, revenu_emploi, t4_17, t4_17a) {
  ### partie 1
  # A simplifié vu que je considère tout en date du 1er janvier, le nombre de mois est toujours 0 ou 12
  b <- 71300 * (age < 73)
  c <- 9900 * (age < 73)
  d <- 81200 * (age < 73)
  e <- 3500 * (age < 73)
  
  ### partie 2
  l50329 <- revenu_emploi
  l2 <- pmin(d, l50329)
  l4 <- pmax(0, l2 - b)
  l5 <- l2 - l4
  l7 <- pmax(0, l5 - e)
  l8 <- t4_17
  l9 <- 0.84375 * l8 # 0.84375 = 0.054 / (0.054 + 0.01)
  l10 <- l8 - l9
  l11 <- 0.054 * l7
  l12 <- 0.01 * l7
  l13 <- l11 + l12
  l14 <- l9
  l15 <- l11
  l16 <- l14 - l15
  l17 <- l10
  l18 <- l12
  l19 <- l17 - l18
  l20 <- l16 + l19
  l50331 <- l21 <- t4_17a
  l22 <- 0.04 * l4
  l23 <- l21 - l22
  l24 <- l20 + l23
  
  ## partie 2b
  # TODO suppose que les intrants t4_17 et t4_17a sont conformes aux cotisations selon revenu_emploi
  l35 <- l29 <- l15
  # suite
  l42 <- l36 <- l18
  l46 <- l43 <- l22
  l47 <- l42 + l46
  list(l30800 = l35, l22215 = l47)
}

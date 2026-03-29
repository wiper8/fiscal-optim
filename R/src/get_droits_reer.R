source("R/src/get_rente.R")

# droits de cotisation REER
get_droits_reer <- function(revenu_emploi, ...) {
  plafond_reer <- 32490
  prestation_acquise <- sapply(revenu_emploi, get_rente, age = 65, annees_travaillees = 1, ...)
  facteur_equiv <- pmax(0, 9 * prestation_acquise - 600)
  pmax(0, pmin(0.18 * revenu_emploi, plafond_reer) - facteur_equiv)
}

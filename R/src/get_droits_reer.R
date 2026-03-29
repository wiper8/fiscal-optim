source("R/src/get_rente.R")

# droits de cotisation REER
get_droits_reer <- function(revenu_emploi) {
  plafond_reer <- 32490
  # nolint: https://www.canada.ca/fr/agence-revenu/services/impot/administrateurs-regimes-enregistres/fesp/plafonds-cd-reer-rpdb-celi-mgap.html
  plafond_annuel_des_PD_facteur_equiv <- 3756.67
  prestation_acquise <- pmin(
    plafond_annuel_des_PD_facteur_equiv,
    sapply(revenu_emploi, get_rente, age = 65, annees_travaillees = 1)
  )
  facteur_equiv <- pmax(0, 9 * prestation_acquise - 600)
  pmax(0, pmin(0.18 * revenu_emploi, plafond_reer) - facteur_equiv)
}

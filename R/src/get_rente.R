# rente d'employeur
get_rente <- function(age, salaires, annees_travaillees) {
  # nolint: https://www.canada.ca/fr/agence-revenu/services/impot/administrateurs-regimes-enregistres/fesp/plafonds-cd-reer-rpdb-celi-mgap.html
  plafond_annuel_des_PD_facteur_equiv <- 3756.67
  
  mga <- 71300
  mean_5_salaires <- mean(tail(sort(salaires), 5))
  (age >= 65) * (
    annees_travaillees * pmin(
      plafond_annuel_des_PD_facteur_equiv,
      0.015 * pmin(mga, mean_5_salaires) +
        0.02 * pmax(0, mean_5_salaires - mga)
    )
  )
}

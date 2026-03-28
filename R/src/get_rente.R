# rente d'employeur
get_rente <- function(age, salaires, annees_travaillees) {
  mga <- 71300
  mean_5_salaires <- mean(tail(sort(salaires), 5))
  (age >= 65) * (
    annees_travaillees * (
      0.015 * pmin(mga, mean_5_salaires) +
        0.02 * pmax(0, mean_5_salaires - mga)
    )
  )
}

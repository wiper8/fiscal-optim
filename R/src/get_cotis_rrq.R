# cotisations retenues par l'employeur
get_cotis_rrq <- function(age, revenu_emploi, ...) {
  b <- 71300 * (age < 73)
  c <- 9900 * (age < 73)
  d <- 81200 * (age < 73)
  e <- 3500 * (age < 73)

  salaire_plafond <- pmin(d, revenu_emploi)
  cotisable_supp <- pmax(0, salaire_plafond - b)
  cotisable_brut <- salaire_plafond - cotisable_supp
  cotisable <- pmax(0, cotisable_brut - e)
  list("box17" = (0.054 + 0.01) * cotisable, "box17A" = 0.04 * cotisable_supp)
}

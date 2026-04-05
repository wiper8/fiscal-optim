# cotisations retenues par l'employeur
get_cotis_rqap <- function(revenu_emploi) {
  0.00494 * pmin(98000, revenu_emploi)
}

# cotisations retenues par l'employeur
get_cotis_ae <- function(revenu_emploi) {
  0.0131 * pmin(65700, revenu_emploi)
}

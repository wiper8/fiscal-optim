# cotisation annuelle au régime de rente employeur
get_cotis_rente <- function(salaire) {
  mga <- 71300
  # TODO petit incohérence si revenu très élevé : la rente pourrait être limitées vers 200k, mais les cotisations
  # continueraient à augmenter (payer dans le vide)
  cotis_rente_yield1 * pmin(mga, salaire) + cotis_rente_yield2 * pmax(0, salaire - mga)
}

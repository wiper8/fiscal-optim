# cotisation annuelle au régime de rente employeur
cotis_rente <- function(salaire) {
  mga <- 71300
  cotis_rente_yield1 * pmin(mga, salaire) + cotis_rente_yield2 * pmax(0, salaire - mga)
}

# RRQ
source("R/src/get_cotis_rrq.R")

annexe_u <- function(revenu_emploi) {
  # TODO ceci suppose que les intrants sont conformes aux cotisations selon revenu_emploi (que l'employeur met déjà)
  # les déductions parfaites pour le RRQ
  tmp <- get_cotis_rrq(age = 30, revenu_emploi) # TODO approximation à cause de l'âge < 73 ans
  l98 <- tmp$box17
  l98_2 <- tmp$box17A

  # 98_1 est le revenu d'emploi admis. au RRQ, 98 sont les cotisations versées au RRQ base, 98_2 est les cotis au supp
  base_rate1 <- 0.054
  supp_rate1 <- 0.01
  # cotisations au régime supplémentaire RRQ (1% et 4%)
  l98_2 + supp_rate1 / (supp_rate1 + base_rate1) * l98
}

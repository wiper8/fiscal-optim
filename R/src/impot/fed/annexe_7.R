# REER
annexe_7 <- function(cotisations_inutilisees_versees_dispo_a_deduire,
                     cotisations_versees_reer,
                     deduction_reer,
                     max_deductible_reer) {
  # partie A
  # cotisation REER
  l1 <- cotisations_inutilisees_versees_dispo_a_deduire
  l24500 <- l2 <- pmax(0, cotisations_versees_reer)

  l5 <- l1 + l24500
  
  # partie B
  # pour RAP
  l10 <- l6 <- l5
  
  # partie C
  # déduction pour REER
  l11 <- max_deductible_reer
  l17 <- pmin(l10, l11)
  l18 <- deduction_reer
  stopifnot(l18 <= l17)
  l20800 <- l20 <- pmin(l10, l18)

  # partie D
  # cotisations inutilisées versées à un REER disponibles à reporter
  cotis_inutil_vers_disp_deduc <- l10 - l20

  list(l20800 = l20800, l24500 = l24500, cotis_inutil_vers_disp_deduc = cotis_inutil_vers_disp_deduc)
}

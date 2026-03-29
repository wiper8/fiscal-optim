source("R/src/impot/qc/grille_201.R")
source("R/src/impot/qc/grille_401.R")
source("R/src/impot/qc/annexe_g.R")

impot_provincial <- function(
    revenu_emploi, gain_capital_imposable, revenus_reer, l20800, dividends, interests, rente_emploi, cotis_rente,
    pension_psv, prestation_rrq, cotis_rrq, psv_clawback,
    ...
) {
  # revenu total
  l101 <- revenu_emploi
  l114 <- pension_psv
  l119 <- prestation_rrq
  l122 <- rente_emploi + revenus_reer # le FERR irait ici, mais pour simplifier, je le laisse dans le revenus_reer
  l128 <- dividends
  l130 <- interests
  l139 <- annexe_g(gain_capital_imposable)
  l199 <- l101 + l114 + l119 + l122 + l128 + l130 + l139 # revenu total

  # revenu net
  l201 <- grille_201(l101) # déduction pour travailleur
  l205 <- cotis_rente # déduction pour régime de pension agréé (RPA)
  l214 <- l20800 # déduction reer
  l248 <- annexe_u(revenu_emploi, cotis_rrq$box17, cotis_rrq$box17A)
  l250 <- psv_clawback
  l254 <- l201 + l205 + l214 + l248 + l250 # total des déductions
  l275 <- pmax(0, l199 - l254) # revenu net

  # revenu imposable
  l279 <- l275 # revenu net
  l299 <- pmax(0, l279) # revenu imposable

  # crédits d'impôt non remboursables
  l350 <- 18571 # montant personnel de base
  l377_1 <- 0.14 * l350
  l399 <- l377_1 # crédits d'impôt non remboursables

  # impôts et cotisations
  l401 <- grille_401(l299) # impôt sur le revenu
  l413 <- l401 - l399
  l430 <- l413
  l432 <- pmax(0, l430)
  l450 <- l432 # impôt et cotisations

  # remboursement ou solde à payer
  l468 <- 0 # impôt, cotisations et retenues à la source déjà payées
  l475 <- l470 <- l450 - l468
  l475 # solde à payer
}

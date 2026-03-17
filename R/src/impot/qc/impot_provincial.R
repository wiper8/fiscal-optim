source("R/src/impot/qc/grille_201.R")
source("R/src/impot/qc/grille_401.R")
source("R/src/impot/qc/annexe_g.R")

impot_provincial <- function(revenu_emploi, gain_capital_imposable, pension_psv, ...) {
  # revenu total
  l101 <- revenu_emploi
  l114 <- pension_psv
  l139 <- annexe_g(gain_capital_imposable)
  l199 <- l101 + l114 + l139
  
  # revenu net
  l201 <- grille_201(l101)
  
  l254 <- l201
  l256 <- l199 - l254
  l275 <- pmax(0, l256)

  # revenu imposable
  l279 <- l275
  l299 <- pmax(0, l279)
  
  # crédits d'impôt non remboursables
  l350 <- 18571
  l377.1 <- 0.14 * l350
  l399 <- l377.1
  
  # impôts et cotisations
  l401 <- grille_401(l299)
  l413 <- l401 - l399
  l450 <- l413
  
  # remboursement ou solde à payer
  l468 <- 0
  l475 <- l470 <- l450 - l468
  l475
}

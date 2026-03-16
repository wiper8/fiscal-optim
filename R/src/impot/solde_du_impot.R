source("R/src/impot/annexe_3.R")
source("R/src/impot/grille_l30000.R")
source("R/src/impot/grille_l30100.R")
source("R/src/impot/grille_l34990.R")

TABLE_IMPOT <- matrix(
  c(
    0.145, 0.205, 0.26, 0.29, 0.33,
    0, 57375, 114750, 177882, 253414
  ),
  nrow = 2, byrow = TRUE
)

solde_du_impot <- function(age, revenu_emploi, gain_capital_imposable) {
  # revenu total
  l10100 <- revenu_emploi
  l12700 <- annexe_3(gain_capital_imposable)
  l15000 <- l10100 + l12700
  
  # revenu net
  l23400 <- l15000
  l23600 <- pmax(0, l23400)

  # revenu imposable
  l26000 <- pmax(0, l23600)
  
  # impot federal
  l77 <- TABLE_IMPOT[1, 1] * pmin(l26000, TABLE_IMPOT[2, 2]) +
    TABLE_IMPOT[1, 2] * pmax(0, pmin(l26000, TABLE_IMPOT[2, 3]) - TABLE_IMPOT[2, 2]) +
    TABLE_IMPOT[1, 3] * pmax(0, pmin(l26000, TABLE_IMPOT[2, 4]) - TABLE_IMPOT[2, 3]) +
    TABLE_IMPOT[1, 4] * pmax(0, pmin(l26000, TABLE_IMPOT[2, 5]) - TABLE_IMPOT[2, 4]) +
    TABLE_IMPOT[1, 5] * pmax(0, l26000 - TABLE_IMPOT[2, 5])

  # crédits d'impot non rembousables
  l30000 <- grille_l30000(l23600) # montant personnel de base
  l30100 <- grille_l30100(age, l23600) # montant pour l'âge
  
  # montant canadien pour emploi
  l31260 <- min(1471, l10100)
  l33500 <- l30000 + l30100 + l31260
  
  l118 <- TABLE_IMPOT[1, 1]
  l33800 <- l33500 * l118
  l34990 <- grille_l34990(l33800)
  l35000 <- l33800 + l34990
  
  # impôt fédéral net
  # Impot fédéral de base
  l42000 <- l40600 <- l42900 <- pmax(0, l77 - l35000)
  
  # remboursement ou solde dû
  # impot provincial (autres que QC) donc 0 car c'est revenu québec qui le recoit, pas le fédéral
  l42800 <- 0
  l43500 <- l42000 + l42800 # Total à payer
  
  l43850 <- 0
  l44000 <- 0.165 * l42900
  l48200 <- l43850 + l44000
  l48500 <- l43500 - l48200
  l48500
}

source("R/src/impot/fed/annexe_3.R")
source("R/src/impot/fed/get_l77.R")
source("R/src/impot/fed/grille_l12000.R")
source("R/src/impot/fed/grille_l12100.R")
source("R/src/impot/fed/grille_l23500.R")
source("R/src/impot/fed/grille_l30000.R")
source("R/src/impot/fed/grille_l30100.R")
source("R/src/impot/fed/grille_l31400.R")
source("R/src/impot/fed/grille_l34990.R")

solde_du_impot <- function(age, revenu_emploi, gain_capital_imposable, dividends, interests,
                           rente_emploi, cotis_rente, pension_psv) {
  # revenu total
  l10100 <- revenu_emploi
  l11300 <- pension_psv
  l11500 <- rente_emploi
  l12000 <- grille_l12000(dividends)
  l12100 <- grille_l12100(interests)
  l12700 <- annexe_3(gain_capital_imposable)
  l15000 <- l10100 + l11300 + l11500 + l12000 + l12100 + l12700

  # revenu net
  l20700 <- cotis_rente # déduction régime de pension agréés (RPA)
  l23300 <- l20700
  l23400 <- l15000 - l23300 # revenu net avant rajustements
  l23500 <- l42200 <- grille_l23500(l11300, l23400) # remboursement des prestations de programmes sociaux
  l23600 <- pmax(0, l23400 - l23500) # revenu net

  # revenu imposable
  l26000 <- pmax(0, l23600)

  # impot federal
  l77 <- get_l77(l26000)

  # crédits d'impot non rembousables
  l30000 <- grille_l30000(l23600) # montant personnel de base
  l30100 <- grille_l30100(age, l23600) # montant pour l'âge

  # montant canadien pour emploi
  l31260 <- min(1471, l10100)
  l31400 <- grille_l31400(l11500, l12900 = 0, age) # montant pour revenu de pension
  l33500 <- l30000 + l30100 + l31260 + l31400

  l118 <- 0.145
  l33800 <- l33500 * l118
  l34990 <- grille_l34990(l33800) # crédit d'impôt compensatoire
  l35000 <- l33800 + l34990 # total crédits d'impôt non remboursables fédéraux

  # impôt fédéral net
  l42000 <- l40600 <- l42900 <- pmax(0, l77 - l35000)

  # remboursement ou solde dû
  l42800 <- 0 # impot provincial (autres que QC) donc 0 car c'est revenu québec qui le recoit, pas le fédéral
  l43500 <- l42000 + l42200 + l42800 # Total à payer

  l43850 <- 0
  l44000 <- 0.165 * l42900
  l48200 <- l43850 + l44000 # total des crédits
  l48500 <- l43500 - l48200 # solde dû
  list(l48500 = l48500, l23500 = l23500)
}

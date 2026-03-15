source("R/src/impot/solde_du_impot.R")

get_revenu_disponible <- function(
    revenu_emploi = 0,
    nonenr_capital_vendu = 0,
    nonenr_gain_vendu = 0
) {
  
  solde_impot <- solde_du_impot()
  
  revenu_emploi +
    nonenr_capital_vendu +
    nonenr_gain_vendu -
    solde_impot
}
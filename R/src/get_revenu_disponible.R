source("R/src/get_prest_psv.R")
source("R/src/impot/solde_du_impot.R")
source("R/src/impot/qc/impot_provincial.R")

get_revenu_disponible <- function(
    revenu_emploi = 0,
    nonenr_capital_vendu = 0,
    nonenr_gain_vendu = 0,
    pension_psv = 0,
    ...
) {
  
  solde_impot_fed <- solde_du_impot(revenu_emploi, nonenr_gain_vendu, pension_psv, ...)
  solde_impot_prov <- impot_provincial(revenu_emploi, nonenr_gain_vendu, pension_psv, ...)
  
  revenu_emploi +
    pension_psv +
    nonenr_capital_vendu +
    nonenr_gain_vendu -
    solde_impot_fed -
    solde_impot_prov
}

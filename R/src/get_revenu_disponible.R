source("R/src/cotis_rente.R")
source("R/src/impot/fed/solde_du_impot.R")
source("R/src/impot/qc/impot_provincial.R")

# revenu total après avoir payé l'impôt
get_revenu_disponible <- function(
  revenu_emploi = 0,
  nonenr_capital_vendu = 0,
  nonenr_gain_vendu = 0,
  revenus_reer = 0,
  dividends = 0,
  interests = 0,
  rente_emploi = 0,
  pension_psv = 0,
  ...
) {

  cotis_rente <- cotis_rente(revenu_emploi)
   # TODO bug ici
  solde_impot_fed <- solde_du_impot(
    # TODO inclure dans les 2 formules de solde d'impot les revenus de rentes d'emploi et les cotisation de rente
    revenu_emploi, nonenr_gain_vendu, revenus_reer, dividends, interests, rente_emploi, cotis_rente, pension_psv, ...
  )
  solde_impot_prov <- impot_provincial(
    revenu_emploi, nonenr_gain_vendu, revenus_reer, dividends, interests, rente_emploi, cotis_rente, pension_psv,
    solde_impot_fed$l23500, ...
  )

  revenu_emploi +
    nonenr_capital_vendu +
    nonenr_gain_vendu +
    dividends +
    interests +
    rente_emploi -
    cotis_rente +
    pension_psv -
    solde_impot_fed$l48500 -
    solde_impot_prov
}

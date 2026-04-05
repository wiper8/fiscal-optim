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
  prestation_rrq = 0,
  ...
) {

  cotis_rente <- cotis_rente(revenu_emploi)
  cotis_rrq <- get_cotis_rrq(revenu_emploi, ...)

  solde_impot_fed <- solde_du_impot(
    revenu_emploi = revenu_emploi, gain_capital_imposable = nonenr_gain_vendu, revenus_reer = revenus_reer,
    dividends = dividends, interests = interests, rente_emploi = rente_emploi, cotis_rente = cotis_rente,
    pension_psv = pension_psv, prestation_rrq = prestation_rrq,
    ...
  )

  solde_impot_prov <- impot_provincial(
    revenu_emploi = revenu_emploi, gain_capital_imposable = nonenr_gain_vendu, revenus_reer = revenus_reer,
    dividends = dividends, interests = interests, rente_emploi = rente_emploi, cotis_rente = cotis_rente,
    pension_psv = pension_psv, prestation_rrq = prestation_rrq, cotis_rrq = cotis_rrq,
    psv_clawback = solde_impot_fed$l23500,
    ...
  )

  revenu_emploi +
    nonenr_capital_vendu +
    nonenr_gain_vendu +
    dividends +
    interests +
    rente_emploi -
    cotis_rente +
    pension_psv +
    prestation_rrq -
    cotis_rrq$box17 - cotis_rrq$box17A -
    solde_impot_fed$l48500 -
    solde_impot_prov
}

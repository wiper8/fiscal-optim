source("R/src/get_revenu_disponible.R")

fake_get_cotis_rente <- mock(2, 2)
fake_get_cotis_ae <- mock(0.25, 0.25)
fake_get_cotis_rqap <- mock(0.5, 0.5)
fake_solde_du_impot <- mock(list(l48500 = 1, l23500 = NA), list(l48500 = 1000000, l23500 = NA))
fake_impot_provincial <- mock(7, 7)

# remplacer les fonctions internes dans get_revenu_disponible()
stub(get_revenu_disponible, "get_cotis_rente", fake_get_cotis_rente)
stub(get_revenu_disponible, "get_cotis_ae", fake_get_cotis_ae)
stub(get_revenu_disponible, "get_cotis_rqap", fake_get_cotis_rqap)
stub(get_revenu_disponible, "solde_du_impot", fake_solde_du_impot)
stub(get_revenu_disponible, "impot_provincial", fake_impot_provincial)

expect_equal(
  get_revenu_disponible(
    revenu_emploi = 10,
    nonenr_capital_vendu = 100,
    nonenr_gain_vendu = 1000,
    dividends = 25,
    interests = 50,
    pension_psv = 10000,
    age = 60
  ),
  11174.25
)

# test que le revenu peut être négatif si on doit de l'impôt
expect_equal(
  get_revenu_disponible(
    revenu_emploi = 10,
    nonenr_capital_vendu = 100,
    nonenr_gain_vendu = 1000,
    dividends = 25,
    interests = 50,
    pension_psv = 10000,
    age = 60
  ),
  -988824.75
)

TRUE

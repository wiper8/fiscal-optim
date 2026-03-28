source("R/src/get_revenu_disponible.R")

fake_solde_du_impot <- mock(list(l48500 = 1, l23500 = NA), list(l48500 = 1000000, l23500 = NA))
fake_impot_provincial <- mock(7, 7)

# remplacer les fonctions internes dans get_revenu_disponible()
stub(get_revenu_disponible, "solde_du_impot", fake_solde_du_impot)
stub(get_revenu_disponible, "impot_provincial", fake_impot_provincial)

expect_equal(
  get_revenu_disponible(
    revenu_emploi = 10,
    nonenr_capital_vendu = 100,
    nonenr_gain_vendu = 1000,
    dividends = 25,
    interests = 50,
    pension_psv = 10000
  ),
  11177
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
  -988822
)

TRUE

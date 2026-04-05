source("R/src/impot/fed/solde_du_impot.R")

# rien de spécial
expect_equal(
  solde_du_impot(
    age = 25, revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0
  )$l48500,
  3453,
  tolerance = 3453 * 0.1,
  scale = 1
)

# gain capital, intérêts, dividendes
expect_equal(
  solde_du_impot(
    age = 25, revenu_emploi = 30000, gain_capital_imposable = 10000, revenus_reer = 0, l20800 = 0, dividends = 10000,
    interests = 5000, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0
  )$l48500,
  3652,
  tolerance = 3652 * 0.1,
  scale = 1
)

# revenus reer
expect_equal(
  solde_du_impot(
    age = 25, revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 20000, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0
  )$l48500,
  6484,
  tolerance = 6484 * 0.1,
  scale = 1
)

# déduction reer
expect_equal(
  solde_du_impot(
    age = 25, revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 20000, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0
  )$l48500,
  1032,
  tolerance = 1032 * 0.11,
  scale = 1
)

# rentes
expect_equal(
  solde_du_impot(
    age = 60, revenu_emploi = 20000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 10000, cotis_rente = 0, pension_psv = 10000, prestation_rrq = 10000
  )$l48500,
  3751,
  tolerance = 3751 * 0.1,
  scale = 1
)

expect_equal(
  solde_du_impot(
    age = 60, revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 20000, pension_psv = 0, prestation_rrq = 0
  )$l48500,
  1032,
  tolerance = 1032 * 0.11,
  scale = 1
)

TRUE

source("R/src/impot/qc/impot_provincial.R")

# TODO

# rien de spécial
expect_equal(
  impot_provincial(
    revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0, cotis_rrq = 2976,
    cotis_rqap = 0, psv_clawback = 0
  ),
  4136,
  tolerance = 4136 * 0.1,
  scale = 1
)

# gain capital, intérêts, dividendes
expect_equal(
  impot_provincial(
    revenu_emploi = 30000, gain_capital_imposable = 10000, revenus_reer = 0, l20800 = 0, dividends = 10000,
    interests = 5000, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0, cotis_rrq = 2976,
    cotis_rqap = 0, psv_clawback = 0
  ),
  4183,
  tolerance = 4183 * 0.1,
  scale = 1
)

# revenus reer
expect_equal(
  impot_provincial(
    revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 20000, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0, cotis_rrq = 2976,
    cotis_rqap = 0, psv_clawback = 0
  ),
  7698,
  tolerance = 7698 * 0.1,
  scale = 1
)

# déduction reer
expect_equal(
  impot_provincial(
    revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 20000, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 0, pension_psv = 0, prestation_rrq = 0, cotis_rrq = 2976,
    cotis_rqap = 0, psv_clawback = 0
  ),
  1336,
  tolerance = 1336 * 0.1,
  scale = 1
)

# rente
expect_equal(
  impot_provincial(
    revenu_emploi = 20000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 10000, cotis_rente = 0, pension_psv = 10000, prestation_rrq = 10000, cotis_rrq = 0,
    cotis_rqap = 0, psv_clawback = 0
  ),
  4328,
  tolerance = 4328 * 0.1,
  scale = 1
)

expect_equal(
  impot_provincial(
    revenu_emploi = 50000, gain_capital_imposable = 0, revenus_reer = 0, l20800 = 0, dividends = 0,
    interests = 0, rente_emploi = 0, cotis_rente = 20000, pension_psv = 0, prestation_rrq = 0, cotis_rrq = 0,
    cotis_rqap = 0, psv_clawback = 0
  ),
  1336,
  tolerance = 1336 * 0.1,
  scale = 1
)

TRUE

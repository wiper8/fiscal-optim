source("R/src/try_strategy.R")

start_age <- 25
max_age <- 25
inflation <- 1.0275
ipc <- 1.02
rendement_brut <- 1.07
dividend_yield <- 0.01
rendement <- rendement_brut / inflation
rendement_cash <- 1.0055
cotis_rente_yield1 <- 0.05
cotis_rente_yield2 <- 0.06

fake_get_rente <- mock(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
passed_work_years <- NULL
fake_get_prest_psv <- mock(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
fake_get_prest_rrq <- mock(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
stub(try_strategy, "get_rente", fake_get_rente)
stub(try_strategy, "get_prest_psv", fake_get_prest_psv)
stub(try_strategy, "get_prest_rrq", fake_get_prest_rrq)

actifs <- list(
  cash = 500000,
  nonenr_capital = 100000,
  nonenr_gain = 200000,
  celi = list(
    contrib_yearly = 7000,
    contrib_lim = 4500,
    current_value = 48000
  ),
  reer = list(
    contrib_rate = 0.18,
    plafond = 32490,
    droits_cotis_inutilises = 6000,
    cotis_versees_non_deduites = 0,
    current_value = 50000
  )
)

revenus <- data.frame(age = 24, revenu_emploi = 60000)
depenses <- data.frame(depenses = 40000)

expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(50000, 0, 0, 0, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 1],
  150000
)

expect_equivalent(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 300000, 0, 0, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 1:2],
  c(0, 0)
)

# trop de cotisations dans le CELI
expect_error(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 50000, 0, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )
)

# cotiser celi
expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 7000, 0, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 4],
  57824.97,
  tolerance = 1,
  scale = 1
)

# retrait celi
expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, -48000, 0, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 4],
  0
)

# cotisation REER trop grande
expect_error(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 0, 17000, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )
)

# cotisation REER sans déduction
expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 0, 3300, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 5],
  56037.62,
  tolerance = 0.001
)

# cotisation REER avec déduction
expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 0, 3300, 3300),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 5],
  56037.62,
  tolerance = 0.001
)

# retrait REER suivi d'une grande cotisation : on ne récupère pas ses droits de cotisation
expect_error(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 0, -50000, 17000),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )
)

# retrait REER
expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 0, -50000, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 5],
  0
)

# cash
actifs$cash <- 20000
fake_cotis_rente <- mock(4000, 4000)
fake_get_cotis_rrq <- mock(list(box17 = 2000, box17A = 1500), list(box17 = 2000, box17A = 1500))
fake_solde_du_impot <- mock(list(l48500 = 6000, l23500 = 0), list(l48500 = 6000, l23500 = 0))
fake_impot_provincial <- mock(8000, 8000)

stub(get_revenu_disponible, "cotis_rente", fake_cotis_rente)
stub(get_revenu_disponible, "get_cotis_rrq", fake_get_cotis_rrq)
stub(get_revenu_disponible, "solde_du_impot", fake_solde_du_impot)
stub(get_revenu_disponible, "impot_provincial", fake_impot_provincial)

expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(0, 0, 0, 0, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 3],
  # nolint (cash + salaire - impotestim&RRQ&rente - depenses + dividendes_interest) * rendement_cash
  (20000 + revenus$revenu_emploi - (6000 + 8000 + 4000 + 3500) - depenses$depenses +
     (actifs$nonenr_capital + actifs$nonenr_gain) * dividend_yield) * rendement_cash / ipc,
  tolerance = 500,
  scale = 1
)

# cash plus complexe
expect_equal(
  try_strategy(
    actifs = actifs,
    revenus = revenus,
    depenses = depenses,
    strategy = matrix(
      c(10000, 7500, 4000, -10000, 0),
      nrow = 1,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    ),
    passed_revenus = NULL
  )[2, 3],
  # nolint (cash + nonenr - celi + reer + salaire - impotestim&RRQ&rente - depenses + dividendes_interest) * rendement_cash
  (20000 + (7500 - 10000) - 4000 + 10000 + revenus$revenu_emploi - (15093 + 3616 + 3000) - depenses$depenses +
     (actifs$nonenr_capital + actifs$nonenr_gain) * dividend_yield) * rendement_cash / ipc,
  tolerance = 500,
  scale = 1
)

TRUE

source("R/src/manage_nonenr.R")

# compte non enregistré vide sans cotisation ni vente
expect_equal(
  manage_nonenr(nonenr_capital = 0, nonenr_gain = 0, cotis = 0, sell = 0),
  list(
    capital_vendu = 0,
    gain_en_capital_vendu = 0,
    new_actifs = list(nonenr_capital = 0, nonenr_gain = 0)
  )
)

# ne rien faire
expect_equal(
  manage_nonenr(nonenr_capital = 1, nonenr_gain = 2, cotis = 0, sell = 0),
  list(
    capital_vendu = 0,
    gain_en_capital_vendu = 0,
    new_actifs = list(nonenr_capital = 1, nonenr_gain = 2)
  )
)

# cotiser
expect_equal(
  manage_nonenr(nonenr_capital = 1, nonenr_gain = 2, cotis = 5, sell = 0),
  list(
    capital_vendu = 0,
    gain_en_capital_vendu = 0,
    new_actifs = list(nonenr_capital = 6, nonenr_gain = 2)
  )
)

# tout vendre
expect_equal(
  manage_nonenr(nonenr_capital = 1, nonenr_gain = 2, cotis = 0, sell = 3),
  list(
    capital_vendu = 1,
    gain_en_capital_vendu = 2,
    new_actifs = list(nonenr_capital = 0, nonenr_gain = 0)
  )
)

# vente partielle
expect_equal(
  manage_nonenr(nonenr_capital = 1, nonenr_gain = 2, cotis = 0, sell = 1),
  list(
    capital_vendu = 1 / 3,
    gain_en_capital_vendu = 2 / 3,
    new_actifs = list(nonenr_capital = 2 / 3, nonenr_gain = 4 / 3)
  )
)

# achat et vente
expect_equal(
  manage_nonenr(nonenr_capital = 1, nonenr_gain = 3, cotis = 1, sell = 4),
  list(
    capital_vendu = 1.6,
    gain_en_capital_vendu = 2.4,
    new_actifs = list(nonenr_capital = 0.4, nonenr_gain = 0.6)
  )
)

# trop de vente impossible
expect_error(
  manage_nonenr(nonenr_capital = 1, nonenr_gain = 3, cotis = 2, sell = 6.01)
)

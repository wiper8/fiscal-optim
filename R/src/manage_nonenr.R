# gestion du capital et gain dans des comptes non enregistré selon des achats et ventes
manage_nonenr <- function(nonenr_capital, nonenr_gain, cotis, sell) {
  if (any(sell > (nonenr_capital + nonenr_gain + cotis))) stop("Fonds insuffisants de non enregistré")
  useless_share_price <- 100 # présent juste pour aider à interpréter les calculs

  nonenr_total <- nonenr_capital + nonenr_gain

  shares_31dec <- nonenr_total / useless_share_price
  avg_cost_basis <- nonenr_capital / shares_31dec

  # jan 1: buying
  shares_bought <- cotis / useless_share_price
  nonenr_capital <- nonenr_capital + cotis
  shares_1jan <- shares_bought + shares_31dec
  avg_cost_basis <- ifelse(shares_1jan == 0, 0, nonenr_capital / shares_1jan)

  # jan 2: selling
  shares_sold <- sell / useless_share_price
  realised_gain <- (useless_share_price - avg_cost_basis) * shares_sold
  nonenr_gain <- nonenr_gain - realised_gain
  capital_vendu <- avg_cost_basis * shares_sold
  nonenr_capital <- nonenr_capital - capital_vendu
  shares_2jan <- shares_31dec - shares_sold
  avg_cost_basis <- nonenr_capital / shares_2jan

  list(
    capital_vendu = capital_vendu,
    gain_en_capital_vendu = realised_gain,
    new_actifs = list(nonenr_capital = nonenr_capital, nonenr_gain = nonenr_gain)
  )
}

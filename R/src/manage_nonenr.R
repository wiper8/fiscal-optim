manage_nonenr <- function(nonenr_capital, nonenr_gain, strategy, share_price) {
  nonenr_total <- nonenr_capital + nonenr_gain
  
  nonenr_total / nonenr_capital
  shares_31dec <- nonenr_total / share_price
  avg_cost_basis <- nonenr_capital / shares_31dec
  
  # jan 1: buying
  shares_bought <- strategy["COTIS_NONENR"] / share_price
  nonenr_capital <- nonenr_capital + strategy["COTIS_NONENR"]
  shares_1jan <- shares_bought + shares_31dec
  avg_cost_basis <- nonenr_capital / shares_1jan
  
  # jan 2: selling
  shares_sold <- strategy["SELL_NONENR"] / share_price
  realised_gain <- (share_price - avg_cost_basis) * shares_sold
  nonenr_gain <- nonenr_gain - realised_gain
  nonenr_capital <- nonenr_capital - avg_cost_basis * shares_sold
  if (nonenr_capital < 0) message("Fonds insuffisants de capital de non enregistré")
  shares_2jan <- shares_31dec - shares_sold
  avg_cost_basis <- nonenr_capital / shares_2jan
  
  list(
    capital_vendu = avg_cost_basis * shares_sold,
    gain_en_capital_vendu = realised_gain,
    new_actifs = c(nonenr_capital = nonenr_capital, nonenr_gain = nonenr_gain)
  )
}

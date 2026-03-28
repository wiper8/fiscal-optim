source("R/src/try_strategy.R")

# according to a specific strategy of investments/withdrawal/work/retirement, how much can i spend each year
# (flat except for inflation) to fulfill my needs?
optim_flat_expenses <- function(data_filepath, inflation_over_ipc, eps = 0.01) {
  
  # in today's dollars
  # estimation of propabe yearly_expenses, very simplified
  source(data_filepath)
  yearly_expenses <- actifs$cash + actifs$nonenr_capital + actifs$nonenr_gain + actifs$celi$current_value
  yearly_expenses <- yearly_expenses * (rendement_brut / ipc - 1)
  
  # bounds on the yearly_expenses amount
  # upper will be set after first failure
  lower <- 0
  upper <- NA
  
  repeat {
    tryCatch({
      message(c("[", round(lower, 2), ", ", round(upper, 2), "]"))
      # reinitiate assets
      source(data_filepath)
      
      # set expenses level
      depenses <- data.frame(
        age = start_age:max_age,
        depenses = yearly_expenses * (inflation_over_ipc / ipc)^(0:(max_age - start_age))
      )
      
      # try to live while spending `depenses` schedule
      try_strategy(actifs, revenus, depenses, strategy)
      message("success")
      # if success, increment lower bound
      lower <- yearly_expenses
    },
    error = function(e) { # too high
      message("failed")
      if (is.na(upper)) upper <- yearly_expenses
      upper <- min(upper, yearly_expenses)
    }, finally = {
      message("finally")
      # next value to try
      old_yearly_expenses <- yearly_expenses
      if (is.na(upper)) {
        yearly_expenses <- (yearly_expenses + eps) * 2
      } else {
        yearly_expenses <- (lower + upper) / 2
      }
      if (abs(old_yearly_expenses - yearly_expenses) < eps) break 
    })
  }
  old_yearly_expenses
}

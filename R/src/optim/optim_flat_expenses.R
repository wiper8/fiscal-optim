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
  bounds <- c(0, NA)

  repeat {

    message(c("[", round(bounds[1], 2), ", ", round(bounds[2], 2), "]"))
    # reinitiate assets
    source(data_filepath)

    # set expenses level
    depenses <- data.frame(
      age = start_age:max_age,
      depenses = yearly_expenses * (inflation_over_ipc / ipc)^(0:(max_age - start_age))
    )

    # try to live while spending `depenses` schedule
    bounds <- tryCatch({
      try_strategy(actifs, revenus, depenses, strategy)
      # if success, increment lower bound
      c(yearly_expenses, bounds[2])
    },
    error = function(e) { # too high
      if (is.na(bounds[2])) return(c(bounds[1], yearly_expenses))
      c(bounds[1], min(bounds[2], yearly_expenses))
    })

    ## finally
    old_yearly_expenses <- yearly_expenses
    # next value to try
    yearly_expenses <- if (is.na(bounds[2])) {
      (yearly_expenses + eps) * 2
    } else {
      mean(bounds)
    }

    # stop condition
    if (abs(old_yearly_expenses - yearly_expenses) < eps) break
  }
  old_yearly_expenses
}

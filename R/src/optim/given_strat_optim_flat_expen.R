source("R/src/try_strategy.R")
source("R/src/get_flat_expenses_ipc.R")

# according to a specific strategy of investments/withdrawal/work/retirement, how much can i spend each year
# (flat except for inflation) to fulfill my needs?
given_strat_optim_flat_expen <- function(data_filepath, real_strategy, inflation_over_ipc, eps = 0.01, verbose = TRUE,
                                         previous_min_bound = NULL, ...) {

  # in today's dollars
  # estimation of propabe yearly_expenses, very simplified
  source(data_filepath)
  strategy <- real_strategy # override la stratégie dans data/
  yearly_expenses <- actifs$cash + actifs$nonenr_capital + actifs$nonenr_gain + actifs$celi$current_value
  yearly_expenses <- yearly_expenses * (rendement_brut / ipc - 1)

  ## warmup
  if (!is.null(previous_min_bound)) {
    previous <- if (is.null(previous_min_bound)) 0 else previous_min_bound * 0.95

    # set expenses level
    depenses <- get_flat_expenses_ipc(start_age, max_age, previous, inflation_over_ipc, ipc)
    res_strat <- try_strategy(actifs, revenus, depenses, strategy, passed_revenus)

    if (length(res_strat) == 1 && grepl("argent insuffisant", res_strat)) {
      minimum <- 0 # ignore warmup
    } else if (is.matrix(res_strat)) {
      minimum <- previous
      yearly_expenses <- pmax(yearly_expenses, minimum)
    } else {
      browser() # si ça déclanche, c'est un bogue probablement
    }
  } else {
    minimum <- 0
  }

  # bounds on the yearly_expenses amount
  # upper will be set after first failure
  bounds <- c(minimum, NA)

  repeat {

    if (verbose) message(c("[", round(bounds[1], 2), ", ", round(bounds[2], 2), "]"))
    # reinitiate assets
    source(data_filepath)
    strategy <- real_strategy # override la stratégie dans data/

    # set expenses level
    depenses <- get_flat_expenses_ipc(start_age, max_age, yearly_expenses, inflation_over_ipc, ipc)

    # try to live while spending `depenses` schedule
    res_strat <- try_strategy(actifs, revenus, depenses, strategy, passed_revenus)

    if (length(res_strat) == 1 && grepl("argent insuffisant", res_strat)) {
      if (is.na(bounds[2])) {
        bounds <- c(bounds[1], yearly_expenses)
      } else {
        bounds <- c(bounds[1], min(bounds[2], yearly_expenses))
      }
    } else if (is.matrix(res_strat)) {
      # if success, increment lower bound
      bounds <- c(yearly_expenses, bounds[2])
    } else {
      browser() # si ça déclanche, c'est un bogue probablement
    }

    ## finally
    # next value to try
    yearly_expenses <- if (is.na(bounds[2])) {
      (yearly_expenses + eps) * 1.05
    } else {
      mean(bounds)
    }

    # stop condition
    if (isTRUE(diff(bounds) < eps)) break
  }

  bounds[1]
}

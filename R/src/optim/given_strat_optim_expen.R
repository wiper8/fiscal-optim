source("R/src/try_strategy.R")
source("R/src/get_expenses_ipc.R")

# according to a specific strategy of investments/withdrawal/work/retirement, how much can i spend each year
# (flat except for inflation) to fulfill my needs?
given_strat_optim_expen <- function(data_filepath, real_strategy, eps = 0.01, verbose = 7,
                                    previous_min_bound = NULL, ..., real_revenus = NULL,
                                    subset = seq_len(nrow(real_strategy))) {
  # in today's dollars
  # estimation of probable base_yearly_expenses, very simplified
  source(data_filepath)
  strategy <- real_strategy # override la stratégie dans data/
  revenus <- real_revenus %||% revenus # override les revenus dans data/
  base_yearly_expenses <- actifs$cash + actifs$nonenr_capital + actifs$nonenr_gain + actifs$celi$current_value
  base_yearly_expenses <- base_yearly_expenses * (rendement_brut / ipc - 1)

  ## warmup
  warmup_success <- NA
  if (!is.null(previous_min_bound)) {
    previous <- previous_min_bound * 0.95

    # set expenses level
    depenses <- get_expenses_ipc(
      start_age, tail(subset, 1) - head(subset, 1) + start_age,
      previous + depenses_variables$depenses[subset], ...
    )
    res_strat <- try_strategy(
      actifs,
      revenus[subset, , drop = FALSE], depenses[subset, , drop = FALSE], strategy[subset, , drop = FALSE],
      passed_revenus, start_age, tail(subset, 1) - head(subset, 1) + start_age
    )

    if (length(res_strat) == 1 && grepl("argent insuffisant", res_strat)) { # TODO gérer $ si déficit
      minimum <- 0 # ignore warmup
      warmup_success <- FALSE
    } else if (is.matrix(res_strat)) {
      minimum <- previous
      base_yearly_expenses <- pmax(base_yearly_expenses, minimum)
      warmup_success <- TRUE
    } else {
      browser() # si ça déclanche, c'est un bogue probablement
    }
  } else {
    minimum <- 0
    warmup_success <- FALSE
  }

  # bounds on the base_yearly_expenses amount
  # upper will be set after first failure
  bounds <- c(minimum, NA)

  repeat {
    if (verbose >= 7) message(c("[", round(bounds[1], 2), ", ", round(bounds[2], 2), "]"))
    # reinitiate assets
    source(data_filepath)
    strategy <- real_strategy # override la stratégie dans data/
    revenus <- real_revenus %||% revenus # override les revenus dans data/

    # set expenses level
    depenses <- get_expenses_ipc(
      start_age, tail(subset, 1) - head(subset, 1) + start_age,
      base_yearly_expenses + depenses_variables$depenses[subset], ...
    )

    # try to live while spending `depenses` schedule
    res_strat <- try_strategy(
      actifs,
      revenus[subset, , drop = FALSE],
      depenses[subset, , drop = FALSE],
      strategy[subset, , drop = FALSE],
      passed_revenus, start_age,
      tail(subset, 1) - head(subset, 1) + start_age
    )

    if (length(res_strat) == 1 && grepl("argent insuffisant", res_strat)) { # TODO gérer $ si déficit
      if (is.na(bounds[2])) {
        bounds <- c(bounds[1], base_yearly_expenses)
      } else {
        bounds <- c(bounds[1], min(bounds[2], base_yearly_expenses))
      }
    } else if (is.matrix(res_strat)) {
      # if success, increment lower bound
      bounds <- c(base_yearly_expenses, bounds[2])
    } else {
      browser() # si ça déclanche, c'est un bogue probablement
    }

    ## finally
    # next value to try
    base_yearly_expenses <- if (is.na(bounds[2])) {
      (base_yearly_expenses + eps) * ifelse(is.null(previous_min_bound) || !isTRUE(warmup_success), 1.6, 1.05)
    } else {
      mean(bounds)
    }

    # stop condition
    if (isTRUE(diff(bounds) < eps)) break
  }

  bounds[1]
}

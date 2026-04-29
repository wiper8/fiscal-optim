source("R/src/optim/given_strat_optim_expen.R")
source("R/src/optim/initial_solution.R")
source("R/src/optim/particle_swarm.R")
source("R/src/optim/get_bounds.R")
source("R/src/optim/try_expense.R")
source("R/src/optim/maximise_utils.R")
source("R/src/try_strategy.R")

# maximiser une quantitée d'argent flat dans le temps en optimisant une stratégie de cotisations/retraits fiscaux
guided_maximise_expenses <- function(start_age, max_age, bloc_splits = NULL, previous_solution = NULL, ..., eps = 0.01,
                                     limit_time = 10, verbose = 3) {
  scale_factor <- 1.05
  max_scale_absolute <- 500
  timer_start <- Sys.time()

  # warmup
  args <- list(...)
  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))
  previous_solution <- previous_solution %||% initial_solution(ages, actifs)
  args$real_strategy <- get_strat(previous_solution, start_age, max_age, bloc_splits)
  args$eps <- 0.01
  args$verbose <- verbose
  args$previous_min_bound <- NULL # pour une optimisation complète from scratch
  starting_lower_bound <- do.call(given_strat_optim_expen, args)

  lower_bound <- starting_lower_bound # lower bound
  base_yearly_expenses <- min((lower_bound + eps) * scale_factor, lower_bound + max_scale_absolute)

  repeat {
    if (verbose >= 3) message(paste0("Lower bound : ", round(lower_bound, 2)))
    if (verbose >= 3) message(paste0("Trying : ", round(base_yearly_expenses, 2)))
    try_res <- try_expense(
      start_age, max_age, base_yearly_expenses,
      bloc_splits = bloc_splits,
      limit_time = limit_time,
      timer_start = timer_start,
      previous_solution = previous_solution,
      previous_min_bound = lower_bound,
      verbose = verbose,
      eps = eps,
      ...
    )
    previous_solution <- try_res$best_strat
    lower_bound <- try_res$bound
    # réussi à faire toute la retraite
    if (try_res$success) {
      # augmenter mes bounds, puis tenter selon le * scale_factor
      base_yearly_expenses <- min((lower_bound + eps) * scale_factor, lower_bound + max_scale_absolute)
    } else if (isTRUE(diff(c(lower_bound, base_yearly_expenses)) < eps)) {
      break
    } else {
      # sinon, retourner à ma bound min et esssayer la moyenne de mon essai raté et ma bound min.
      base_yearly_expenses <- (lower_bound + base_yearly_expenses) / 2
    }
  }

  # calculer avec précision les dépenses disponibles (objectif de l'optimisation)
  args <- list(...)
  args$real_strategy <- get_strat(previous_solution, start_age, max_age, bloc_splits)
  args$eps <- 0.01
  args$verbose <- verbose
  args$previous_min_bound <- NULL # pour une optimisation complète from scratch

  expenses <- do.call(given_strat_optim_expen, args)

  list(depenses = expenses, strategy = args$real_strategy, theta = previous_solution)
}

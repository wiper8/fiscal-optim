source("R/src/optim/given_strat_optim_expen.R")
source("R/src/optim/initial_solution.R")
source("R/src/optim/particle_swarm.R")
source("R/src/optim/get_bounds.R")
source("R/src/optim/maximise_utils.R")

# maximiser une quantitée d'argent flat dans le temps en optimisant une stratégie de cotisations/retraits fiscaux
maximise_expenses <- function(start_age, max_age, bloc_splits = NULL, previous_solution = NULL, ..., limit_time = 10,
                              verbose = 2, optimiser = c("swarm", "constrOptim")) {
  to_optim <- function(flat_strategy, timer_start, limit_time, verbose, ...) {
    stop_limit_time(timer_start, limit_time, verbose)
    if (verbose >= 6) print(to_k(flat_strategy))
    strategy <- get_strat(flat_strategy, start_age, max_age, bloc_splits)
    expenses <- given_strat_optim_expen(
      real_strategy = strategy, verbose = verbose, ...,
      previous_min_bound = previous_min_bound
    )
    if (is.null(previous_min_bound)) {
      previous_min_bound <<- expenses
      best_strat <<- flat_strategy
    } else {
      if (expenses > previous_min_bound) {
        previous_min_bound <<- expenses
        best_strat <<- flat_strategy
      }
    }
    if (verbose >= 5) message(paste0("objective : ", round(expenses, 2)))
    if (verbose >= 5) message(paste0("Best lower bound : ", round(previous_min_bound, 2)))

    -expenses
  }


  timer_start <- Sys.time()
  counter <- 1
  optimiser <- match.arg(optimiser)

  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))

  theta <- previous_solution %||% initial_solution(ages, actifs)
  previous_min_bound <- NULL
  previous_min_bound <- -to_optim(theta, limit_time = limit_time, timer_start = timer_start, verbose = verbose, ...)

  tryCatch(
    {
      if (optimiser == "swarm") {
        tmp_bounds <- get_bounds(ages = ages, ...)
        particle_swarm(
          theta = theta,
          f = to_optim,
          swarm_iter = 100000000, # car la limite de temps s'appliquera
          lower_bounds = tmp_bounds$lower,
          upper_bounds = tmp_bounds$upper,
          limit_time = limit_time,
          timer_start = timer_start,
          verbose = verbose,
          ...
        )
      } else if (optimiser == "constrOptim") {
        # nolint start: commented_code_linter
        base_ui <- matrix(
          c(
            0, 0, 0, 1 # DEDUCE_REER >= 0
          ),
          ncol = 4,
          byrow = TRUE
        )

        # ui %*% theta - ci > 0
        ui_constr_mat <- kronecker(diag(length(ages)), base_ui)

        # une cenne pour epsilon à cause du >= vs > dans ui %*% theta - ci > 0
        ci_constr <- rep(0, nrow(ui_constr_mat)) - 0.01
        # nolint end

        constrOptim(
          theta = theta,
          f = to_optim,
          grad = NULL,
          ui = ui_constr_mat,
          ci = ci_constr,
          control = list(
            reltol = 0.0001, # 10$ / ~50000$
            parscale = rep(10000, length(theta)),
            ndeps = 10 # eps pour estimation du gradient
          ),
          limit_time = limit_time,
          timer_start = timer_start,
          verbose = verbose,
          ...
        )
      }
    },
    error = function(e) {
      if (verbose >= 2) message("Stopped early: ", e$message)
    }
  )

  # calculer avec précision les dépenses disponibles (objectif de l'optimisation)
  args <- list(...)
  args$real_strategy <- get_strat(best_strat, start_age, max_age, bloc_splits)
  args$eps <- 0.01
  args$verbose <- verbose
  args$previous_min_bound <- NULL # pour une optimisation complète from scratch
  expenses <- do.call(given_strat_optim_expen, args)

  list(depenses = expenses, strategy = args$real_strategy, theta = best_strat)
}

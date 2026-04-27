source("R/src/optim/maximise_utils.R")

try_expense <- function(start_age, max_age, base_yearly_expenses, bloc_splits = NULL,
                        data_filepath, previous_solution = NULL, previous_min_bound = NULL, ...,
                        limit_time = 10, verbose = 4, optimiser = c("swarm", "constrOptim"),
                        eps = 0.01, timer_start, real_revenus = NULL) {
  res <- tryCatch(
    {
      stop_limit_time(timer_start, limit_time, verbose)
    },
    error = function(e) {
      "early_stop"
    }
  )
  if (isTRUE(all.equal(res, "early_stop"))) {
    return(list(success = FALSE, best_strat = previous_solution, bound = previous_min_bound))
  }

  to_optim <- function(flat_strategy, timer_start, limit_time, verbose, max_age, bloc_splits, ...) {
    stop_limit_time(timer_start, limit_time, verbose)
    if (verbose >= 6) print(to_k(flat_strategy))
    strategy <- get_strat(flat_strategy, start_age, max_age, bloc_splits)

    expenses <- given_strat_optim_expen(
      real_strategy = strategy, data_filepath = data_filepath, verbose = verbose, ...,
      previous_min_bound = base_yearly_expenses
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
    if (verbose >= 5) print(paste0("objective : ", round(expenses, 2)))
    if (verbose >= 5) print(paste0("Best lower bound : ", round(previous_min_bound, 2)))
    if (expenses >= min_expenses) stop(paste0("Réussi à dépenser ", round(expenses, 2)))

    -expenses
  }

  optimiser <- match.arg(optimiser)
  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))
  best_strat_orig <- previous_solution %||% initial_solution(ages, actifs)
  best_strat <- best_strat_orig
  previous_min_bound_orig <- previous_min_bound

  i <- 1
  while (i <= (max_age - start_age + 1)) {
    source(data_filepath)
    # append best_strat untried flat strategy parameters
    best_strat <- c(best_strat, tail(best_strat_orig, length(best_strat_orig) - length(best_strat)))
    real_strategy <- get_strat(best_strat, start_age, max_age, bloc_splits)
    strategy <- real_strategy # override la stratégie dans data/
    revenus <- real_revenus %||% revenus # override les revenus dans data/

    # try strat pour 1:i
    subset <- 1:i
    tmp_max_age <- start_age + i - 1
    depenses <- get_expenses_ipc(
      start_age, tmp_max_age,
      base_yearly_expenses + depenses_variables$depenses[subset],
      ...
    )
    res_strat <- try_strategy(
      actifs, revenus[subset, , drop = FALSE], depenses[subset, , drop = FALSE], strategy[subset, , drop = FALSE],
      passed_revenus,
      start_age, tmp_max_age
    )
    # si fail
    if (length(res_strat) == 1 && grepl("argent insuffisant", res_strat)) {
      if (verbose >= 4) message(paste0(" Optimisation dès i : ", i))

      # optimiser swarm ou constrOptim seulement 1:i avec des critères limites de recherche.
      min_expenses <- base_yearly_expenses

      tryCatch(
        {
          if (optimiser == "swarm") {
            tmp_bounds <- get_bounds(data_filepath = data_filepath, ages = ages, ...)
            particle_swarm(
              theta = subset_strat(best_strat, subset, ages),
              f = to_optim,
              swarm_iter = 100000000, # car la limite de temps s'appliquera
              lower_bounds = subset_strat(tmp_bounds$lower, subset, ages),
              upper_bounds = subset_strat(tmp_bounds$upper, subset, ages),
              limit_time = limit_time,
              timer_start = timer_start,
              verbose = verbose,
              max_age = tmp_max_age,
              subset = subset,
              bloc_splits = pmin(bloc_splits, tmp_max_age),
              real_revenus = revenus,
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

            subsetted_theta <- subset_strat(best_strat, subset, ages)
            constrOptim(
              theta = subsetted_theta,
              f = to_optim,
              grad = NULL,
              ui = ui_constr_mat[, subset_strat(seq_along(best_strat), subset, ages), drop = FALSE],
              ci = ci_constr,
              control = list(
                reltol = 0.0001, # 10$ / ~50000$
                parscale = rep(10000, length(subsetted_theta)),
                ndeps = 10 # eps pour estimation du gradient
              ),
              limit_time = limit_time,
              timer_start = timer_start,
              verbose = verbose,
              max_age = tmp_max_age,
              subset = subset,
              bloc_splits = pmin(bloc_splits, tmp_max_age),
              real_revenus = revenus,
              ...
            )
          }
        },
        error = function(e) {
          if (verbose >= 4) message("Stopped early: ", e$message)
        }
      )
      # après la recherche, si ça n'a pas passé, retourner faux
      if (is.null(previous_min_bound) || previous_min_bound < base_yearly_expenses) {
        return(list(success = FALSE, best_strat = best_strat_orig, bound = previous_min_bound_orig))
      }
      # après recherche, si ça passe, continuer à la ligne 3
      if (previous_min_bound >= base_yearly_expenses) {
        i <- i + 1
        # écraser car je n'ai pas la garantie que previous_min_bound fonctionnera pour les prochains i
        if (i <= (max_age - start_age + 1)) previous_min_bound <- base_yearly_expenses
        next
      } else {
        browser() # Erreur si ça déclanche
      }
    } else {
      i <- i + 1
      next
    }
  }
  success <- i > (max_age - start_age + 1)
  list(
    success = success, best_strat = if (success) best_strat else best_strat_orig,
    bound = if (success) max(base_yearly_expenses, previous_min_bound) else previous_min_bound
  )
}

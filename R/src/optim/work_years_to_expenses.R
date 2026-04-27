source("R/src/optim/maximise_expenses.R")
source("R/src/optim/guided_maximise_expenses.R")

# data.frame de relation entre le nombre d'années de travail restantes et les dépenses annuelles permises
work_years_to_expenses <- function(data_filepath, yearly_income, bloc_splits, work_years = NULL,
                                   method = c("guided_maximise", "maximise"), limit_time, verbose = 1, ...) {
  method <- match.arg(method)
  max_fun <- if (method == "guided_maximise") {
    guided_maximise_expenses
  } else {
    maximise_expenses
  }
  previous_solution <- NULL
  age_65 <- 65
  age_71 <- 71
  source(data_filepath)
  stopifnot(start_age < age_65)
  if (is.null(work_years)) work_years <- 0:(age_65 - start_age)

  # car on répète `length(work_years)` fois le timer.
  limit_time <- limit_time / length(work_years)

  work_years_expenses <- data.frame(work_years = work_years, expenses = NA)

  for (i in seq_len(nrow(work_years_expenses))) {
    if (verbose >= 1) message(paste0("work_years : ", work_years_expenses$work_years[i]))
    # écraser les revenus provenant de data/
    revenus <- data.frame(
      age = start_age:max_age,
      revenu_emploi = c(
        rep(yearly_income, work_years_expenses$work_years[i]),
        rep(0, max_age - start_age + 1 - work_years_expenses$work_years[i])
      )
    )
    # potential override bloc_splits
    if (missing(bloc_splits)) {
      bloc_splits <- c(work_years_expenses$work_years[i] + start_age, age_65, age_71)
    }
    tmp <- max_fun(start_age, max_age,
      bloc_splits = bloc_splits, previous_solution = previous_solution,
      data_filepath = data_filepath, inflation = inflation, ipc = ipc, limit_time = limit_time,
      eps = 100, verbose = verbose, real_revenus = revenus, ...
    )
    work_years_expenses$expenses[i] <- tmp$depenses
    previous_solution <- tmp$theta
    if (verbose >= 1) message(paste0("Dépenses flat : ", round(tmp$depenses, 2)))
  }
  work_years_expenses
}

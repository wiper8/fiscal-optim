source("R/src/optim/maximise_expenses.R")

# data.frame de relation entre le nombre d'années de travail restantes et les dépenses annuelles permises
work_years_to_expenses <- function(data_filepath, yearly_income, bloc_splits, work_years = NULL, ...) {
  previous_solution <- NULL
  age_65 <- 65
  age_71 <- 71
  stopifnot(start_age < age_65)

  source(data_filepath)
  if (is.null(work_years)) work_years <- 0:(age_65 - start_age)
  work_years_expenses <- data.frame(work_years = work_years, expenses = NA)

  for (i in seq_len(nrow(work_years_expenses))) {
    message(paste0("work_years : ", work_years_expenses$work_years[i]))
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
    tmp <- maximise_expenses(start_age, max_age,
                             bloc_splits = bloc_splits,
                             previous_solution = previous_solution, data_filepath = data_filepath,
                             eps = 100, inflation = inflation, ipc = ipc, verbose = FALSE, verbose_max = FALSE,
                             real_revenus = revenus, ...)
    work_years_expenses$expenses[i] <- tmp$depenses
    previous_solution <- tmp$theta
  }
  work_years_expenses
}

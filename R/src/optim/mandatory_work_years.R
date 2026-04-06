# nombre d'année obligé de travailler selon des dépenses annuelles
mandatory_work_years <- function(df, total_expenses = NULL, additional_expenses = NULL, current_expenses = NULL) {
  if (is.null(total_expenses) && is.null(additional_expenses)) stop("both arguments are NULL")
  interp <- splinefun(df$expenses, df$work_years, method = "monoH.FC")

  if (!is.null(total_expenses)) {
    return(years_to_months(interp(total_expenses)))
  }
  years_to_months(interp(current_expenses + additional_expenses) - interp(current_expenses))
}

years_to_months <- function(x) {
  years <- floor(x)
  x <- 12 * (x - years)
  months <- floor(x)
  work_days <- ceiling(260 * (x - months))
  paste0(years, " ans ", months,  " mois ", work_days, " jours")
}

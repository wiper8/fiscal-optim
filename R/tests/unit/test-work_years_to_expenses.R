source("R/src/optim/work_years_to_expenses.R")

fake_expenses <- lapply(c(seq(30000, 40000, 1000), seq(40500, 42000, 500), 50000), function(x) list(depenses = x))
fake_maximise_expenses <- do.call(mock, fake_expenses)
stub(work_years_to_expenses, "maximise_expenses", fake_maximise_expenses)

expect_equal(
  work_years_to_expenses(
    "R/data/fiscal_template.R",
    yearly_income = 80000
  ),
  data.frame(
    work_years = 0:(length(fake_expenses) - 1),
    expenses = unlist(fake_expenses)
  )
)

TRUE

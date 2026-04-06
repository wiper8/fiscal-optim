get_flat_expenses_ipc <- function(start_age, max_age, expenses, inflation, ipc) {
  data.frame(
    age = start_age:max_age,
    depenses = expenses * (inflation / ipc)^(0:(max_age - start_age))
  )
}

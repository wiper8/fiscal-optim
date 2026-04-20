library(ggplot2)

plot_work_years_expenses <- function(df) {
  ggplot(df) +
    geom_line(aes(x = work_years, y = expenses))
}

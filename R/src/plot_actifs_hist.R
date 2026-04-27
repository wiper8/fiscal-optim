library(ggplot2)
library(scales)

plot_actifs_hist <- function(actifs_hist, key_moments = NULL) {
  p <- ggplot() +
    theme_bw() +
    scale_y_continuous(labels = label_dollar()) +
    geom_hline(aes(yintercept = 0)) +
    geom_line(aes(x = start_age:(max_age + 1), y = apply(actifs_hist, 1, sum), color = "Total"), linewidth = 1) +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "cash"], color = "Cash")) +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "nonenr_capital"], color = "Non-enr capital")) +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "nonenr_gain"], color = "Non-enr gain")) +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "celi"], color = "CELI")) +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "reer"], color = "REER")) +
    xlab("Âge") +
    ylab("Actifs") +
    scale_color_manual(
      values = c(
        "Total" = "black",
        "Cash" = "#00DD00",
        "Non-enr capital" = "#0000bb",
        "Non-enr gain" = "#bb0000",
        "CELI" = "#bbbb00",
        "REER" = "#00bbbb"
      )
    )
  if (is.null(key_moments)) {
    return(p)
  }
  p +
    geom_segment(aes(
      x = key_moments, xend = key_moments,
      y = 0, yend = max(actifs_hist)
    ), linetype = "dashed", alpha = 0.4)
}

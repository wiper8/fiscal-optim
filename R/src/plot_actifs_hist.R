plot_actifs_hist <- function(actifs_hist, key_moments) {
  ggplot() +
    theme_bw() +
    scale_y_continuous(labels = label_dollar()) +
    geom_hline(aes(yintercept = 0)) +
    geom_line(aes(x = start_age:(max_age + 1), y = apply(actifs_hist, 1, sum)), color = "black", linewidth = 1) +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "cash"]), color = "#00DD00") +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "nonenr_capital"]), color = "#0000bb") +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "nonenr_gain"]), color = "#bb0000") +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "celi"]), color = "#bbbb00") +
    geom_line(aes(x = start_age:(max_age + 1), y = actifs_hist[, "reer"]), color = "#00bbbb") +
    geom_segment(aes(x = key_moments, xend = key_moments,
                     y = 0, yend = max(actifs_hist)), linetype = "dashed", alpha = 0.4) +
    xlab("Âge") + ylab("Actifs")
}

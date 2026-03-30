# rente RRQ
get_prest_rrq <- function(revenus_travail, jan_1_age, ipc) {
  mga <- 71300
  msga <- 81200
  pct_retranch <- 0.15
  mgam5 <- mga * mean(ipc^-(0:4))

  # régime de base
  revenus_travail_admiss <- pmin(revenus_travail, mga)
  max_rev_travail_admiss <- mga
  rev_travail_reajus <- revenus_travail_admiss * mgam5 / mga
  years_flushed <- floor(pct_retranch * (65 - 18))
  income_flushed <- head(sort(rev_travail_reajus), years_flushed)
  after_flush <- sum(rev_travail_reajus) - sum(income_flushed)
  base <- 0.25 * after_flush / (65 - 18 - years_flushed)

  # régime supp - volet 1
  fact_ajust_cotis_reduit <- c(
    rep(0, max(0, jan_1_age - (as.numeric(format(Sys.Date(), "%Y")) - 2002))),
    0.15, 0.3, 0.5, 0.75,
    rep(1, max(0, as.numeric(format(Sys.Date(), "%Y")) - 1958 - jan_1_age))
  )

  # divisé par 480 normalement, mais à long terme : flusher des mois comme le régime de base pour conserver le meilleur
  # 40 ans
  if (length(rev_travail_reajus) != length(fact_ajust_cotis_reduit)) stop("not equal lengths")
  supp_rev_travail_reajus <- rev_travail_reajus * fact_ajust_cotis_reduit
  supp_income_flushed <- head(sort(supp_rev_travail_reajus), 65 - 40)
  supp_after_flush <- sum(supp_rev_travail_reajus) - sum(supp_income_flushed)
  supp_1 <- 0.0833 * supp_after_flush / 40

  # régime supp - volet 2
  
  # a commencé en 2024
  fact_ajust_cotis_reduit <- c(
    rep(0, max(0, jan_1_age - (as.numeric(format(Sys.Date(), "%Y")) - 2007))),
    rep(1, max(0, as.numeric(format(Sys.Date(), "%Y")) - 1959 - jan_1_age))
  )
  supp_rev_travail_reajus <- pmax(0, pmin(msga, revenus_travail) - max_rev_travail_admiss) * mgam5 / mga
  if (length(supp_rev_travail_reajus) != length(fact_ajust_cotis_reduit)) stop("not equal lengths")
  supp_rev_travail_reajus <- supp_rev_travail_reajus * fact_ajust_cotis_reduit
  supp_income_flushed <- head(sort(supp_rev_travail_reajus), 65 - 40)
  supp_after_flush <- sum(supp_rev_travail_reajus) - sum(supp_income_flushed)
  supp_2 <- 0.3333 * supp_after_flush / 40

  base + supp_1 + supp_2
}

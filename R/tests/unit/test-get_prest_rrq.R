source("R/src/get_prest_rrq.R")

expect_equal(
  get_prest_rrq(
    c(rep(0, 47), 85000),
    65,
    1.02
  ),
  416.99 + 138.65 + 70.62,
  # TODO améliorer la précision
  tolerance = 0.04 * 625.39, # marge de 4%
  scale = 1
)

expect_equal(
  get_prest_rrq(
    c(
      rep(0, 40), 55900, 57400, 58700, 61600, 64900, 66600, 75000, 85000
    ) * 1.02^(47:0),
    65,
    1.02
  ),
  3335.95 + 630.87 + 108.72,
  # TODO améliorer la précision
  tolerance = 0.02 * 4075.54, # marge de 2%
  scale = 1
)

# nolint exemple à https://www.retraitequebec.gouv.qc.ca/SiteCollectionDocuments/RetraiteQuebec/fr/publications/nos-programmes/regime-de-rentes/retraite/1036-1f-Methode-calcul-rente-2025.pdf
expect_equal(
  get_prest_rrq(
    c(
      1100, 6705, 13110, 14700, 16500, 18500, 20800, 23400, 23466, 24113, 25232, 26101, 27332, 29954, 31250, 31782,
      32751, 34900, 33333, 35800, 33825, 34283, 37600, 38300, 35000, 36000, 37000, 37675, 40000, 43700, 44900, 46300,
      47200, 48300, 50100, 51100, 52500, 53600, 54900, 55300, 55900, 57400, 58700, 61600, 64900, 66600, 75000, 85000
    ) * 1.02^(47:0),
    65,
    1.02
  ),
  1430.12 * 12,
  # TODO améliorer la précision
  tolerance = 0.1 * 1430.12 * 12, # marge de 10%
  scale = 1
)

# TODO exemple pour un plus vieux qui ne touche qu'au régime de base

# TODO exemple pour un plus jeune

FALSE

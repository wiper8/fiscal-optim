source("R/src/get_prest_rrq.R")

fake_date <- mock(as.Date("2026-03-30"), as.Date("2026-03-30"), as.Date("2028-03-30"), as.Date("2026-03-30"),
                  as.Date("2026-03-30"), as.Date("2072-03-30"))

# remplacer les fonctions internes dans get_revenu_disponible()
stub(get_prest_rrq, "Sys.Date", fake_date)

# les cibles sont approximatives (des tests de gros bon sens)
cible <- (0.3333 * 71300 + 0.3333 * 9900) / 40
expect_equal(
  get_prest_rrq(
    c(rep(0, 46), 85000),
    65,
    1.02
  ),
  cible,
  tolerance = 0.05 * cible,
  scale = 1
)

cible <- (0.25 * 541105 + 0.0833 * 326023 + 0.0833 * 15100) / 40
expect_equal(
  get_prest_rrq(
    c(
      rep(0, 39), 55900, 57400, 58700, 61600, 64900, 66600, 75000, 85000
    ) * 1.02^(46:0),
    65,
    1.02
  ),
  cible,
  tolerance = 0.03 * cible,
  scale = 1
)

# test avec mocking dans 2 ans (2028)
cible <- (0.25 * 541105 + 0.0833 * 326023 + 0.0833 * 15100) / 40
expect_equal(
  get_prest_rrq(
    c(
      rep(0, 39), 55900, 57400, 58700, 61600, 64900, 66600, 75000, 85000
    ) * 1.02^(46:0),
    67,
    1.02
  ),
  cible,
  # TODO améliorer la précision
  tolerance = 0.02 * cible,
  scale = 1
)

# nolint exemple à https://www.retraitequebec.gouv.qc.ca/SiteCollectionDocuments/RetraiteQuebec/fr/publications/nos-programmes/regime-de-rentes/retraite/1036-1f-Methode-calcul-rente-2025.pdf
# changements : l'inflation est de 2% au lieu de la vraie augmentation du MGA
#   l'âge de début, au lieu d'être 1 décembre, est le 1er janvier suivant, donc la première ligne disparait et la
#   derniere compte pour 12 mois complets
cible <- (0.25 * 2454608 + 0.0833 * 347441 + 0.0833 * 15100) / 40
expect_equal(
  get_prest_rrq(
    c(
      6705, 13110, 14700, 16500, 18500, 20800, 23400, 23466, 24113, 25232, 26101, 27332, 29954, 31250, 31782,
      32751, 34900, 33333, 35800, 33825, 34283, 37600, 38300, 35000, 36000, 37000, 37675, 40000, 43700, 44900, 46300,
      47200, 48300, 50100, 51100, 52500, 53600, 54900, 55300, 55900, 57400, 58700, 61600, 64900, 66600, 75000, 85000
    ) * 1.02^(46:0),
    65,
    1.02
  ),
  cible,
  tolerance = 0.05 * cible,
  scale = 1
)

# exemple pour un plus vieux qui ne touche qu'au régime de base
cible <- 0.25 * 2454608 / 40
expect_equal(
  get_prest_rrq(
    c(
      6705, 13110, 14700, 16500, 18500, 20800, 23400, 23466, 24113, 25232, 26101, 27332, 29954, 31250, 31782,
      32751, 34900, 33333, 35800, 33825, 34283, 37600, 38300, 35000, 36000, 37000, 37675, 40000, 43700, 44900, 46300,
      47200, 48300, 50100, 51100, 52500, 53600, 54900, 55300, 55900, 57400, 58700, 61600, 64900, 66600, 75000, 85000
    ) * 1.02^(46:0),
    72,
    1.02
  ),
  cible,
  tolerance = 0.05 * cible,
  scale = 1
)

# exemple pour un plus jeune
rev <- c(
  6705, 13110, 14700, 16500, 18500, 20800, 23400, 23466, 24113, 25232, 26101, 27332, 29954, 31250, 31782,
  32751, 34900, 33333, 35800, 33825, 34283, 37600, 38300, 35000, 36000, 37000, 37675, 40000, 43700, 44900, 46300,
  47200, 48300, 50100, 51100, 52500, 53600, 75000, 75000, 75000, 75000, 75000, 75000, 75000, 75000, 75000, 85000
) * c(rep(1.02, 37), rep(1, 10))^(46:0)

cible <- (0.3333 * sum(tail(sort(rev), -7))) / 40

expect_equal(
  get_prest_rrq(
    rev,
    19,
    1.02
  ),
  0
)
# un jeune de 19 ans aujourd'hui, mais dans le futur
expect_equal(
  get_prest_rrq(
    rev,
    65,
    1.02
  ),
  cible,
  tolerance = 0.05 * cible,
  scale = 1
)

TRUE

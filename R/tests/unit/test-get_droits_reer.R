source("R/src/get_droits_reer.R")

expect_equal(
  get_droits_reer(
    c(5000, 30000, 60000, 70000, 80000, 100000, 150000, 180500, 200000, 220000, 250000, 1000000),
    age = 40,
    ipc = 1.02
  ),
  c(825, 1950, 3300, 3750, 3808.5, 3808.5, 3808.5, 3808.5, 298.5, 0, 0, 0)
)


fake_get_rente <- mock(6000) # rente trop généreuse
# remplacer les fonctions internes dans get_revenu_disponible()
stub(get_droits_reer, "get_rente", fake_get_rente)
# n'est jamais négatif
expect_equal(
  get_droits_reer(150000, age = 40, ipc = 1.02),
  0
)

TRUE

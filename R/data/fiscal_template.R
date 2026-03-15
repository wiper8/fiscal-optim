MAX_AGE <- 100 # en date du 1er janvier
inflation <- 1.0275
ipc <- 1.02
rendement_brut <- 1.07
RENDEMENT <- rendement_brut / inflation
START_AGE <- 20 # en date du 1er janvier

# en date du 1er janvier
actifs <- list(
  cash = 400000
)

# en date du 1er janvier
revenus <- data.frame(
  age = START_AGE:MAX_AGE,
  revenu_emploi = 0
)

# en date du 1er janvier
depenses <- data.frame(
  age = START_AGE:MAX_AGE,
  depenses = 40000
)

# strategy of withdrawals
strategy <- matrix()


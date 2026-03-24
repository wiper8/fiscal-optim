# prestation Pension de la Sécurité de la vieillesse
get_prest_psv <- function(age) {
  (age < 65) * 0 +
    (65 <= age & age < 75) * (742.31 * 12) +
    (75 <= age) * (816.54 * 12)
}

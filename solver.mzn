include "data_public.dzn";
include "data_private.dzn";

%%% Constantes
% LA PREMIÈRE ANNÉE n=1 EST CELLE EN COURS AVANT JANVIER
int: N;
float: MOIS;
int: N_PALIERS;
float: BIG;
float: PENNY;
float: SHARE_PRICE_THEORICAL;
float: PLAFOND_CELI_NOW;
float: PLAFOND_REER_NOW;
float: PLAFOND_RAP_NOW;
float: PLAFOND_SALAIRE_RQAP_NOW;
float: PLAFOND_SALAIRE_AE_NOW;
float: PLAFOND_SALAIRE_RRQ_NOW;
float: PLAFOND_SALAIRE_RRQ_SUPP_NOW;
float: RATE_RQAP_NOW;
float: RATE_AE_NOW;
float: RATE_RRQ_LOW_NOW;
float: RATE_RRQ_HIGH_NOW;
float: PLAFOND_SALAIRE_FOND_RETRAITE_NOW;
float: RATE_FOND_RETRAITE_LOW_NOW;
float: RATE_FOND_RETRAITE_HIGH_NOW;
float: INFLATION;
float: RENDEMENT;
float: INFLATION_IMPOT;
float: INFLATION_CELI;
float: LIQUIDE_NOW;
float: NONENR_NOW;
float: NONENR_GAIN_NOW;
float: CELI_NOW;
float: CELIAPP_NOW;
float: REER_NOW;
float: DROITS_CELIAPP_RESTANTS;
float: DROITS_CELI_RESTANTS;
float: DROITS_REER_RESTANTS;
int: ANNEES_CELIAPP_ACCUMULEES;
float: RETOUR_IMPOT_1_ESTIM;
array[1..N] of float: SALAIRES_BRUT;
array[1..N] of float: DEPENSES;
array[1..N_PALIERS] of float: PALIERS_IMPOTS;
array[1..N_PALIERS] of float: PALIERS_IMPOTS_RATES;

%%% functions

%%% Variables

% variables fixées par data et contraintes
array[1..(N+1)] of var 0..BIG: LIQUIDE;
var 0..BIG: CASHDOWN;
array[1..N] of var 0..BIG: SHARE_PRICE :: is_defined_var;
array[1..N] of var 0..BIG: ECONOMIES :: is_defined_var;
array[1..N] of var -BIG..BIG: RETOUR_IMPOT :: is_defined_var;
array[1..N] of var 0..BIG: SALAIRE_IMPOSABLE :: is_defined_var;
array[1..N] of var 0..BIG: IMPOT_DU :: is_defined_var;
array[1..N] of var 0..BIG: IMPOT_PAYE :: is_defined_var;
array[1..N] of var 0..(PLAFOND_SALAIRE_RQAP_NOW * (1 + INFLATION)^N * RATE_RQAP_NOW): RQAP :: is_defined_var;
array[1..N] of var 0..((PLAFOND_SALAIRE_AE_NOW * (1 + INFLATION)^N) * RATE_AE_NOW): AE :: is_defined_var;
array[1..N] of var 0..(PLAFOND_SALAIRE_RRQ_NOW * (1 + INFLATION)^N * RATE_RRQ_LOW_NOW + max(0, (PLAFOND_SALAIRE_RRQ_SUPP_NOW - PLAFOND_SALAIRE_RRQ_NOW) * (1 + INFLATION)^N) * RATE_RRQ_HIGH_NOW): RRQ :: is_defined_var;
array[1..N] of var 0..BIG: FOND_RETRAITE :: is_defined_var;
array[1..N] of var 0..BIG: CUMUL_CELIAPP :: is_defined_var;
array[1..N] of var 0..BIG: DROITS_CELIAPP :: is_defined_var;
array[1..N] of var 0..BIG: CUMUL_CELI :: is_defined_var;
array[1..N] of var 0..BIG: DROITS_CELI :: is_defined_var;
array[1..N] of var 0..BIG: DROITS_REER :: is_defined_var;
array[1..N] of var 0..BIG: CUMUL_VALUE_REER :: is_defined_var;
array[1..N] of var 0..BIG: FACTEUR_EQUIVALENCE :: is_defined_var;
array[1..N] of var 0..BIG: SHARES_BOUGHT_NONENR :: is_defined_var;
array[1..N] of var 0..BIG: SHARES_SOLD_NONENR :: is_defined_var;
array[1..N] of var 0..BIG: CUMUL_SHARES_NONENR_START :: is_defined_var;
array[1..N] of var 0..BIG: CUMUL_SHARES_NONENR_END :: is_defined_var;
array[1..N] of var 0..BIG: CUMUL_VALUE_NONENR :: is_defined_var;
array[1..N] of var 0..BIG: AVG_BOUGHT_SHAREPRICE_NONENR :: is_defined_var;
array[1..N] of var -BIG..BIG: GAIN_REALISED_NONENR :: is_defined_var;
array[1..N, 1..N_PALIERS] of var 0..BIG: PALIERS_IMPOTS_TO_PAY_PAYE :: is_defined_var;
array[1..N, 1..N_PALIERS] of var 0..BIG: PALIERS_IMPOTS_TO_PAY_DU :: is_defined_var;

array[1..N] of var 0..BIG: COTIS_CELIAPP;
array[1..N] of var 0..BIG: COTIS_CELI;
array[1..N] of var 0..BIG: COTIS_NONENR;
array[1..N] of var 0..BIG: SELL_NONENR;
array[1..N] of var 0..BIG: COTIS_REER;
array[1..N] of var 0..BIG: SELL_REER;
var 1..N: YEAR_START_SELLING_REER;
var 1..N: YEAR_START_SELLING_NONENR;
var 0..BIG: RAP;

%%% Contraintes


%% contraintes pour fixer les variables déterministes
constraint LIQUIDE[1] = LIQUIDE_NOW;
constraint LIQUIDE[2] = LIQUIDE[1] + ECONOMIES[1] - COTIS_CELIAPP[1] - COTIS_CELI[1] - COTIS_REER[1] - COTIS_NONENR[1] + SELL_REER[1] + SELL_NONENR[1] + if MOIS < 6 then RETOUR_IMPOT[1] else 0 endif;
constraint forall(k in 2..N) (
    LIQUIDE[k + 1] = LIQUIDE[k] + ECONOMIES[k] - COTIS_CELIAPP[k] - COTIS_CELI[k] - COTIS_REER[k] - COTIS_NONENR[k] + SELL_REER[k] + SELL_NONENR[k] + RETOUR_IMPOT[k]
);
constraint forall(k in 1..N) (
  LIQUIDE[k] + ECONOMIES[k] - COTIS_CELIAPP[k] - COTIS_CELI[k] - COTIS_REER[k] - COTIS_NONENR[k] >= 0
);



constraint RETOUR_IMPOT[1] = RETOUR_IMPOT_1_ESTIM;
constraint forall(k in 2..N)(RETOUR_IMPOT[k] = IMPOT_PAYE[k-1] - IMPOT_DU[k-1]);

constraint ECONOMIES[1] = (SALAIRES_BRUT[1] - IMPOT_PAYE[1] - RQAP[1] - AE[1] - RRQ[1] - FOND_RETRAITE[1] - DEPENSES[1]) / (12 - (MOIS-1));
constraint forall(k in 2..N)(
  ECONOMIES[k] = SALAIRES_BRUT[k] - IMPOT_PAYE[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k] - DEPENSES[k]
);

constraint forall(k in 1..N) (
  SALAIRE_IMPOSABLE[k] = SALAIRES_BRUT[k] - COTIS_CELIAPP[k] - COTIS_REER[k] + SELL_REER[k] + GAIN_REALISED_NONENR[k] / 2
);
constraint forall(k in 1..N) (
    forall(j in 1..(N_PALIERS-1))(
      PALIERS_IMPOTS_TO_PAY_DU[k, j] = max(min(PALIERS_IMPOTS[j+1] * (1 + INFLATION_IMPOT)^(k-1), SALAIRE_IMPOSABLE[k]) - PALIERS_IMPOTS[j] * (1 + INFLATION_IMPOT)^(k-1), 0) * PALIERS_IMPOTS_RATES[j]
));
constraint forall(k in 1..N) (
    forall(j in 1..(N_PALIERS-1))(
      PALIERS_IMPOTS_TO_PAY_PAYE[k, j] = max(min(PALIERS_IMPOTS[j+1] * (1 + INFLATION_IMPOT)^(k-1), SALAIRES_BRUT[k]) - PALIERS_IMPOTS[j] * (1 + INFLATION_IMPOT)^(k-1), 0) * PALIERS_IMPOTS_RATES[j]
));

constraint forall(k in 1..N) (
    PALIERS_IMPOTS_TO_PAY_DU[k, N_PALIERS] = max(SALAIRE_IMPOSABLE[k] - PALIERS_IMPOTS[N_PALIERS] * (1 + INFLATION_IMPOT)^(k-1), 0) * PALIERS_IMPOTS_RATES[N_PALIERS]
);
constraint forall(k in 1..N) (
    PALIERS_IMPOTS_TO_PAY_PAYE[k, N_PALIERS] = max(SALAIRES_BRUT[k] - PALIERS_IMPOTS[N_PALIERS] * (1 + INFLATION_IMPOT)^(k-1), 0) * PALIERS_IMPOTS_RATES[N_PALIERS]
);

constraint forall(k in 1..N) (
    IMPOT_PAYE[k] = sum(j in 1..N_PALIERS)(PALIERS_IMPOTS_TO_PAY_PAYE[k, j])
);
constraint forall(k in 1..N) (
    IMPOT_DU[k] = sum(j in 1..N_PALIERS)(PALIERS_IMPOTS_TO_PAY_DU[k, j])
);
constraint forall(k in 1..N) (
    RQAP[k] = min(SALAIRES_BRUT[k], PLAFOND_SALAIRE_RQAP_NOW * (1 + INFLATION)^(k-1)) * RATE_RQAP_NOW
);
constraint forall(k in 1..N) (
    AE[k] = min(SALAIRES_BRUT[k], PLAFOND_SALAIRE_AE_NOW * (1 + INFLATION)^(k-1)) * RATE_AE_NOW
);
constraint forall(k in 1..N) (
    RRQ[k] = (min(SALAIRES_BRUT[k], PLAFOND_SALAIRE_RRQ_NOW * (1 + INFLATION)^(k-1)) * RATE_RRQ_LOW_NOW + max(0, min(SALAIRES_BRUT[k], PLAFOND_SALAIRE_RRQ_SUPP_NOW * (1 + INFLATION)^(k-1)) - PLAFOND_SALAIRE_RRQ_NOW * (1 + INFLATION)^(k-1)) * RATE_RRQ_HIGH_NOW)
);

constraint forall(k in 1..N) (
    FOND_RETRAITE[k] = (min(SALAIRES_BRUT[k], PLAFOND_SALAIRE_FOND_RETRAITE_NOW * (1 + INFLATION)^(k-1)) * RATE_FOND_RETRAITE_LOW_NOW + max(0, SALAIRES_BRUT[k] - PLAFOND_SALAIRE_FOND_RETRAITE_NOW * (1 + INFLATION)^(k-1)) * RATE_FOND_RETRAITE_HIGH_NOW)
);

%% vraies contraintes libres
constraint DROITS_CELIAPP[1] = DROITS_CELIAPP_RESTANTS;
constraint forall(k in 2..N)(
    DROITS_CELIAPP[k] = DROITS_CELIAPP[k-1] - COTIS_CELIAPP[k-1] + if k <= (5+1-ANNEES_CELIAPP_ACCUMULEES) then 8000 else 0 endif
);
constraint forall(k in 1..N)(
  COTIS_CELIAPP[k] <= DROITS_CELIAPP[k]
);
constraint CUMUL_CELIAPP[1] = CELIAPP_NOW + COTIS_CELIAPP[1] * (1 + RENDEMENT)^((12 - (MOIS - 1))/12);
constraint forall(k in 2..N)(
  CUMUL_CELIAPP[k] = (COTIS_CELIAPP[k] + CUMUL_CELIAPP[k-1]) * (1 + RENDEMENT)
);
constraint DROITS_CELI[1] = DROITS_CELI_RESTANTS;
constraint forall(k in 2..N)(
    DROITS_CELI[k] = DROITS_CELI[k-1] - COTIS_CELI[k-1] + 500 * round(PLAFOND_CELI_NOW * (1 + INFLATION_CELI)^(k-1) / 500)
);
constraint forall(k in 1..N)(
  COTIS_CELI[k] <= DROITS_CELI[k]
);
constraint CUMUL_CELI[1] = (CELI_NOW + COTIS_CELI[1]) * (1 + RENDEMENT)^((12 - (MOIS - 1))/12);
constraint forall(k in 2..N)(
  CUMUL_CELI[k] = (COTIS_CELI[k] + CUMUL_CELI[k-1]) * (1 + RENDEMENT)
);
constraint forall(k in 1..N) (
  FACTEUR_EQUIVALENCE[k] = max(0, 9 * (0.015 * min(SALAIRES_BRUT[k], PLAFOND_SALAIRE_RRQ_NOW * (1 + INFLATION)^(k-1)) + 0.02 * max(0, SALAIRES_BRUT[k] - PLAFOND_SALAIRE_RRQ_NOW * (1 + INFLATION)^(k-1))) - 600 * (1 + INFLATION)^(k-1))
);
constraint DROITS_REER[1] = DROITS_REER_RESTANTS;
constraint forall(k in 2..N)(
    DROITS_REER[k] = DROITS_REER[k-1] - COTIS_REER[k-1] + min(SALAIRES_BRUT[k] * 0.18, PLAFOND_REER_NOW * (1 + INFLATION)^(k-1)) - FACTEUR_EQUIVALENCE[k]
);
constraint forall(k in 1..N)(
  COTIS_REER[k] <= DROITS_REER[k]
);

constraint SHARE_PRICE[1] = SHARE_PRICE_THEORICAL * (1 + RENDEMENT)^((12 - (MOIS - 1))/12);
constraint forall(k in 2..N) (
    SHARE_PRICE[k] = SHARE_PRICE_THEORICAL * (1 + RENDEMENT)^(k-1)
);

constraint forall(k in 1..N) (
    SELL_REER[k] <= CUMUL_VALUE_REER[k]
);
constraint CUMUL_VALUE_REER[1] = (REER_NOW + COTIS_REER[1]) * (1 + RENDEMENT)^((12 - (MOIS - 1))/12);
constraint forall(k in 2..N)(
  CUMUL_VALUE_REER[k] =  (COTIS_REER[k] + CUMUL_VALUE_REER[k-1] - SELL_REER[k-1]) * (1 + RENDEMENT)
);

constraint forall(k in 1..N) (
    SELL_NONENR[k] <= CUMUL_VALUE_NONENR[k]
);
constraint forall(k in 1..N) (
    SHARES_BOUGHT_NONENR[k] * SHARE_PRICE[k] = COTIS_NONENR[k]
);
constraint forall(k in 1..N) (
    SHARES_SOLD_NONENR[k] * SHARE_PRICE[k] = SELL_NONENR[k]
);
constraint CUMUL_SHARES_NONENR_START[1] = NONENR_NOW / SHARE_PRICE_THEORICAL + SHARES_BOUGHT_NONENR[1];
constraint forall(k in 2..N) (
    CUMUL_SHARES_NONENR_START[k] = SHARES_BOUGHT_NONENR[k] + CUMUL_SHARES_NONENR_END[k-1]
);
constraint forall(k in 1..N) (
    CUMUL_SHARES_NONENR_END[k] = CUMUL_SHARES_NONENR_START[k] - SHARES_SOLD_NONENR[k]
);
constraint forall(k in 1..N) (
    CUMUL_VALUE_NONENR[k] = CUMUL_SHARES_NONENR_START[k] * SHARE_PRICE[k]
);
constraint NONENR_NOW > PENNY -> AVG_BOUGHT_SHAREPRICE_NONENR[1] = (NONENR_NOW - NONENR_GAIN_NOW) * SHARE_PRICE[1] / NONENR_NOW;
constraint NONENR_NOW <= PENNY -> AVG_BOUGHT_SHAREPRICE_NONENR[1] = SHARE_PRICE[1];
constraint forall(k in 2..N) (
    AVG_BOUGHT_SHAREPRICE_NONENR[k] * CUMUL_SHARES_NONENR_START[k] = (AVG_BOUGHT_SHAREPRICE_NONENR[k-1] * CUMUL_SHARES_NONENR_END[k-1] + SHARE_PRICE[k] * SHARES_BOUGHT_NONENR[k]) 
);
% pour éviter 0*x = 0*y
constraint forall(k in 2..N) (
  (AVG_BOUGHT_SHAREPRICE_NONENR[k-1] * CUMUL_SHARES_NONENR_END[k-1] + SHARE_PRICE[k] * SHARES_BOUGHT_NONENR[k]) <= PENNY -> CUMUL_SHARES_NONENR_START[k] = 0 /\ AVG_BOUGHT_SHAREPRICE_NONENR[k] = 0
);
constraint forall(k in 1..N)(
    GAIN_REALISED_NONENR[k] = (SHARE_PRICE[k] - AVG_BOUGHT_SHAREPRICE_NONENR[k]) * SHARES_SOLD_NONENR[k]
);

constraint RAP <= min(PLAFOND_RAP_NOW, CUMUL_VALUE_REER[N] - SELL_REER[N]);

%%% Bris de symmétries
% on met cette contrainte pour forcer ces cas-là à investir en non enregistré
constraint forall(k in 1..N)(
  SELL_REER[k] = 0 \/ COTIS_REER[k] = 0
);
% on priorise CELI au NONENR
constraint forall(k in 1..N)(
  COTIS_NONENR[k] <= COTIS_CELI[k] \/ COTIS_CELI[k] = DROITS_CELI[k]
);
% CONTRAINTE LIMITANT LA SOLUTION OPTIMALE
% on va dire : on ne peut pas acheter et vendre du NONENR la même année
constraint forall(k in 1..N)(
  SELL_NONENR[k] = 0 \/ COTIS_NONENR[k] = 0
);
% CONTRAINTE LIMITANT LA SOLUTION OPTIMALE
% on va dire : tant que ya dla place dans CELIAPP, on ne peut pas toucher au CELI et REER et NONENR
constraint forall(k in 1..N)(
  COTIS_CELIAPP[k] < DROITS_CELIAPP[k] -> COTIS_NONENR[k] = 0 /\ COTIS_CELI[k] = 0 /\ COTIS_REER[k] = 0
);
% CONTRAINTE LIMITANT LA SOLUTION OPTIMALE
% on va dire : pas le droit de vendre avant une certainne année
constraint forall(k in 1..(YEAR_START_SELLING_REER-1))(
  k >= 1 -> SELL_REER[k] = 0
);
constraint forall(k in YEAR_START_SELLING_REER..N)(
  COTIS_REER[k] = 0
);
constraint forall(k in 1..(YEAR_START_SELLING_NONENR-1))(
  k >= 1 -> SELL_NONENR[k] = 0
);
constraint forall(k in YEAR_START_SELLING_NONENR..N)(
  COTIS_NONENR[k] = 0
);
% CONTRAINTE LIMITANT LA SOLUTION OPTIMALE
% on va dire : on doit vendre de plus en plus
constraint forall(k in 2..N)(SELL_REER[k-1] <= SELL_REER[k] /\ SELL_NONENR[k-1] <= SELL_NONENR[k]);
constraint forall(k in 2..N)(COTIS_REER[k-1] >= COTIS_REER[k] /\ COTIS_NONENR[k-1] >= COTIS_NONENR[k]);
%%%


%%% variable à maximiser
constraint CASHDOWN = round(100 * (LIQUIDE[N+1] - 10000 + CUMUL_CELIAPP[N] + CUMUL_CELI[N] + RAP)) / 100;

solve 
  ::seq_search([
  float_search([
    if i mod 2 == 1 then LIQUIDE[(i+1) div 2]
    else SELL_REER[i div 2] endif
    | i in 1..2*N+1
  ], 1000, input_order, indomain_min),
  float_search([
    if i mod 3 == 1 then COTIS_CELIAPP[(i+2) div 3]
    elseif i mod 3 == 2 then COTIS_CELI[(i+1) div 3]
    else COTIS_NONENR[i div 3] endif
    | i in 1..3*N
  ], 1000, input_order, indomain_max),
  float_search([RAP], 1000, input_order, indomain_max)
  ])
  maximize CASHDOWN;


%%% Afficher
output ["CASHDOWN = ", show(floor(CASHDOWN)), ".", show(floor((CASHDOWN - floor(CASHDOWN)) * 100)), "$ | ", "RAP = ", show(round(RAP)),"\n"];
output ["LIQUIDE = ", join(" ", [show(round(LIQUIDE[i])) | i in 1..(N+1)]), "\n"];
output ["SALAIRES_BRUT = ", join(" ", [show(round(SALAIRES_BRUT[i])) | i in 1..N]), "\n"];
output ["SALAIRE_IMPOSABLE = ", join(" ", [show(round(SALAIRE_IMPOSABLE[i])) | i in 1..N]), "\n"];
output ["ECONOMIES = ", join(" ", [show(round(ECONOMIES[i])) | i in 1..N]), "\n"];
output ["RETOUR_IMPOT = ", join(" ", [show(round(RETOUR_IMPOT[i])) | i in 1..N]), "\n"];
output ["IMPOT_PAYE = ", join(" ", [show(round(IMPOT_PAYE[i])) | i in 1..N]), "\n"];
output ["IMPOT_DU = ", join(" ", [show(round(IMPOT_DU[i])) | i in 1..N]), "\n"];
%output ["RQAP = ", join(" ", [show(round(RQAP[i])) | i in 1..N]), "\n"];
%output ["AE = ", join(" ", [show(round(AE[i])) | i in 1..N]), "\n"];
%output ["RRQ = ", join(" ", [show(round(RRQ[i])) | i in 1..N]), "\n"];
%output ["FOND_RETRAITE = ", join(" ", [show(round(FOND_RETRAITE[i])) | i in 1..N]), "\n"];
%output ["NET = ", join(" ", [show(round(SALAIRES_BRUT[k] - IMPOT[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k])) | k in 1..N]), "\n"];
output ["COTIS_CELIAPP = ", join(" ", [show(round(COTIS_CELIAPP[i])) | i in 1..N]), "\n"];
%output ["DROITS CELIAPP = ", join(" ", [show(round(DROITS_CELIAPP[i])) | i in 1..N]), "\n"];
output ["COTIS_CELI = ", join(" ", [show(round(COTIS_CELI[i])) | i in 1..N]), "\n"];
%output ["DROITS CELI = ", join(" ", [show(round(DROITS_CELI[i])) | i in 1..N]), "\n"];
output ["DROITS REER = ", join(" ", [show(round(DROITS_REER[i])) | i in 1..N]), "\n"];
%output ["FACTEUR_EQUIVALENCE = ", join(" ", [show(round(FACTEUR_EQUIVALENCE[i])) | i in 1..N]), "\n"];
%output [join(" ", [show(round(PALIERS_IMPOTS_TO_PAY[k, j])) | k in 1..N]) ++ "\n" | j in 1..N_PALIERS];array[1..N] of var 0..BIG: COTIS_NONENR;
%output ["CUMUL_CELIAPP = ", join(" ", [show(round(CUMUL_CELIAPP[i])) | i in 1..N]), "\n"];
%output ["CUMUL_CELI = ", join(" ", [show(round(CUMUL_CELI[i])) | i in 1..N]), "\n"];
output ["COTIS_REER = ", join(" ", [show(round(COTIS_REER[i])) | i in 1..N]), "\n"];
output ["SELL_REER = ", join(" ", [show(round(SELL_REER[i])) | i in 1..N]), "\n"];
output ["COTIS_NONENR = ", join(" ", [show(round(COTIS_NONENR[i])) | i in 1..N]), "\n"];
output ["SELL_NONENR = ", join(" ", [show(round(SELL_NONENR[i])) | i in 1..N]), "\n"];
output ["CUMUL_VALUE_REER = ", join(" ", [show(round(CUMUL_VALUE_REER[i])) | i in 1..N]), "\n"];
output ["CUMUL_VALUE_NONENR = ", join(" ", [show(round(CUMUL_VALUE_NONENR[i])) | i in 1..N]), "\n"];
%output ["SHARE_PRICE = ", join(" ", [show(round(SHARE_PRICE[i])) | i in 1..N]), "\n"];
%output ["AVG_BOUGHT_SHAREPRICE_REER = ", join(" ", [show(round(AVG_BOUGHT_SHAREPRICE_REER[i])) | i in 1..N]), "\n"];
%output ["GAIN_REALISED_REER = ", join(" ", [show(round(GAIN_REALISED_REER[i])) | i in 1..N]), "\n"];
output ["GAIN_REALISED_NONENR = ", join(" ", [show(round(GAIN_REALISED_NONENR[i])) | i in 1..N]), "\n"];
output ["YEAR_START_SELLING_REER = ", show(YEAR_START_SELLING_REER), "\n"];
output ["YEAR_START_SELLING_NONENR = ", show(YEAR_START_SELLING_NONENR), "\n"];


include "fiscalite.dzn";

%%% Constantes
% LA PREMIÈRE ANNÉE n=1 EST CELLE EN COURS AVANT JANVIER
int: N;
int: N_PALIERS;
float: BIG = 10000000;
float: share_price_theorical = 140;
float: INFLATION;
float: RENDEMENT;
float: LIQUIDE_NOW;
float: DROITS_CELIAPP_RESTANTS;
float: DROITS_CELI_RESTANTS;
int: ANNEES_CELIAPP_ACCUMULEES;
array[1..N] of float: SALAIRES_FUTURS_IMPOT;
array[1..N] of float: DEPENSES;
array[1..N_PALIERS] of float: PALIERS_IMPOTS;
array[1..N_PALIERS] of float: PALIERS_IMPOTS_RATES;

%%% functions

%%% Variables

% variables fixées par data et contraintes
array[1..(N+1)] of var -BIG..BIG: LIQUIDE;
var -BIG..BIG: CASHDOWN;
array[1..N] of var float: SHARE_PRICE;
array[1..N] of var 0..BIG: SALAIRE_IMPOSABLE;
array[1..N] of var -BIG..BIG: IMPOT;
array[1..N] of var -BIG..BIG: RQAP;
array[1..N] of var -BIG..BIG: AE;
array[1..N] of var -BIG..BIG: RRQ;
array[1..N] of var -BIG..BIG: FOND_RETRAITE;
array[1..N] of var -BIG..BIG: CUMUL_CELIAPP;
array[1..N] of var -BIG..BIG: DROITS_CELIAPP;
array[1..N] of var -BIG..BIG: CUMUL_CELI;
array[1..N] of var -BIG..BIG: DROITS_CELI;
array[1..N] of var 0..BIG: SHARES_BOUGHT_NONENR;
array[1..N] of var 0..BIG: SHARES_SOLD_NONENR;
array[1..N] of var 0..BIG: CUMUL_SHARES_NONENR_START;
array[1..N] of var 0..BIG: CUMUL_SHARES_NONENR_END;
array[1..N] of var 0..BIG: CUMUL_VALUE_NONENR;
array[1..N] of var 0..BIG: AVG_BOUGHT_SHAREPRICE_NONENR;
array[1..N] of var -BIG..BIG: GAIN_REALISED_NONENR;
array[1..N, 1..N_PALIERS] of var -BIG..BIG: PALIERS_IMPOTS_TO_PAY;
var 0..2: HEUR1;
var 0..0.01: PENNY;

array[1..N] of var -BIG..BIG: COTIS_CELIAPP;
array[1..N] of var -BIG..BIG: COTIS_CELI;
array[1..N] of var 0..BIG: COTIS_NONENR;
array[1..N] of var 0..BIG: SELL_NONENR;


%%% Contraintes


%% contraintes pour fixer les variables déterministes
constraint LIQUIDE[1] = LIQUIDE_NOW;
constraint forall(k in 1..N) (
  LIQUIDE[k + 1] = LIQUIDE[k] + SALAIRES_FUTURS_IMPOT[k] - IMPOT[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k] - DEPENSES[k] - COTIS_CELIAPP[k] - COTIS_CELI[k] - COTIS_NONENR[k] + SELL_NONENR[k]
);

constraint forall(k in 1..N) (
  SALAIRE_IMPOSABLE[k] = SALAIRES_FUTURS_IMPOT[k] - COTIS_CELIAPP[k] + GAIN_REALISED_NONENR[k] / 2% TODO retirer reer
);
constraint forall(k in 1..N) (
    forall(j in 1..(N_PALIERS-1))(
      PALIERS_IMPOTS_TO_PAY[k, j] = max(min(PALIERS_IMPOTS[j+1], SALAIRE_IMPOSABLE[k]) - PALIERS_IMPOTS[j], 0) * PALIERS_IMPOTS_RATES[j]
));
constraint forall(k in 1..N) (
    PALIERS_IMPOTS_TO_PAY[k, N_PALIERS] = max(SALAIRE_IMPOSABLE[k] - PALIERS_IMPOTS[N_PALIERS], 0) * PALIERS_IMPOTS_RATES[N_PALIERS]
);

constraint forall(k in 1..N) (
    IMPOT[k] = sum(j in 1..N_PALIERS)(PALIERS_IMPOTS_TO_PAY[k, j])
);
constraint forall(k in 1..N) (
    RQAP[k] = min(SALAIRES_FUTURS_IMPOT[k], 94000 * (1 + INFLATION)^(k-1)) * 0.00494
);
constraint forall(k in 1..N) (
    AE[k] = min(SALAIRES_FUTURS_IMPOT[k], 65700 * (1 + INFLATION)^(k-1)) * 0.0164
);
constraint forall(k in 1..N) (
    RRQ[k] = (min(SALAIRES_FUTURS_IMPOT[k], 68500 * (1 + INFLATION)^(k-1)) * 0.054 + max(0, SALAIRES_FUTURS_IMPOT[k] - 68500 * (1 + INFLATION)^(k-1)) * 0.04)
);
constraint forall(k in 1..N) (
    FOND_RETRAITE[k] = (min(SALAIRES_FUTURS_IMPOT[k], 68500 * (1 + INFLATION)^(k-1)) * 0.0705 + max(0, SALAIRES_FUTURS_IMPOT[k] - 68500 * (1 + INFLATION)^(k-1)) * 0.0855)
);

%% vraies contraintes libres
constraint forall(k in 1..(N+1)) (
  LIQUIDE[k] >= 0
);
constraint DROITS_CELIAPP[1] = DROITS_CELIAPP_RESTANTS;
constraint forall(k in 2..N)(
    DROITS_CELIAPP[k] = DROITS_CELIAPP[k-1] - COTIS_CELIAPP[k-1] + if k <= (5+1-ANNEES_CELIAPP_ACCUMULEES) then 8000 else 0 endif
);
constraint forall(k in 1..N)(
  COTIS_CELIAPP[k] >= 0 /\ COTIS_CELIAPP[k] <= DROITS_CELIAPP[k] /\ COTIS_CELIAPP[k] <= SALAIRES_FUTURS_IMPOT[k]
);
constraint CUMUL_CELIAPP[1] = COTIS_CELIAPP[1] * (1 + RENDEMENT);
constraint forall(k in 2..N)(
  CUMUL_CELIAPP[k] = (COTIS_CELIAPP[k] + CUMUL_CELIAPP[k-1]) * (1 + RENDEMENT)
);
constraint DROITS_CELI[1] = DROITS_CELI_RESTANTS;
constraint forall(k in 2..N)(
    DROITS_CELI[k] = DROITS_CELI[k-1] - COTIS_CELI[k-1] + 500 * round(7000 * (1 + INFLATION)^(k-1) / 500)
);
constraint forall(k in 1..N)(
  COTIS_CELI[k] >= 0 /\ COTIS_CELI[k] <= DROITS_CELI[k]
);
constraint CUMUL_CELI[1] = COTIS_CELI[1] * (1 + RENDEMENT);
constraint forall(k in 2..N)(
  CUMUL_CELI[k] = (COTIS_CELI[k] + CUMUL_CELI[k-1]) * (1 + RENDEMENT)
);

constraint forall(k in 1..N) (
    SHARE_PRICE[k] = share_price_theorical * (1 + RENDEMENT)^(k-1)
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
constraint CUMUL_SHARES_NONENR_START[1] = SHARES_BOUGHT_NONENR[1];
constraint forall(k in 2..N) (
    CUMUL_SHARES_NONENR_START[k] = SHARES_BOUGHT_NONENR[k] + CUMUL_SHARES_NONENR_END[k-1]
);
constraint forall(k in 1..N) (
    CUMUL_SHARES_NONENR_END[k] = CUMUL_SHARES_NONENR_START[k] - SELL_NONENR[k]
);
constraint forall(k in 1..N) (
    CUMUL_VALUE_NONENR[k] >= SELL_NONENR[k]
);
constraint forall(k in 1..N) (
    CUMUL_VALUE_NONENR[k] = CUMUL_SHARES_NONENR_START[k] * SHARE_PRICE[k]
);
constraint AVG_BOUGHT_SHAREPRICE_NONENR[1] = SHARE_PRICE[1];
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

% pour avoir assez d'argent pour investir
constraint forall(k in 1..N) (
    LIQUIDE[k] >= COTIS_CELIAPP[k] + COTIS_CELI[k] + COTIS_NONENR[k] - SELL_NONENR[k]
);

constraint HEUR1 = 1 \/ HEUR1 = 1 \/ HEUR1 = 2;
constraint forall(k in 1..N)(
  HEUR1 = 1 -> PENNY = 0 /\ SELL_NONENR[k] = 0 /\ COTIS_CELIAPP[k] = 0 /\ COTIS_CELI[k] = 0
);
constraint forall(k in 1..N)(
  HEUR1 = 2 -> COTIS_CELIAPP[k] = 0 /\ COTIS_CELI[k] = 0
);
%constraint SHARES_SOLD_NONENR[3] >= 1;

%%% variable à maximiser
constraint CASHDOWN = round(100 * (LIQUIDE[N+1] - 10000 + CUMUL_CELIAPP[N] + CUMUL_CELI[N])) / 100;

solve 
  ::seq_search([
  int_search([HEUR1], input_order, indomain_max),
  float_search([PENNY], 0.000001, input_order, indomain_min)
  ])
  maximize CASHDOWN;

%%% Afficher
output ["CASHDOWN = ", show(CASHDOWN), " | HEUR1 = ", show(HEUR1), " | PENNY = ", show(PENNY), "\n"];
output ["LIQUIDE = ", join(" ", [show(round(LIQUIDE[i])) | i in 1..(N+1)]), "\n"];
output ["SALAIRES_FUTURS_IMPOT = ", join(" ", [show(round(SALAIRES_FUTURS_IMPOT[i])) | i in 1..N]), "\n"];
output ["SALAIRE_IMPOSABLE = ", join(" ", [show(round(SALAIRE_IMPOSABLE[i])) | i in 1..N]), "\n"];
%output ["IMPOT = ", join(" ", [show(round(IMPOT[i])) | i in 1..N]), "\n"];
%output ["RQAP = ", join(" ", [show(round(RQAP[i])) | i in 1..N]), "\n"];
%output ["AE = ", join(" ", [show(round(AE[i])) | i in 1..N]), "\n"];
%output ["RRQ = ", join(" ", [show(round(RRQ[i])) | i in 1..N]), "\n"];
%output ["FOND_RETRAITE = ", join(" ", [show(round(FOND_RETRAITE[i])) | i in 1..N]), "\n"];
%output ["NET = ", join(" ", [show(round(SALAIRES_FUTURS_IMPOT[k] - IMPOT[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k])) | k in 1..N]), "\n"];
output ["COTIS_CELIAPP = ", join(" ", [show(round(COTIS_CELIAPP[i])) | i in 1..N]), "\n"];
%output ["DROITS CELIAPP = ", join(" ", [show(round(DROITS_CELIAPP[i])) | i in 1..N]), "\n"];
output ["COTIS_CELI = ", join(" ", [show(round(COTIS_CELI[i])) | i in 1..N]), "\n"];
%output ["DROITS CELI = ", join(" ", [show(round(DROITS_CELI[i])) | i in 1..N]), "\n"];
%output [join(" ", [show(round(PALIERS_IMPOTS_TO_PAY[k, j])) | k in 1..N]) ++ "\n" | j in 1..N_PALIERS];array[1..N] of var 0..BIG: COTIS_NONENR;
output ["COTIS_NONENR = ", join(" ", [show(round(COTIS_NONENR[i])) | i in 1..N]), "\n"];
output ["SELL_NONENR = ", join(" ", [show(round(SELL_NONENR[i])) | i in 1..N]), "\n"];
output ["SHARE_PRICE = ", join(" ", [show(round(SHARE_PRICE[i])) | i in 1..N]), "\n"];
output ["SHARES_BOUGHT_NONENR = ", join(" ", [show((SHARES_BOUGHT_NONENR[i])) | i in 1..N]), "\n"];
output ["SHARES_SOLD_NONENR = ", join(" ", [show((SHARES_SOLD_NONENR[i])) | i in 1..N]), "\n"];
output ["CUMUL_SHARES_NONENR_START = ", join(" ", [show((CUMUL_SHARES_NONENR_START[i])) | i in 1..N]), "\n"];
output ["CUMUL_SHARES_NONENR_END = ", join(" ", [show((CUMUL_SHARES_NONENR_END[i])) | i in 1..N]), "\n"];
%output ["CUMUL_VALUE_NONENR = ", join(" ", [show(round(CUMUL_VALUE_NONENR[i])) | i in 1..N]), "\n"];
output ["AVG_BOUGHT_SHAREPRICE_NONENR = ", join(" ", [show(round(AVG_BOUGHT_SHAREPRICE_NONENR[i])) | i in 1..N]), "\n"];
output ["GAIN_REALISED_NONENR = ", join(" ", [show(round(GAIN_REALISED_NONENR[i])) | i in 1..N]), "\n"];


include "fiscalite.dzn";

%%% Constantes
% LA PREMIÈRE ANNÉE n=1 EST CELLE EN COURS AVANT JANVIER
int: N;
int: N_PALIERS;
float: BIG = 1000000000;
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
var float: TEST;
var -BIG..BIG: CASHDOWN;
array[1..N] of var -BIG..BIG: SALAIRE_IMPOSABLE;
array[1..N] of var -BIG..BIG: IMPOT;
array[1..N] of var -BIG..BIG: RQAP;
array[1..N] of var -BIG..BIG: AE;
array[1..N] of var -BIG..BIG: RRQ;
array[1..N] of var -BIG..BIG: FOND_RETRAITE;
array[1..N] of var -BIG..BIG: COTIS_CELIAPP;
array[1..N] of var -BIG..BIG: CUMUL_CELIAPP;
array[1..N] of var -BIG..BIG: DROITS_CELIAPP;
array[1..N] of var -BIG..BIG: COTIS_CELI;
array[1..N] of var -BIG..BIG: CUMUL_CELI;
array[1..N] of var -BIG..BIG: DROITS_CELI;
array[1..N, 1..N_PALIERS] of var -BIG..BIG: PALIERS_IMPOTS_TO_PAY;

%%% Contraintes


%% contraintes pour fixer les variables déterministes
constraint LIQUIDE[1] = LIQUIDE_NOW;
constraint forall(k in 1..N) (
  LIQUIDE[k + 1] = LIQUIDE[k] + SALAIRES_FUTURS_IMPOT[k] - IMPOT[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k] - DEPENSES[k] - COTIS_CELIAPP[k]
);

constraint forall(k in 1..N) (
  SALAIRE_IMPOSABLE[k] = SALAIRES_FUTURS_IMPOT[k] - COTIS_CELIAPP[k]% TODO retirer reer, ajouter gain capital
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
    FOND_RETRAITE[k] <= (min(SALAIRE_IMPOSABLE[k], 68500 * (1 + INFLATION)^(k-1)) * 0.0705 + max(0, SALAIRE_IMPOSABLE[k] - 68500 * (1 + INFLATION)^(k-1)) * 0.0855)
);
constraint forall(k in 1..N) (
    FOND_RETRAITE[k] >= min(SALAIRE_IMPOSABLE[k], 68500 * (1 + INFLATION)^(k-1)) * 0.0705 + max(0, SALAIRE_IMPOSABLE[k] - 68500 * (1 + INFLATION)^(k-1)) * 0.0855
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


%%% variable à maximiser
constraint CASHDOWN = LIQUIDE[N+1] - 10000 + CUMUL_CELIAPP[N] + CUMUL_CELI[N];

solve 
  %::seq_search([
  %int_search(INVEST_CELI, input_order, indomain_min)
  %])
  maximize CASHDOWN;

%%% Afficher
output ["CASHDOWN = ", show(round(CASHDOWN)), "\n"];
output ["LIQUIDE = ", join(" ", [show(round(LIQUIDE[i])) | i in 1..(N+1)]), "\n"];
output ["SALAIRES_FUTURS_IMPOT = ", join(" ", [show(round(SALAIRES_FUTURS_IMPOT[i])) | i in 1..N]), "\n"];
output ["SALAIRE_IMPOSABLE = ", join(" ", [show(round(SALAIRE_IMPOSABLE[i])) | i in 1..N]), "\n"];
output ["IMPOT = ", join(" ", [show(round(IMPOT[i])) | i in 1..N]), "\n"];
output ["RQAP = ", join(" ", [show(round(RQAP[i])) | i in 1..N]), "\n"];
output ["AE = ", join(" ", [show(round(AE[i])) | i in 1..N]), "\n"];
output ["RRQ = ", join(" ", [show(round(RRQ[i])) | i in 1..N]), "\n"];
output ["FOND_RETRAITE = ", join(" ", [show(round(FOND_RETRAITE[i])) | i in 1..N]), "\n"];
output ["NET = ", join(" ", [show(round(SALAIRES_FUTURS_IMPOT[k] - IMPOT[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k])) | k in 1..N]), "\n"];
output ["NET = ", join(" ", [show(round(SALAIRES_FUTURS_IMPOT[k])) | k in 1..N]), "\n"];
output ["CELIAPP = ", join(" ", [show(round(COTIS_CELIAPP[i])) | i in 1..N]), "\n"];
output ["DROITS CELIAPP = ", join(" ", [show(round(DROITS_CELIAPP[i])) | i in 1..N]), "\n"];
output ["CELI = ", join(" ", [show(round(COTIS_CELI[i])) | i in 1..N]), "\n"];
output ["DROITS CELI = ", join(" ", [show(round(DROITS_CELI[i])) | i in 1..N]), "\n"];
%output [join(" ", [show(round(PALIERS_IMPOTS_TO_PAY[k, j])) | k in 1..N]) ++ "\n" | j in 1..N_PALIERS];
include "fiscalite.dzn";

%%% Constantes
int: N;
int: N_PALIERS;
float: EPS;
float: INFLATION;
float: LIQUIDE_NOW;
array[1..N] of float: SALAIRES_FUTURS_IMPOT;
array[1..N] of float: DEPENSES;
array[1..N_PALIERS] of float: PALIERS_IMPOTS;
array[1..N_PALIERS] of float: PALIERS_IMPOTS_RATES;

%%% Variables


% variables fixées par data et contraintes
array[1..(N+1)] of var float: LIQUIDE;
var float: CASHDOWN;
array[1..N] of var float: SALAIRE_IMPOSABLE;
array[1..N] of var float: IMPOT;
array[1..N] of var float: RQAP;
array[1..N] of var float: AE;
array[1..N] of var float: RRQ;
array[1..N] of var float: FOND_RETRAITE;
array[1..N, 1..N_PALIERS] of var float: PALIERS_IMPOTS_TO_PAY;

%%% Contraintes

%% contraintes pour fixer les variables déterministes
constraint LIQUIDE[1] = LIQUIDE_NOW;
constraint forall(k in 1..N) ( % Cluster
  LIQUIDE[k + 1] = LIQUIDE[k] + SALAIRES_FUTURS_IMPOT[k] - IMPOT[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k] - DEPENSES[k]
);

constraint forall(k in 1..N) (
  SALAIRE_IMPOSABLE[k] = SALAIRES_FUTURS_IMPOT[k] % TODO retirer celiapp, reer, ajouter gain capital
);
constraint forall(k in 1..N) (
    forall(j in 1..(N_PALIERS-1))(
      PALIERS_IMPOTS_TO_PAY[k, j] = max(min(PALIERS_IMPOTS[j+1], SALAIRE_IMPOSABLE[k]) - PALIERS_IMPOTS[j], 0) * PALIERS_IMPOTS_RATES[j]
));
constraint forall(k in 1..N) (
    PALIERS_IMPOTS_TO_PAY[k, N_PALIERS] = max(SALAIRE_IMPOSABLE[k] - PALIERS_IMPOTS[N_PALIERS], 0) * PALIERS_IMPOTS_RATES[N_PALIERS]
);

constraint forall(k in 1..N)(
  forall(j in 1..N_PALIERS)(
      PALIERS_IMPOTS_TO_PAY[k, j] >= 0
));
constraint forall(k in 1..N) (
    IMPOT[k] = sum(j in 1..N_PALIERS)(PALIERS_IMPOTS_TO_PAY[k, j])
);
constraint forall(k in 1..N) (
    RQAP[k] = min(SALAIRE_IMPOSABLE[k], 94000 * (1 + INFLATION)^k) * 0.00494
);
constraint forall(k in 1..N) (
    AE[k] = min(SALAIRE_IMPOSABLE[k], 65700 * (1 + INFLATION)^k) * 0.0164
);
constraint forall(k in 1..N) (
    RRQ[k] = min(max(0, SALAIRE_IMPOSABLE[k] - 68500 * (1 + INFLATION)^k), (73200-68500) * (1 + INFLATION)^k) * 0.04
);
constraint forall(k in 1..N) (
    FOND_RETRAITE[k] = min(SALAIRE_IMPOSABLE[k], 68500 * (1 + INFLATION)^k) * 0.0705 + max(0, SALAIRE_IMPOSABLE[k] - 68500 * (1 + INFLATION)^k) * 0.0855
);

%% vraies contraintes libres
constraint CASHDOWN >= 0;
constraint forall(k in 1..(N+1)) (
  LIQUIDE[k] >= 0
);

%%% variable à maximiser
constraint CASHDOWN = LIQUIDE[N+1] - 10000;

solve 
  %::seq_search([
  %int_search(INVEST_CELI, input_order, indomain_min)
  %])
  maximize CASHDOWN;


%%% Afficher
output ["CASHDOWN = ", show(CASHDOWN), "\n"];
output ["LIQUIDE = ", join(" ", [show(LIQUIDE[i]) | i in 1..(N+1)]), "\n"];
output ["SALAIRES_FUTURS_IMPOT = ", join(" ", [show(SALAIRES_FUTURS_IMPOT[i]) | i in 1..N]), "\n"];
output ["NET = ", join(" ", [show(SALAIRES_FUTURS_IMPOT[k] - IMPOT[k] - RQAP[k] - AE[k] - RRQ[k] - FOND_RETRAITE[k]) | k in 1..N]), "\n"];
output ["IMPOT = ", join(" ", [show(IMPOT[i]) | i in 1..N]), "\n"];

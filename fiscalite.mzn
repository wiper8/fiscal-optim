include "fiscalite.dzn";

%%% Constantes
int: N;
int: LIQUIDE_NOW;
array[1..N] of int: SALAIRES_FUTURS_IMPOT;
array[1..N] of int: DEPENSES;

%%% Variables
array[1..(N+1)] of var int: LIQUIDE;

% variables fixées par data et contraintes
var int: CASHDOWN;

%%% functions

%%% Contraintes

%% contraintes pour fixer les variables déterministes
constraint LIQUIDE[1] = LIQUIDE_NOW;
constraint forall(k in 1..N) ( % Cluster
  LIQUIDE[k + 1] = LIQUIDE[k] + SALAIRES_FUTURS_IMPOT[k] - DEPENSES[k]
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
output [join(" ", [show(LIQUIDE[i]) | i in 1..N]), "\n"];

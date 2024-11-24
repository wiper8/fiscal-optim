import json
from pyscipopt import Model, quicksum

# load all data from JSON files
from data_public import *
from data_private import *

# Model
model = Model("FiscalOptimizer")

# Variables

# Variables free
COTIS_CELIAPP = []
for i in range(N):
    COTIS_CELIAPP.append(model.addVar(name=f'COTIS_CELIAPP{i}', lb=0, ub=BIG))
COTIS_CELI = []
for i in range(N):
    COTIS_CELI.append(model.addVar(name=f'COTIS_CELI{i}', lb=0, ub=BIG))
COTIS_NONENR = []
for i in range(N):
    COTIS_NONENR.append(model.addVar(name=f'COTIS_NONENR{i}', lb=0, ub=BIG))
SELL_NONENR = []
for i in range(N):
    SELL_NONENR.append(model.addVar(name=f'SELL_NONENR{i}', lb=0, ub=BIG))
COTIS_REER = []
for i in range(N):
    COTIS_REER.append(model.addVar(name=f'COTIS_REER{i}', lb=0, ub=BIG))
SELL_REER = []
for i in range(N):
    SELL_REER.append(model.addVar(name=f'SELL_REER{i}', lb=0, ub=BIG))
RAP = model.addVar(name=f'RAP', lb=0, ub=BIG)

# Variables fixed
LIQUIDE = []
for i in range(N+1):
    LIQUIDE.append(model.addVar(name=f'LIQUIDE{i}', lb=-BIG, ub=BIG))
CASHDOWN = model.addVar(name="CASHDOWN")
SHARE_PRICE = []
for i in range(N):
    SHARE_PRICE.append(model.addVar(name=f'SHARE_PRICE{i}', lb=0, ub=BIG))
SALAIRE_IMPOSABLE = []
for i in range(N):
    SALAIRE_IMPOSABLE.append(model.addVar(name=f'SALAIRE_IMPOSABLE{i}', lb=0, ub=BIG))
IMPOT = []
for i in range(N):
    IMPOT.append(model.addVar(name=f'IMPOT{i}', lb=0, ub=BIG))
RQAP = []
for i in range(N):
    RQAP.append(model.addVar(name=f'RQAP{i}', lb=0, ub=BIG))
AE = []
for i in range(N):
    AE.append(model.addVar(name=f'AE{i}', lb=0, ub=BIG))
RRQ = []
for i in range(N):
    RRQ.append(model.addVar(name=f'RRQ{i}', lb=0, ub=BIG))
FOND_RETRAITE = []
for i in range(N):
    FOND_RETRAITE.append(model.addVar(name=f'FOND_RETRAITE{i}', lb=0, ub=BIG))
CUMUL_CELIAPP = []
for i in range(N):
    CUMUL_CELIAPP.append(model.addVar(name=f'CUMUL_CELIAPP{i}', lb=0, ub=BIG))
DROITS_CELIAPP = []
for i in range(N):
    DROITS_CELIAPP.append(model.addVar(name=f'DROITS_CELIAPP{i}', lb=0, ub=BIG))
CUMUL_CELI = []
for i in range(N):
    CUMUL_CELI.append(model.addVar(name=f'CUMUL_CELI{i}', lb=0, ub=BIG))
DROITS_CELI = []
for i in range(N):
    DROITS_CELI.append(model.addVar(name=f'DROITS_CELI{i}', lb=0, ub=BIG))
DROITS_REER = []
for i in range(N):
    DROITS_REER.append(model.addVar(name=f'DROITS_REER{i}', lb=0, ub=BIG))
SHARES_BOUGHT_REER = []
for i in range(N):
    SHARES_BOUGHT_REER.append(model.addVar(name=f'SHARES_BOUGHT_REER{i}', lb=0, ub=BIG))
SHARES_SOLD_REER = []
for i in range(N):
    SHARES_SOLD_REER.append(model.addVar(name=f'SHARES_SOLD_REER{i}', lb=0, ub=BIG))
CUMUL_SHARES_REER_START = []
for i in range(N):
    CUMUL_SHARES_REER_START.append(model.addVar(name=f'CUMUL_SHARES_REER_START{i}', lb=0, ub=BIG))
CUMUL_SHARES_REER_END = []
for i in range(N):
    CUMUL_SHARES_REER_END.append(model.addVar(name=f'CUMUL_SHARES_REER_END{i}', lb=0, ub=BIG))
CUMUL_VALUE_REER = []
for i in range(N):
    CUMUL_VALUE_REER.append(model.addVar(name=f'CUMUL_VALUE_REER{i}', lb=0, ub=BIG))
AVG_BOUGHT_SHAREPRICE_REER = []
for i in range(N):
    AVG_BOUGHT_SHAREPRICE_REER.append(model.addVar(name=f'AVG_BOUGHT_SHAREPRICE_REER{i}', lb=0, ub=BIG))
GAIN_REALISED_REER = []
for i in range(N):
    GAIN_REALISED_REER.append(model.addVar(name=f'GAIN_REALISED_REER{i}', lb=-BIG, ub=BIG))
FACTEUR_EQUIVALENCE = []
for i in range(N):
    FACTEUR_EQUIVALENCE.append(model.addVar(name=f'FACTEUR_EQUIVALENCE{i}', lb=0, ub=BIG))
SHARES_BOUGHT_NONENR = []
for i in range(N):
    SHARES_BOUGHT_NONENR.append(model.addVar(name=f'SHARES_BOUGHT_NONENR{i}', lb=0, ub=BIG))
SHARES_SOLD_NONENR = []
for i in range(N):
    SHARES_SOLD_NONENR.append(model.addVar(name=f'SHARES_SOLD_NONENR{i}', lb=0, ub=BIG))
CUMUL_SHARES_NONENR_START = []
for i in range(N):
    CUMUL_SHARES_NONENR_START.append(model.addVar(name=f'CUMUL_SHARES_NONENR_START{i}', lb=0, ub=BIG))
CUMUL_SHARES_NONENR_END = []
for i in range(N):
    CUMUL_SHARES_NONENR_END.append(model.addVar(name=f'CUMUL_SHARES_NONENR_END{i}', lb=0, ub=BIG))
CUMUL_VALUE_NONENR = []
for i in range(N):
    CUMUL_VALUE_NONENR.append(model.addVar(name=f'CUMUL_VALUE_NONENR{i}', lb=0, ub=BIG))
AVG_BOUGHT_SHAREPRICE_NONENR = []
for i in range(N):
    AVG_BOUGHT_SHAREPRICE_NONENR.append(model.addVar(name=f'AVG_BOUGHT_SHAREPRICE_NONENR{i}', lb=0, ub=BIG))
GAIN_REALISED_NONENR = []
for i in range(N):
    GAIN_REALISED_NONENR.append(model.addVar(name=f'GAIN_REALISED_NONENR{i}', lb=-BIG, ub=BIG))
PALIERS_IMPOTS_TO_PAY = [None] * N
for i in range(N):
    PALIERS_IMPOTS_TO_PAY[i] = [model.addVar(name=f'PALIERS_IMPOTS_TO_PAY{i}_{j}', lb=-BIG, ub=BIG) for j in range(N_PALIERS)]

# Constraints
# Constraints to fix variables
model.addCons(LIQUIDE[0] == LIQUIDE_NOW)
for i in range(N):
    model.addCons(LIQUIDE[i+1] == LIQUIDE[i] + SALAIRES_FUTURS_IMPOT[i] - IMPOT[i] - RQAP[i] - AE[i] - RRQ[i] -
                  FOND_RETRAITE[i] - DEPENSES[i] - COTIS_CELIAPP[i] - COTIS_CELI[i] - COTIS_REER[i] - COTIS_NONENR[i] +
                  SELL_REER[i] + SELL_NONENR[i])
for i in range(N):
    model.addCons(SALAIRE_IMPOSABLE[i] == SALAIRES_FUTURS_IMPOT[i] - COTIS_CELIAPP[i] - COTIS_REER[i] + SELL_REER[i] +
                  GAIN_REALISED_REER[i] / 2 + GAIN_REALISED_NONENR[i] / 2)

### TODO
for i in range(N):
    for j in range(N_PALIERS):
        model.addCons(
            PALIERS_IMPOTS_TO_PAY[i][j] ==
            SALAIRE_IMPOSABLE[i] * PALIERS_IMPOTS_RATES[j]

        )
# for i in range(N):
#     for j in range(N_PALIERS):
#         model.addCons(
#             PALIERS_IMPOTS_TO_PAY[i][j] ==
#             model.addExprNonlinear(
#                 max(
#                     min(
#                         PALIERS_IMPOTS[j+1],
#                         SALAIRE_IMPOSABLE[i]
#                     ) - PALIERS_IMPOTS[j],
#                     0
#                 ) * PALIERS_IMPOTS_RATES[j]
#             )
#         )
### TODO

for i in range(N):
    model.addCons(IMPOT[i] == quicksum(PALIERS_IMPOTS_TO_PAY[i][j] for j in range(N_PALIERS)))

### TODO
for i in range(N):
    model.addCons(RQAP[i] == 94000 * (1 + INFLATION) ** i * 0.00494)
for i in range(N):
    model.addCons(AE[i] == 65700 * (1 + INFLATION) ** i * 0.0164)
for i in range(N):
    model.addCons(RRQ[i] == 68500 * (1 + INFLATION) ** i * 0.054)
for i in range(N):
    model.addCons(FOND_RETRAITE[i] == 68500 * (1 + INFLATION) ** i * 0.0705)
### TODO

model.addCons(DROITS_CELIAPP[0] == DROITS_CELIAPP_RESTANTS)
### TODO
for i in range(1, N):
    model.addCons(DROITS_CELIAPP[i] == DROITS_CELIAPP[i-1] - COTIS_CELIAPP[i-1] + 8000)
### TODO
for i in range(N):
    model.addCons(COTIS_CELIAPP[i] <= DROITS_CELIAPP[i])
    model.addCons(COTIS_CELIAPP[i] <= SALAIRES_FUTURS_IMPOT[i])

model.addCons(CUMUL_CELIAPP[0] == CELIAPP_NOW + COTIS_CELIAPP[0] * (1 + RENDEMENT))
for i in range(1, N):
    model.addCons(CUMUL_CELIAPP[i] == (COTIS_CELIAPP[i] + CUMUL_CELIAPP[i - 1]) * (1 + RENDEMENT))
model.addCons(DROITS_CELI[0] == DROITS_CELI_RESTANTS)
for i in range(1, N):
    model.addCons(DROITS_CELI[i] == DROITS_CELI[i-1] - COTIS_CELI[i-1] + 500 * round(7000 * (1 + INFLATION)**(i-1) / 500))
### TODO
for i in range(N):
    model.addCons(FACTEUR_EQUIVALENCE[i] == 9 * (
                0.015 * 68500 * (1 + INFLATION) ** i + 0.02 * (SALAIRES_FUTURS_IMPOT[i] -
                68500 * (1 + INFLATION) ** i)) - 600)
### TODO
model.addCons(DROITS_REER[0] == DROITS_REER_RESTANTS)
### TODO
for i in range(1, N):
    model.addCons(DROITS_REER[i] == DROITS_REER[i-1] - COTIS_REER[i-1] + SALAIRES_FUTURS_IMPOT[i] * 0.18 - FACTEUR_EQUIVALENCE[i])
### TODO
for i in range(N):
    model.addCons(SHARE_PRICE[i] == share_price_theorical * (1 + RENDEMENT) ** i)
for i in range(N):
    model.addCons(SHARES_BOUGHT_REER[i] * SHARE_PRICE[i] == COTIS_REER[i])
for i in range(N):
    model.addCons(SHARES_SOLD_REER[i] * SHARE_PRICE[i] == SELL_REER[i])
model.addCons(CUMUL_SHARES_REER_START[0] == REER_NOW / share_price_theorical + SHARES_BOUGHT_REER[0])
for i in range(1, N):
    model.addCons(CUMUL_SHARES_NONENR_START[i] == SHARES_BOUGHT_NONENR[i] + CUMUL_SHARES_NONENR_END[i-1])
for i in range(N):
    model.addCons(CUMUL_SHARES_NONENR_END[i] == CUMUL_SHARES_NONENR_START[i] - SHARES_SOLD_NONENR[i])
for i in range(N):
    model.addCons(CUMUL_VALUE_REER[i] == CUMUL_SHARES_REER_START[i] * SHARE_PRICE[i])
model.addCons(AVG_BOUGHT_SHAREPRICE_REER[0] == SHARE_PRICE[0])
for i in range(1, N):
    model.addCons(AVG_BOUGHT_SHAREPRICE_REER[i] * CUMUL_SHARES_REER_START[i] == (AVG_BOUGHT_SHAREPRICE_REER[i-1] * CUMUL_SHARES_REER_END[i-1] + SHARE_PRICE[i] * SHARES_BOUGHT_REER[i]))
# pour éviter 0*x == 0*y
### TODO
#for i in range(1, N):
#    model.addCons(
#        (AVG_BOUGHT_SHAREPRICE_REER[k - 1] * CUMUL_SHARES_REER_END[k - 1] + SHARE_PRICE[k] * SHARES_BOUGHT_REER[
#            k]) <= PENNY -> CUMUL_SHARES_REER_START[k] = 0 /\ AVG_BOUGHT_SHAREPRICE_REER[k] = 0
#    )
### TODO

### TODO commencer la boucle à i=0
for i in range(1, N):
    model.addCons(GAIN_REALISED_REER[i] == (SHARE_PRICE[i] - AVG_BOUGHT_SHAREPRICE_REER[i]) * SHARES_SOLD_REER[i])

for i in range(N):
    model.addCons(CUMUL_VALUE_NONENR[i] == CUMUL_SHARES_NONENR_START[i] * SHARE_PRICE[i])
model.addCons(AVG_BOUGHT_SHAREPRICE_NONENR[0] == SHARE_PRICE[0])
for i in range(N):
    model.addCons(
        AVG_BOUGHT_SHAREPRICE_NONENR[i] * CUMUL_SHARES_NONENR_START[i] == (
                AVG_BOUGHT_SHAREPRICE_NONENR[i-1] * CUMUL_SHARES_NONENR_END[i-1] +
                SHARE_PRICE[i] * SHARES_BOUGHT_NONENR[i])
    )
# pour éviter 0*x == 0*y
### TODO
#for i in range(1, N):
#    model.addCons(
#        (AVG_BOUGHT_SHAREPRICE_NONENR[k - 1] * CUMUL_SHARES_NONENR_END[k - 1] + SHARE_PRICE[k] * SHARES_BOUGHT_NONENR[
#            k]) <= PENNY -> CUMUL_SHARES_NONENR_START[k] = 0 /\ AVG_BOUGHT_SHAREPRICE_NONENR[k] = 0
#    )
### TODO
for i in range(N):
    model.addCons(GAIN_REALISED_NONENR[i] == (SHARE_PRICE[i] - AVG_BOUGHT_SHAREPRICE_NONENR[i]) * SHARES_SOLD_NONENR[i])





# Constraints for free variables
for i in range(N):
    model.addCons(LIQUIDE[i] + SALAIRES_FUTURS_IMPOT[i] - IMPOT[i] - RQAP[i] - AE[i] - RRQ[i] -
                  FOND_RETRAITE[i] - DEPENSES[i] - COTIS_CELIAPP[i] - COTIS_CELI[i] - COTIS_REER[i] - COTIS_NONENR[i]
                  >= 0)
for i in range(N):
    model.addCons(COTIS_REER[i] <= DROITS_REER[i])
    model.addCons(COTIS_REER[i] <= SALAIRES_FUTURS_IMPOT[i])
for i in range(N+1):
    LIQUIDE[i] >= 0
for i in range(N):
    model.addCons(SELL_REER[i] <= CUMUL_VALUE_REER[i] * (1 + RENDEMENT))
### TODO
model.addCons(RAP <= CUMUL_VALUE_REER[N-1] * (1 + RENDEMENT) - SELL_REER[N-1])
###

# Bris de symmétrie
### TODO
# on met cette contrainte pour forcer ces cas-là à investir en non enregistré
#for i in range(N):
    #model.addCons(SELL_REER[i] = 0 \/ COTIS_REER[i] = 0)
# on priorise CELI au NONENR
#for i in range(N):
    #model.addCons(COTIS_NONENR[i] <= COTIS_CELI[i] \/ COTIS_CELI[i] = DROITS_CELI[i])
### TODO

# Objective
model.addCons(CASHDOWN == LIQUIDE[N] - 10000 + CUMUL_CELIAPP[N-1] + CUMUL_CELI[N-1] + RAP)
model.setObjective(CASHDOWN, sense="maximize")

# Optimization
model.optimize()

# Prints
print(f"Value of CASHDOWN: {model.getVal(CASHDOWN):.2f}")
print(f"Value of LIQUIDE: {[f'{model.getVal(LIQUIDE[i]):.2f}' for i in range(N+1)]}")
print(f"Value of SALAIRES_FUTURS_IMPOT: {[SALAIRES_FUTURS_IMPOT[i] for i in range(N)]}")
print(f"Value of SALAIRE_IMPOSABLE: {[f'{model.getVal(SALAIRE_IMPOSABLE[i]):.2f}' for i in range(N)]}")
print(f"Value of IMPOT: {[f'{model.getVal(IMPOT[i]):.2f}' for i in range(N)]}")
print(f"Value of RQAP: {[f'{model.getVal(RQAP[i]):.2f}' for i in range(N)]}")
print(f"Value of AE: {[f'{model.getVal(AE[i]):.2f}' for i in range(N)]}")
print(f"Value of RRQ: {[f'{model.getVal(RRQ[i]):.2f}' for i in range(N)]}")
print(f"Value of FOND_RETRAITE: {[f'{model.getVal(FOND_RETRAITE[i]):.2f}' for i in range(N)]}")
print(f"Value of NET: {[f'{SALAIRES_FUTURS_IMPOT[i] - model.getVal(IMPOT[i]) - model.getVal(RQAP[i]) - model.getVal(AE[i]) - model.getVal(RRQ[i]) - model.getVal(FOND_RETRAITE[i]):.2f}' for i in range(N)]}")
print(f"Value of COTIS_CELIAPP: {[f'{model.getVal(COTIS_CELIAPP[i]):.2f}' for i in range(N)]}")
print(f"Value of DROITS_CELIAPP: {[f'{model.getVal(DROITS_CELIAPP[i]):.2f}' for i in range(N)]}")
print(f"Value of COTIS_CELI: {[f'{model.getVal(COTIS_CELI[i]):.2f}' for i in range(N)]}")
print(f"Value of DROITS_CELI: {[f'{model.getVal(DROITS_CELI[i]):.2f}' for i in range(N)]}")
print(f"Value of DROITS_REER: {[f'{model.getVal(DROITS_REER[i]):.2f}' for i in range(N)]}")
print(f"Value of FACTEUR_EQUIVALENCE: {[f'{model.getVal(FACTEUR_EQUIVALENCE[i]):.2f}' for i in range(N)]}")
print(f"Value of CUMUL_CELIAPP: {[f'{model.getVal(CUMUL_CELIAPP[i]):.2f}' for i in range(N)]}")
print(f"Value of CUMUL_CELI: {[f'{model.getVal(CUMUL_CELI[i]):.2f}' for i in range(N)]}")
print(f"Value of COTIS_NONENR: {[f'{model.getVal(COTIS_NONENR[i]):.2f}' for i in range(N)]}")
print(f"Value of SELL_NONENR: {[f'{model.getVal(SELL_NONENR[i]):.2f}' for i in range(N)]}")
print(f"Value of COTIS_REER: {[f'{model.getVal(COTIS_REER[i]):.2f}' for i in range(N)]}")
print(f"Value of SELL_REER: {[f'{model.getVal(SELL_REER[i]):.2f}' for i in range(N)]}")
print(f"Value of SHARES_BOUGHT_REER: {[f'{model.getVal(SHARES_BOUGHT_REER[i]):.2f}' for i in range(N)]}")
print(f"Value of SHARES_SOLD_REER: {[f'{model.getVal(SHARES_SOLD_REER[i]):.2f}' for i in range(N)]}")
print(f"Value of CUMUL_SHARES_REER_START: {[f'{model.getVal(CUMUL_SHARES_REER_START[i]):.2f}' for i in range(N)]}")
print(f"Value of CUMUL_SHARES_REER_END: {[f'{model.getVal(CUMUL_SHARES_REER_END[i]):.2f}' for i in range(N)]}")
print(f"Value of CUMUL_VALUE_REER: {[f'{model.getVal(CUMUL_VALUE_REER[i]):.2f}' for i in range(N)]}")
print(f"Value of CUMUL_VALUE_NONENR: {[f'{model.getVal(CUMUL_VALUE_NONENR[i]):.2f}' for i in range(N)]}")
print(f"Value of SHARE_PRICE: {[f'{model.getVal(SHARE_PRICE[i]):.2f}' for i in range(N)]}")
print(f"Value of AVG_BOUGHT_SHAREPRICE_REER: {[f'{model.getVal(AVG_BOUGHT_SHAREPRICE_REER[i]):.2f}' for i in range(N)]}")
print(f"Value of GAIN_REALISED_REER: {[f'{model.getVal(GAIN_REALISED_REER[i]):.2f}' for i in range(N)]}")

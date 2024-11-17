# fiscal-optim
Fiscal optimizer for Quebecers for diverse financial plans, like buying a home or retiring. 

You need :
MiniZinc https://www.minizinc.org/
SCIP solver https://www.scipopt.org/download.php?fname=SCIPOptSuite-9.2.0-win64.exe or https://www.scipopt.org/index.php#download
both are available for free

You can customize various hypotheses in the DZN file and modify some constraints and the objective function in MZN file.

The Excel file serves as a solution validator. The workflow proposed is :
1. Copy fiscalite_private_template.dzn and rename it as fiscalite_private.dzn
2. Set your values in both DZN and objective variable in MZN ->
3. Optimize using SCIP in MiniZinc ->
4. Input the solution obtained into the Excel file ->
5. Verify whether the solution produces the same result as MiniZinc.
# fiscal-optim
Fiscal optimizer for Quebecers for diverse financial plans, like buying a home or retiring. 

You need :
Python
SCIP solver https://www.scipopt.org/download.php?fname=SCIPOptSuite-9.2.0-win64.exe or https://www.scipopt.org/index.php#download
both are available for free
and pyscipopt via pip install

You can customize various hypotheses in the .py file and modify some constraints and the objective function in main.py file.

The Excel file serves as a solution validator. The workflow proposed is :
1. Copy data_private_template.py and rename it as data_private.py
2. Set your values in both data_[...].py and objective variable in main.py ->
3. Optimize using SCIP in Python ->
4. Input the solution obtained into the Excel file ->
5. Verify whether the solution produces the same result as Python.
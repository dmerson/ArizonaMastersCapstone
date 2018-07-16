from  ScholarshipAwarding import     ScholarshipAwarding

import pyodbc
import pandas.io.sql
import pandas as pd
import numpy as np

scholarship_awarding=ScholarshipAwarding("POWER\\POWER17","SASClone","","")
print(scholarship_awarding.GetAlorithms())
print(scholarship_awarding.GetAnalysis(1,1500,130,2,1))
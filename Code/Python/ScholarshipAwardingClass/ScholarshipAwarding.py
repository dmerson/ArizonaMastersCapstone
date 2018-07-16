# Python 3
# Must have ROCBC, Pandas installed
import pyodbc
import pandas.io.sql
import pandas as pd
import numpy as np
class ScholarshipAwarding(object):
    '''
        ScholarshipAwarding object connets to a SQL Database to maniuplate data
    '''


    def __init__(self, server, database, username, password):

        self.server=server
        self.database=database
        self.username=username
        self.password=password


    def GetConnection(self):
        if (self.username !=""):
            self.sqlConnection=pyodbc.connect('DRIVER={SQL Server Native Client 11.0};SERVER=' + self.server + ';DATABASE=' + self.database + ';UID=' + self.username + ';PWD=' + self.password)
        else:
            self.sqlConnection=pyodbc.connect('DRIVER={SQL Server};server=' + self.server + ';database=' + self.database + ';trusted_connection=true')
        self.sqlConnection.autocommit=True
        return (self.sqlConnection)

    def GetAlorithms(self):
        sql = "Select * from Algorithms"
        algorithms = pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (algorithms)

    def GetAnalysis(self,awarding_group_id, maximum_award, minimum_award, max_applicants, run_analysis_first):
        sql = "GetAnalysis " + str(awarding_group_id) + ", " + str(maximum_award) + ", "
        sql = sql + str(minimum_award) + "," + str(max_applicants) + "," + str(run_analysis_first)
        analysis= pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (analysis)
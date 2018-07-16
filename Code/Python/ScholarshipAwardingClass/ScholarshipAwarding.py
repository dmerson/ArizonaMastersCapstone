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

    def InsertDenormalizedData(self,awarding_group_id, scholarshipName, scholarshipAmount, applicantName, applicantRank):
        sql = "InsertIntoDenormalizedEntry " + str(awarding_group_id) + ","
        sql = sql + "'" + str(scholarshipName) + "',"
        sql = sql + str(scholarshipAmount) + ","
        sql = sql + "'" + str(applicantName) + "',"
        sql = sql + str(applicantRank)
        # return sql
        results= pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (results)

    def CreateAnalysisFromSpreadsheet(self,awarding_group_name, filePath, maximum_award, minimum_award, max_applicants,
                                         run_analysis_first):
        new_awarding_group = pandas.io.sql.read_sql("CreateAwardingGroup 'FromPython'", self.GetConnection())
        new_awarding_group_id = new_awarding_group["AwardingGroupId"][0]
        from pandas import ExcelWriter
        from pandas import ExcelFile
        df = pd.read_excel(filePath, sheetname='Sheet1')
        for i in df.index:
            scholarship = df["Scholarship"][i]
            scholarship_award = df["ScholarshipAward"][i]
            applicant = df["Applicant"][i]
            applicant_ranking = df["ApplicantRanking"][i]
            self.InsertDenormalizedData(new_awarding_group_id, scholarship, scholarship_award, applicant, applicant_ranking)
        analysis =self.GetAnalysis(new_awarding_group_id, maximum_award, minimum_award, max_applicants, run_analysis_first)
        self.GetConnection().close()
        return (analysis)

    def GetScholarshipAwards(self,algorithm_id, awading_group_id, maximum_award, minimum_award, max_applicants):
        sql = "GetScholarshipAwards " + str(algorithm_id) + ","
        sql = sql + str(awading_group_id) + ","
        sql = sql + str(maximum_award) + ","
        sql = sql + str(minimum_award) + ","
        sql = sql + str(max_applicants)
        # return sql
        results= pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (results)

    def GetDeonormalizedScholarshipAwards(self,algorithm_id, awading_group_id, maximum_award, minimum_award, max_applicants):
        sql = "GetDeonormalizedScholarshipAwards " + str(algorithm_id) + ","
        sql = sql + str(awading_group_id) + ","
        sql = sql + str(maximum_award) + ","
        sql = sql + str(minimum_award) + ","
        sql = sql + str(max_applicants)
        # return sql
        results = pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (results)
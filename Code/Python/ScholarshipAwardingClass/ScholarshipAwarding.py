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
        """
        Basic function to verify your database connection. It just pulls the algorithm table.
        :return:
        """
        sql = "Select * from Algorithms"
        algorithms = pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (algorithms)

    def GetAnalysis(self,awarding_group_id, maximum_award, minimum_award, max_applicants, run_analysis_first):
        """
        This function is called when you want to review your analysis or rerun the analysis
        :param awarding_group_id: you must already have this number
        :param maximum_award:
        :param minimum_award:
        :param max_applicants:
        :param run_analysis_first:  1 for yes 0 for don't run analysis again
        :return:
        """
        sql = "GetAnalysis " + str(awarding_group_id) + ", " + str(maximum_award) + ", "
        sql = sql + str(minimum_award) + "," + str(max_applicants) + "," + str(run_analysis_first)
        analysis= pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (analysis)

    def InsertDenormalizedData(self,awarding_group_id, scholarshipName, scholarshipAmount, applicantName, applicantRank):
        """
        This is the stored proc that pulls does the bit by job of inserting items from a spreadsheet.
        It is used with CreateAnalysisFromSpreadsheet
        :param awarding_group_id: you must already have this number
        :param scholarshipName:
        :param scholarshipAmount:
        :param applicantName:
        :param applicantRank:
        :return:
        """
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
        """
        This is a one shop stop to go from a spreadsheet to an analysis.
        Format for spreadsheet is Scholarship, ScholarshipAward, Applicant,ApplicantRanking
        It also requires the data to be in the first and only sheet

        :param awarding_group_name: user can pick any name
        :param filePath: path to data file
        :param maximum_award:
        :param minimum_award:
        :param max_applicants:
        :param run_analysis_first:
        :return:
        """
        new_awarding_group = pandas.io.sql.read_sql("CreateAwardingGroup 'FromPython'", self.GetConnection())
        new_awarding_group_id = new_awarding_group["AwardingGroupId"][0]
        from pandas import ExcelWriter
        from pandas import ExcelFile
        df = pd.read_excel(filePath )
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
        """
        After analysis the user can view the awards for the best algorithm
        This works with the normalized version only
        :param algorithm_id:
        :param awading_group_id:
        :param maximum_award:
        :param minimum_award:
        :param max_applicants:
        :return:
        """
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
        """
        After analysis, the user can views the award for best algoritm
        this works on with the denormalized version only

        :param algorithm_id:
        :param awading_group_id:
        :param maximum_award:
        :param minimum_award:
        :param max_applicants:
        :return:
        """
        sql = "GetDeonormalizedScholarshipAwards " + str(algorithm_id) + ","
        sql = sql + str(awading_group_id) + ","
        sql = sql + str(maximum_award) + ","
        sql = sql + str(minimum_award) + ","
        sql = sql + str(max_applicants)
        # return sql
        results = pandas.io.sql.read_sql(sql, self.GetConnection())
        self.GetConnection().close()
        return (results)
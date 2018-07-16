library(knitr)	
library(tidyverse)	
library(readxl)	
library(readr)	
library(tidyr)	
library(RODBC)
install.packages("sqldf")
install.packages("DBI")
remove.packages("DBI")
install.packages("RSQLite")
library(RSQLite)
library(sqldf)	
library(readxl)

getSqlQueryFromSUDB <-function(sqlQuery){
  library(RODBC)
  server="TARDIS\\TARDIS" #POWER\\POWER17
  database="ScholarshipAwardingProcess" #"ScholarshipAwardingSystems"}
  conn=paste("driver={SQL Server};server=",server,";database=",database,";trusted_connection=true", sep="")
  print(conn)
  cn <- odbcDriverConnect(connection=conn)
  resultSet <- sqlQuery(cn,sqlQuery)
  odbcClose(cn)
  return (resultSet)
}
#pull the algorithms
getSqlQueryFromSUDB("Select * from algorithms")

#run all algorithms
#getSqlQueryFromSUDB("RunAllAlgorithms  1,   1000,   310,  2")
# getSqlQueryFromSUDB("RunAlgorithm1  1,   1600,   300,  2")
# getSqlQueryFromSUDB("RunAlgorithm2  1, 1600, 300, 2")
# getSqlQueryFromSUDB("RunAlgorithm3   1, 1000, 310, 2")
# getSqlQueryFromSUDB("RunAlgorithm4   1, 1600, 300, 2")
# getSqlQueryFromSUDB("RunAlgorithm5   1, 1600, 300, 2")
# getSqlQueryFromSUDB("RunAlgorithm6   1, 1600, 300, 2")
# getSqlQueryFromSUDB("RunAlgorithm7   1, 1600, 300, 2")

#get Analysis
View(getSqlQueryFromSUDB("GetAnalysis   1, 1500, 130, 2, 1"))
View(getSqlQueryFromSUDB("GetAnalysis   2, 1500, 130, 2, 1"))

#get Analysis function
getAnalysis <- function (awarding_group_id,maximum_award,minimum_award,max_applicants,run_analysis_first){
  sql=paste("GetAnalysis ",awarding_group_id,",", maximum_award,", ",minimum_award,", ",max_applicants,",", run_analysis_first,sep="")
  #print(sql)
  getSqlQueryFromSUDB(sql)
}
getAnalysis(1,1500,130,2,0)

#create awarding group
awardinggroupid=getSqlQueryFromSUDB("CreateAwardingGroup 'createdfromr'")[1,1]

#function for creating awarding group
create_awarding_group_and_get_id <- function(award_group_name){
  awarding_group_id=getSqlQueryFromSUDB(paste("CreateAwardingGroup '",award_group_name,"'",sep=""))[1,1]
  return (awarding_group_id)
}
create_awarding_group_and_get_id("test2")


#insert into denormalized group
result <- getSqlQueryFromSUDB("[InsertIntoDenormalizedEntry] 5,'S1',1000.00,'A1',1")


#create function to insert data
InsertDenormalizedData <- function(awardinggroupid,scholarshipName,scholarshipAmount,applicantName, applicantRank){
  sql=paste("[InsertIntoDenormalizedEntry] ",awardinggroupid,",'",scholarshipName,"',", scholarshipAmount,",'",applicantName,"',",applicantRank,sep="")
  #print(sql)
  getSqlQueryFromSUDB(sql)
}
InsertDenormalizedData(3,'S1',1000.00,'A2',2)

#insert into database from excel file
library(readxl)
DemoData <- tbl_df(read_excel("C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/DemoData.xlsx"))
#View(DemoData)
count_Of_data =nrow(DemoData)
awarding_group_id=4
for (i in 1:count_Of_data){
  scholarship_name =DemoData[i,1]
  scholarship_amount =DemoData[i,2]
  applicant_name=DemoData[i,3]
  applicant_rank =DemoData[i,4]
  InsertDenormalizedData(awarding_group_id,scholarship_name,scholarship_amount,applicant_name,applicant_rank)
  
  
  
}

#function to pull from excel file, get awarding group, insert into database, and get analysis
create_analysis_from_spreadsheet <- function (awarding_group_name,filePath,maximum_award,minimum_award,max_applicants,run_analysis_first){
  awarding_group_id <-create_awarding_group_and_get_id(awarding_group_name)
  library(readxl)
  DemoData <- tbl_df(read_excel(filePath))
  for (i in 1:count_Of_data){
    scholarship_name =DemoData[i,1]
    scholarship_amount =DemoData[i,2]
    applicant_name=DemoData[i,3]
    applicant_rank =DemoData[i,4]
    InsertDenormalizedData(awarding_group_id,scholarship_name,scholarship_amount,applicant_name,applicant_rank)
  }
  getAnalysis(awarding_group_id,maximum_award,minimum_award,max_applicants,run_analysis_first)
  
}
create_analysis_from_spreadsheet("test case","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/DemoData.xlsx",1500,130,2,1)

create_analysis_from_spreadsheet("test case2","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/DemoData2.xlsx",1500,130,2,1)


get_analysis <-function(algorithm_id, awarding_group_id,maximum_award,minimum_award,max_applicants){
  
  
}
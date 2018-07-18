library(knitr)	
library(tidyverse)	
library(readxl)	
library(readr)	
library(tidyr)	
library(RODBC)
library(RSQLite)
library(sqldf)	
library(readxl)

getSqlQueryFromSUDB <-function(sqlQuery){
  library(RODBC)
  server="POWER\\POWER17" #TARDIS\\TARDIS" #POWER\\POWER17
  database="SASCLONE"#ScholarshipAwardingProcess" #"ScholarshipAwardingSystems"}
  conn=paste("driver={SQL Server};server=",server,";database=",database,";trusted_connection=true", sep="")
  #print(conn)
  cn <- odbcDriverConnect(connection=conn)
  resultSet <- sqlQuery(cn,sqlQuery)
  odbcClose(cn)
  return (resultSet)
}




#pull the algorithms
getSqlQueryFromSUDB("Select * from algorithms")


create_awarding_group_and_get_id <- function(award_group_name){
  awarding_group_id=getSqlQueryFromSUDB(paste("CreateAwardingGroup '",award_group_name,"'",sep=""))[1,1]
  return (awarding_group_id)
}

InsertDenormalizedData <- function(awardinggroupid,scholarshipName,scholarshipAmount,applicantName, applicantRank){
  sql=paste("[InsertIntoDenormalizedEntry] ",awardinggroupid,",'",scholarshipName,"',", scholarshipAmount,",'",applicantName,"',",applicantRank,sep="")
  #print(sql)
  getSqlQueryFromSUDB(sql)
}

getAnalysis <- function (awarding_group_id,maximum_award,minimum_award,max_applicants,run_analysis_first){
  sql=paste("GetAnalysis ",awarding_group_id,",", maximum_award,", ",minimum_award,", ",max_applicants,",", run_analysis_first,sep="")
  #print(sql)
  getSqlQueryFromSUDB(sql)
}

create_analysis_from_spreadsheet <- function (awarding_group_name,filePath,maximum_award,minimum_award,max_applicants,run_analysis_first){
  awarding_group_id_for_new <-create_awarding_group_and_get_id(awarding_group_name)
  #print(awarding_group_id_for_new)
  library(readxl)
  DemoData <- tbl_df(read_excel(filePath))
  #View(DemoData)
  count_Of_data=nrow(DemoData)
  for (i in 1:count_Of_data){
    scholarship_name =DemoData[i,1]
    scholarship_amount =DemoData[i,2]
    applicant_name=DemoData[i,3]
    applicant_rank =DemoData[i,4]
    InsertDenormalizedData(awarding_group_id_for_new,scholarship_name,scholarship_amount,applicant_name,applicant_rank)
     
  }
  getAnalysis(awarding_group_id_for_new,maximum_award,minimum_award,max_applicants,run_analysis_first)
  
}
# create_analysis_from_spreadsheet("aw1","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup1.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw3","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup3.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw4","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup4.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw6","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup6.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw7","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup7.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw9","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup9.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw10","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup10.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw11","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup11.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw12","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup12.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw13","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup13.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw14","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup14.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw15","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup15.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw16","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup16.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw18","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup18.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw19","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup19.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw20","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup20.xlsx", 12400,250,2,1)
# create_analysis_from_spreadsheet("aw21","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup21.xlsx", 12400,250,2,1)
















#create_analysis_from_spreadsheet("exc","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup20.xlsx", 12400,250,2,1)

#create_analysis_from_spreadsheet("ag21","C:/Repos/Documents/scholarshipawardingprocess/Code/R/RWithSQLServer/Example Data/ImportedData/AwardingGroup21.xlsx", 12400,250,2,1)


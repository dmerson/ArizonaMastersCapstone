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
  server="TARDIS\\TARDIS" #TARDIS\\TARDIS" #POWER\\POWER17
  database="SAPClone4"#ScholarshipAwardingProcess" #"ScholarshipAwardingSystems"}
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
  getSqlQueryFromSUDB(paste("FixApplicantRanking ", awarding_group_id_for_new, sep=""))
  getAnalysis(awarding_group_id_for_new,maximum_award,minimum_award,max_applicants,run_analysis_first)
  
}
create_analysis_from_spreadsheet("aw1","Example Data/ImportedData/AwardingGroup1.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw3","Example Data/ImportedData/AwardingGroup3.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw4","Example Data/ImportedData/AwardingGroup4.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw6","Example Data/ImportedData/AwardingGroup6.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw7","Example Data/ImportedData/AwardingGroup7.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw9","Example Data/ImportedData/AwardingGroup9.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw10","Example Data/ImportedData/AwardingGroup10.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw11","Example Data/ImportedData/AwardingGroup11.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw12","Example Data/ImportedData/AwardingGroup12.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw13","Example Data/ImportedData/AwardingGroup13.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw14","Example Data/ImportedData/AwardingGroup14.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw15","Example Data/ImportedData/AwardingGroup15.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw16","Example Data/ImportedData/AwardingGroup16.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw18","Example Data/ImportedData/AwardingGroup18.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw19","Example Data/ImportedData/AwardingGroup19.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw20","Example Data/ImportedData/AwardingGroup20.xlsx", 12400,250,2,1)
create_analysis_from_spreadsheet("aw21","Example Data/ImportedData/AwardingGroup21.xlsx", 12400,250,2,1)




create_analysis_from_spreadsheet("aw1","Example Data/ImportedData/AwardingGroup1.xlsx", 12400,250,10,1)
create_analysis_from_spreadsheet("aw1","Example Data/ImportedData/AwardingGroup1.xlsx", 12400,250,5,1)









 

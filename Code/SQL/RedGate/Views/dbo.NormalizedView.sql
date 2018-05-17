SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[NormalizedView]
as
SELECT AwardingGroups.AwardingGroupId,
       AwardingGroupName,
       ScholarshipApplicantId,
  
       
       Scholarships.ScholarshipId,
       ScholarshipName,
       ScholarshipAmount,
       Applicants.ApplicantId,
	   Ranking,
       FirstName,
       LastName FROM dbo.AwardingGroups
INNER JOIN dbo.ScholarshipApplicants ON ScholarshipApplicants.AwardingGroupId = AwardingGroups.AwardingGroupId
INNER JOIN dbo.Scholarships ON Scholarships.ScholarshipId = ScholarshipApplicants.ScholarshipId
INNER JOIN dbo.Applicants ON Applicants.ApplicantId = ScholarshipApplicants.ApplicantId
INNER JOIN dbo.ApplicantRankings ON ApplicantRankings.ApplicantId = Applicants.ApplicantId
 
GO

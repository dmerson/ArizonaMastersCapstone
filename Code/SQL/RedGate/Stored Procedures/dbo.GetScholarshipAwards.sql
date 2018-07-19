SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetScholarshipAwards]
    @AlgorithmId INT,
    @AwardingGroupId INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT ON;
	
SELECT ScholarshipAwardId,
       AwardingGroupId,
	   ScholarshipName,
	   dbo.Applicants.FirstName,
	   LastName,
      AlgorithmId,
       Award
FROM dbo.ScholarshipAwards
INNER JOIN dbo.Applicants ON Applicants.ApplicantId = ScholarshipAwards.ApplicantId
INNER JOIN dbo.Scholarships ON Scholarships.ScholarshipId = ScholarshipAwards.ScholarshipId
WHERE AlgorithmId = @AlgorithmId
      AND AwardingGroupId = @AwardingGroupId
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
	  ORDER BY ScholarshipAwardId
	  
	  ;
GO

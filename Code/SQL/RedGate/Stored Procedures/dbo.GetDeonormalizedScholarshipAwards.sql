SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetDeonormalizedScholarshipAwards]
    @AlgorithmId INT,
    @AwardingGroupId INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT ON;
	
SELECT * FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @AlgorithmId
      AND AwardingGroupId = @AwardingGroupId
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
	  ORDER BY DenormalizedEntryResultId
	  
	  ;
GO

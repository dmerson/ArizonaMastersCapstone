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
	DECLARE @whichTable CHAR(1);
SET @whichTable =
(
    SELECT TOP 1
           *
    FROM
    (
        SELECT TOP 1
               '1' IsNormalized
        FROM dbo.NormalizedView
        WHERE AwardingGroupId = @AwardingGroupId
        UNION
        SELECT TOP 1
               '0' IsNormalized
        FROM dbo.DenormalizedEntries
        WHERE AwardingGroupId = @AwardingGroupId
        UNION
        SELECT -1 IsNormalized
    ) whichTable
    ORDER BY 1 DESC
);
IF @whichTable = 1
BEGIN
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
	  END
      
	  IF @whichTable =0
	  BEGIN
		EXEC dbo.GetDeonormalizedScholarshipAwards @AlgorithmId  ,     -- int
		                                           @AwardingGroupId , -- int
		                                           @MaximumAward  , -- decimal(9, 2)
		                                           @MinimumAward  , -- decimal(9, 2)
		                                           @MaxApplicants      -- int
		
	  end
GO

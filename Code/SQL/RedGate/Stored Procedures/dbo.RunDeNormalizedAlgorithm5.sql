SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm5]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 5;
 --for testing
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1000;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

 

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
 
DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);

DECLARE @CurrentScholarshipApplicants VARCHAR(100)
DECLARE @CurrentSplitAmount DECIMAL(9,2)

WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );
     SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAward
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter AND AwardingGroupId=@awardgroup
    );
	 
    SET @CurrentScholarshipApplicants =
    (
        SELECT COUNT(Applicant	)
        FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND AwardingGroupId = @awardgroup
    );
	 
    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @CurrentScholarshipApplicants);

      INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    )
    SELECT  @awardgroup,
           @algorithmid,
           @MaximumAward,
           @MinimumAward,
           @MaxApplicants,
           Scholarship,
           Applicant,
           @CurrentSplitAmount
    FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND AwardingGroupId = @awardgroup
    ORDER BY ApplicantRanking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable


--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY Applicant
--ORDER BY Total desc;
 
EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO

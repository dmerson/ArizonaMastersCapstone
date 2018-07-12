SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[RunAlgorithm3]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
DECLARE @algorithmid INT = 3;
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT * FROM dbo.NormalizedView
--WHERE AwardingGroupId =@awardgroup

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;


 
DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
	  AND AwardingGroupId =@awardgroup;



CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;


WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter AND AwardingGroupId=@awardgroup
    );
    WITH currenttotals
    AS (SELECT ApplicantId,
               SUM(Award)  Total
        FROM dbo.ScholarshipAwards
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
			  AND AwardingGroupId=@awardgroup
        GROUP BY ApplicantId
        HAVING SUM(Award) +  @CurrentAmount  > @MaximumAward)
    SELECT TOP 1
           @CurrentScholarshipId = ScholarshipId,
           @CurrentWinner = ApplicantId,
            
           @CurrentScholarshipApplicantId = ScholarshipApplicantId,
           @CurrentAmount = ScholarshipAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @CurrentCounter
          AND ApplicantId NOT IN
              (
                  SELECT ApplicantId FROM currenttotals
              )
			  AND AwardingGroupId=@awardgroup
    ORDER BY Ranking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    VALUES
    (   @awardgroup, @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner, @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

DROP TABLE #scholarshipordertable
--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY ApplicantId
--ORDER BY Total desc;
EXEC dbo.RunAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int

	--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[RunAlgorithm6]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 6;
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

 

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
DECLARE @CurrentScholarshipApplicants INT;
DECLARE @CurrentSplitAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;

DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;


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
        SELECT TOP 1
               ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );

    SET @CurrentScholarshipApplicants =
    (
        SELECT CASE
                   WHEN CountTotalTable.TotalApplicants > @MaxApplicants THEN
                       @MaxApplicants
                   ELSE
                       CountTotalTable.TotalApplicants
               END
        FROM
        (
            SELECT COUNT(ApplicantId) TotalApplicants
            FROM dbo.NormalizedView
            WHERE ScholarshipId = @CurrentCounter
                  AND AwardingGroupId = @awardgroup
        ) CountTotalTable
    );


    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @CurrentScholarshipApplicants);

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
    SELECT OrderGroup.AwardGroup,
           OrderGroup.AlgorithmId,
           OrderGroup.MaximumAward,
           OrderGroup.MinimumAward,
           OrderGroup.MaxApplicants,
           OrderGroup.ScholarshipId,
           OrderGroup.ApplicantId,
           OrderGroup.CurrentAmount
    FROM
    (
        SELECT @awardgroup AwardGroup,
               @algorithmid AlgorithmId,
               @MaximumAward MaximumAward,
               @MinimumAward MinimumAward,
               @MaxApplicants MaxApplicants,
               ScholarshipId,
               ApplicantId,
               @CurrentSplitAmount CurrentAmount,
               ROW_NUMBER() OVER (ORDER BY Ranking) OrderId
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    ) OrderGroup
    WHERE OrderGroup.OrderId <= @MaxApplicants
    ORDER BY OrderGroup.OrderId ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

DROP TABLE #scholarshipordertable
--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY ApplicantId
--ORDER BY Total desc;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int

--DELETE FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;


	--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO

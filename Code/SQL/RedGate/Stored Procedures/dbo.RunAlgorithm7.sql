SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[RunAlgorithm7]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 7;
-- left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 50;
--DECLARE @MaxApplicants INT = 2;

 
 

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicants INT;
DECLARE @CurrentSplitAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;
DECLARE @applicantswithMinimumAmounts INT;
DECLARE @CurrentNumberOfWinners INT;
DECLARE @peopletodivdeby INT;

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

    --amount in pool
    SET @CurrentAmount =
    (
        SELECT TOP 1
               ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );


    ---max number of people who can win
    SET @applicantswithMinimumAmounts =
    (
        SELECT CONVERT(INT, @CurrentAmount / @MinimumAward)
    );
	IF @applicantswithMinimumAmounts=0
	BEGIN
		SET @applicantswithMinimumAmounts=1
	end
    --total number of people in pool
    SET @CurrentScholarshipApplicants =
    (
        SELECT COUNT(ApplicantId) TotalApplicants
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );

    ---set which ever is lower max number or total real number in pool
    SET @peopletodivdeby =
    (
        SELECT CASE
                   WHEN @CurrentScholarshipApplicants < @applicantswithMinimumAmounts THEN
                       @CurrentScholarshipApplicants
                   ELSE
                       @applicantswithMinimumAmounts
               END
    );

    -- divide people by current amount
    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @peopletodivdeby);


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
    WHERE OrderGroup.OrderId <= @peopletodivdeby
    ORDER BY OrderGroup.OrderId ASC;
   





    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshipordertable
--left for future troubleshooting possibilites
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
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup
--GROUP BY ApplicantId
--ORDER BY Total DESC;
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

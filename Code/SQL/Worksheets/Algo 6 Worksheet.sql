DECLARE @algorithmid INT = 6;
DECLARE @awardgroup INT = 1;
DECLARE @MaximumAward DECIMAL = 1500;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

SELECT *
FROM dbo.Algorithms
WHERE AlgorithmId = @algorithmid;
--SELECT * FROM dbo.NormalizedView
--WHERE AwardingGroupId =@awardgroup

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

DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN;
    SET @CurrentAmount =
    (
        SELECT TOP 1
               ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @ScholarshipCounter
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
            WHERE ScholarshipId = @ScholarshipCounter
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
        WHERE ScholarshipId = @ScholarshipCounter
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

SELECT *
FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;

SELECT ApplicantId,
       SUM(Award) Total
FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
GROUP BY ApplicantId
ORDER BY Total desc;


DELETE FROM dbo.ScholarshipAwardAnalysises
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;

;WITH calculations
AS (SELECT ApplicantRankings.AwardingGroupId,
           Ranking,
           SUM(Award) Total,
           ISNULL(LEAD(Ranking) OVER (ORDER BY Ranking), Ranking + 1) NextRanking,
           ISNULL(LEAD(SUM(Award)) OVER (ORDER BY Ranking), 0) NextAmount
    FROM dbo.ScholarshipAwards
        INNER JOIN dbo.ApplicantRankings
            ON ApplicantRankings.ApplicantId = ScholarshipAwards.ApplicantId
               AND ApplicantRankings.AwardingGroupId = ScholarshipAwards.AwardingGroupId
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND ApplicantRankings.AwardingGroupId = @awardgroup
    GROUP BY ApplicantRankings.AwardingGroupId,
             Ranking),
      ra1checkraw
AS (SELECT calculations.AwardingGroupId,
           calculations.Ranking,
           calculations.Total,
           calculations.NextRanking,
           calculations.NextAmount,
           CASE
               WHEN calculations.Ranking + 1 = calculations.NextRanking THEN
                   1
               ELSE
                   0
           END OrderPreserved,
           CASE
               WHEN Total > calculations.NextAmount THEN
                   1
               ELSE
                   0
           END AmountPreserved
    FROM calculations),
      ra1
AS (SELECT ra1checkraw.AwardingGroupId,
           MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) CHECKer,
           CASE
               WHEN MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) = 2 THEN
                   1
               ELSE
                   0
           END r1Check
    FROM ra1checkraw
    GROUP BY ra1checkraw.AwardingGroupId),
      countranks
AS (SELECT calculations.AwardingGroupId,
           COUNT(Ranking) cnt,
           MAX(Ranking) maxrank
    FROM calculations
    GROUP BY calculations.AwardingGroupId),
      ra2table
AS (SELECT countranks.AwardingGroupId,
           CASE
               WHEN countranks.cnt = maxrank THEN
                   1
               ELSE
                   0
           END ra2check
    FROM countranks)
INSERT INTO dbo.ScholarshipAwardAnalysises
(
    AwardingGroupId,
    AlgorithmId,
    MaximumAward,
    MinimumAward,
    MaxApplicants,
    RA1,
    RA2
)
SELECT TOP 1
       countranks.AwardingGroupId,
       @algorithmid AlgorithmId,
       @MaximumAward MaximumAward,
       @MinimumAward MinimumAward,
       @MaxApplicants MaxApplicants,
       ra1.r1Check,
       ra2table.ra2check
FROM ra1checkraw
    INNER JOIN ra1
        ON ra1.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN countranks
        ON countranks.AwardingGroupId = ra1.AwardingGroupId
    INNER JOIN ra2table
        ON ra2table.AwardingGroupId = ra1checkraw.AwardingGroupId;



SELECT *
FROM dbo.ScholarshipAwardAnalysises
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;
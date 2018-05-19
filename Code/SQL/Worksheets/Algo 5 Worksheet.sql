DECLARE @algorithmid INT = 5;
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
        SELECT COUNT(ApplicantId)
        FROM dbo.NormalizedView
    WHERE ScholarshipId = @ScholarshipCounter
          AND AwardingGroupId = @awardgroup
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
    SELECT  @awardgroup,
           @algorithmid,
           @MaximumAward,
           @MinimumAward,
           @MaxApplicants,
           ScholarshipId,
           ApplicantId,
           @CurrentSplitAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @ScholarshipCounter
          AND AwardingGroupId = @awardgroup
    ORDER BY Ranking ASC;
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
           END AmountPreserved,
           CASE
               WHEN Total >= calculations.NextAmount THEN
                   1
               ELSE
                   0
           END AmountEqualed
    FROM calculations),
      ra1
AS (SELECT ra1checkraw.AwardingGroupId,
           MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) CHECKer,
           CASE
               WHEN MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) = 2 THEN
                   1
               ELSE
                   0
           END r1Check,
           CASE
               WHEN MIN(ra1checkraw.AmountEqualed) + MIN(ra1checkraw.AmountEqualed) = 2 THEN
                   1
               ELSE
                   0
           END r2heck
    FROM ra1checkraw
    GROUP BY ra1checkraw.AwardingGroupId),
      countranks
AS (SELECT calculations.AwardingGroupId,
           COUNT(Ranking) cnt,
           MAX(Ranking) maxrank
    FROM calculations
    GROUP BY calculations.AwardingGroupId),
      ra3table
AS (SELECT countranks.AwardingGroupId,
           CASE
               WHEN countranks.cnt = maxrank THEN
                   1
               ELSE
                   0
           END ra3check
    FROM countranks),
      otherstats
AS (SELECT AwardingGroupId,
           COUNT(Award) NumberOfAwarded,
           COUNT(DISTINCT ApplicantId) UniqueAwardees,
           MAX(Award) MaximumAwarded,
           MIN(Award) MinimumAwarded
    FROM dbo.ScholarshipAwards
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND AwardingGroupId = @awardgroup
    GROUP BY AwardingGroupId)
INSERT INTO dbo.ScholarshipAwardAnalysises
(
    AwardingGroupId,
    AlgorithmId,
    MaximumAward,
    MinimumAward,
    MaxApplicants,
    RA1,
    RA2,
	RA3,
    NumberOfAwarded,
    UniqueAwardees,
    MaximumAwarded,
    MinimumAwarded
)
SELECT TOP 1
       countranks.AwardingGroupId,
       @algorithmid AlgorithmId,
       @MaximumAward MaximumAward,
       @MinimumAward MinimumAward,
       @MaxApplicants MaxApplicants,
       ra1.r1Check,
       ra1.r2heck,
       ra3table.ra3check,
       NumberOfAwarded,
       otherstats.UniqueAwardees,
       otherstats.MaximumAwarded,
       otherstats.MinimumAwarded
FROM ra1checkraw
    INNER JOIN ra1
        ON ra1.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN countranks
        ON countranks.AwardingGroupId = ra1.AwardingGroupId
    INNER JOIN ra3table
        ON ra3table.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN otherstats
        ON otherstats.AwardingGroupId = countranks.AwardingGroupId;



SELECT *
FROM dbo.ScholarshipAwardAnalysises
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;
DECLARE @algorithmid INT = 2;
DECLARE @awardgroup INT = 2;
DECLARE @MaximumAward DECIMAL = 1500;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

SELECT *
FROM dbo.Algorithms
WHERE AlgorithmId = @algorithmid;

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT Applicant)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.ScholarshipAwards
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
    FROM dbo.DenormalizedEntries
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);


WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );

	;WITH currenttotals
    AS (SELECT Applicant,
               SUM(AwardAmount) Total
        FROM dbo.DenormalizedEntyResults
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
              AND AwardingGroupId = @awardgroup
        GROUP BY Applicant
        HAVING SUM(AwardAmount) > @MaximumAward)
	SELECT TOP 1
           @CurrentScholarshipId = Scholarship,
           @CurrentWinner = Applicant,
           @CurrentAmount = ScholarshipAward
           
            
    FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND Applicant NOT IN
              (
                  SELECT currenttotals.Applicant FROM currenttotals
              )
          AND AwardingGroupId = @awardgroup
    
    ORDER BY ApplicantRanking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



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
DROP TABLE #scholarshiplooptable;


SELECT *
FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;

SELECT Applicant,
       SUM(AwardAmount) Total
FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup
GROUP BY Applicant
ORDER BY Total DESC;


DELETE FROM dbo.DenormalizedEntryAnalysises
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;

;WITH calculations
AS (SELECT DenormalizedEntyResults.AwardingGroupId,
           ApplicantRanking Ranking,
           SUM(AwardAmount) Total,
           ISNULL(LEAD(ApplicantRanking) OVER (ORDER BY ApplicantRanking), ApplicantRanking + 1) NextRanking,
           ISNULL(LEAD(SUM(AwardAmount)) OVER (ORDER BY ApplicantRanking), 0) NextAmount
    FROM dbo.DenormalizedEntyResults
	INNER JOIN dbo.DenormalizedEntries ON DenormalizedEntries.AwardingGroupId = DenormalizedEntyResults.AwardingGroupId
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND DenormalizedEntyResults.AwardingGroupId = @awardgroup
    GROUP BY DenormalizedEntyResults.AwardingGroupId,
             ApplicantRanking),
      maxmin
AS (SELECT AwardingGroupId,
           MAX(Total) MaximumAmount,
           MIN(Total) MinimumAmount
    FROM calculations
    GROUP BY calculations.AwardingGroupId),
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
AS (SELECT DenormalizedEntyResults.AwardingGroupId,
           COUNT(AwardAmount) NumberOfAwarded,
           COUNT(DISTINCT ApplicantRanking) UniqueAwardees,
           MAX(AwardAmount) MaximumAwarded,
           MIN(AwardAmount) MinimumAwarded
    FROM dbo.DenormalizedEntyResults
	INNER JOIN dbo.DenormalizedEntries ON DenormalizedEntries.AwardingGroupId = DenormalizedEntyResults.AwardingGroupId
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND DenormalizedEntyResults.AwardingGroupId = @awardgroup
    GROUP BY DenormalizedEntyResults.AwardingGroupId)

INSERT INTO dbo.DenormalizedEntryAnalysises
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
    MiniumumAwarded
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
       maxmin.MaximumAmount,
       maxmin.MinimumAmount
FROM ra1checkraw
    INNER JOIN ra1
        ON ra1.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN countranks
        ON countranks.AwardingGroupId = ra1.AwardingGroupId
    INNER JOIN ra3table
        ON ra3table.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN otherstats
        ON otherstats.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN maxmin
        ON maxmin.AwardingGroupId = ra1checkraw.AwardingGroupId;


SELECT *
FROM dbo.DenormalizedEntryAnalysises
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;
 
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[CreateDenormalizedEntryAnalysis]
    @algorithmid INT,
    @MaxApplicants INT,
    @MinimumAward DECIMAL(9, 2),
    @MaximumAward DECIMAL(9, 2),
    @awardgroup INT
AS
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
        INNER JOIN dbo.DenormalizedEntries
            ON DenormalizedEntries.AwardingGroupId = DenormalizedEntyResults.AwardingGroupId
               AND DenormalizedEntries.Applicant = DenormalizedEntyResults.Applicant
               AND DenormalizedEntries.Scholarship = DenormalizedEntyResults.Scholarship
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
        INNER JOIN dbo.DenormalizedEntries
            ON DenormalizedEntries.AwardingGroupId = DenormalizedEntyResults.AwardingGroupId
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


--SELECT *
--FROM dbo.DenormalizedEntryAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO

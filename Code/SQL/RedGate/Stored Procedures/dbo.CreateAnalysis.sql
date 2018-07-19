SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROC [dbo].[CreateAnalysis]
	@algorithmid INT, 
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS


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


		--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO

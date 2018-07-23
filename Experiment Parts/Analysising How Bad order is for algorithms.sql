DECLARE @MaximumAward DECIMAL(9, 2) = 10000;
DECLARE @MinimumAward DECIMAL(9, 2) = 500;
DECLARE @MaxApplicants INT = 2;
DECLARE @algorithmid INT = 7;
DECLARE @awardinggroup INT =19
;WITH analysisoforder
AS (SELECT DenormalizedEntries.Applicant,
           ApplicantRanking,
           SUM(AwardAmount) TotalAwarded,
           ROW_NUMBER() OVER (ORDER BY SUM(AwardAmount) DESC) ActualAmount
    FROM dbo.DenormalizedEntyResults
        INNER JOIN dbo.DenormalizedEntries
            ON DenormalizedEntries.Applicant = DenormalizedEntyResults.Applicant
               AND DenormalizedEntries.AwardingGroupId = DenormalizedEntyResults.AwardingGroupId
               AND DenormalizedEntries.Scholarship = DenormalizedEntyResults.Scholarship
    WHERE MaximumAward = @MaximumAward
          AND MinimumAward = @MinimumAward
          AND MaxApplicants = @MaxApplicants
          AND AlgorithmId = @algorithmid
          AND DenormalizedEntries.AwardingGroupId = @awardinggroup
    GROUP BY DenormalizedEntries.Applicant,
             ApplicantRanking),
     costsofrows
AS (SELECT analysisoforder.Applicant,
           analysisoforder.ApplicantRanking,
           analysisoforder.TotalAwarded,
           analysisoforder.ActualAmount,
           CASE
               WHEN analysisoforder.ApplicantRanking > analysisoforder.ActualAmount THEN
                   ApplicantRanking - analysisoforder.ActualAmount
               ELSE
                   analysisoforder.ActualAmount - analysisoforder.ApplicantRanking
           END Cost
    FROM analysisoforder)
SELECT  
        COUNT(cost) cnt,
       SUM(ApplicantRanking.Cost) totalcost
	   ,
	   CONVERT(DECIMAL,SUM(ApplicantRanking.Cost)) / CONVERT(DECIMAL,COUNT(cost)) avgCost
FROM costsofrows
--ORDER BY ActualAmount,
         ApplicantRanking;

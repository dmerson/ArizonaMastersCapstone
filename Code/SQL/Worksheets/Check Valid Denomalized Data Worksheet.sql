--denormalized worksheet
DECLARE @IsInValidFormat BIT;
CREATE TABLE #temptable ( [ScholarshipAmountsValid] int )

;WITH applicantrankingcheckdata
AS (SELECT AwardingGroupId,
           COUNT(DISTINCT ApplicantRanking) DistinctRankings,
           MAX(ApplicantRanking) LowestRanking
    FROM dbo.DenormalizedEntries
    WHERE AwardingGroupId = 2
    GROUP BY AwardingGroupId),
     scholarshipawardcheckdata
AS (SELECT TOP 1
           AwardingGroupId,
           Scholarship,
           COUNT(DISTINCT ScholarshipAward) NumberOfAwardsPerScholarship
    FROM dbo.DenormalizedEntries
    WHERE AwardingGroupId = 2
    GROUP BY AwardingGroupId,
             Scholarship
    ORDER BY NumberOfAwardsPerScholarship DESC),
     applicantcheck
AS (SELECT applicantrankingcheckdata.AwardingGroupId,
           CASE
               WHEN applicantrankingcheckdata.DistinctRankings = applicantrankingcheckdata.LowestRanking THEN
                   1
               ELSE
                   0
           END ApplicantRankingValid
    FROM applicantrankingcheckdata)
	INSERT INTO #temptable
SELECT   CASE
           WHEN applicantcheck.ApplicantRankingValid
                + CASE
                      WHEN scholarshipawardcheckdata.NumberOfAwardsPerScholarship > 1 THEN
                          0
                      ELSE
                          1
                  END = 2 THEN
               1
           ELSE
               0
       END ScholarshipAmountsValid
FROM applicantrankingcheckdata
    INNER JOIN scholarshipawardcheckdata
        ON scholarshipawardcheckdata.AwardingGroupId = applicantrankingcheckdata.AwardingGroupId
    INNER JOIN applicantcheck
        ON applicantcheck.AwardingGroupId = applicantrankingcheckdata.AwardingGroupId;

SELECT @IsInValidFormat =#temptable.ScholarshipAmountsValid
FROM #temptable

DROP TABLE #temptable
SELECT @IsInValidFormat IsValidFormat
--SELECT *
--FROM dbo.DenormalizedEntries;
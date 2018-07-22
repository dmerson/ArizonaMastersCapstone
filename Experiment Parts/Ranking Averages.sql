WITH rankings
AS (SELECT AwardingGroups.AwardingGroupName,
           AlgorithmId,
           ROW_NUMBER() OVER (PARTITION BY AwardingGroups.AwardingGroupId
                              ORDER BY RA1 DESC,
                                       RA2 DESC,
                                       RA3 DESC,
                                       UniqueAwardees DESC,
                                       MaximumAward DESC,
                                       NumberOfAwarded DESC
                             ) Ranking
    FROM dbo.DenormalizedEntryAnalysises
        INNER JOIN dbo.AwardingGroups
            ON AwardingGroups.AwardingGroupId = DenormalizedEntryAnalysises.AwardingGroupId
    WHERE MaximumAward = 12400
          AND MaxApplicants = 2
          AND MinimumAward = 250
		--  AND MiniumumAwarded >=200
		  ),
     cntofffirstranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 1
	),
     totaloftopranked
AS (SELECT cntofffirstranked.AlgorithmId,
           COUNT(cntofffirstranked.Ranking) cntOf1stRanked
    FROM cntofffirstranked
    GROUP BY cntofffirstranked.AlgorithmId),
	avgranking AS (
SELECT rankings.AlgorithmId,
       AVG(CONVERT(DECIMAL, rankings.Ranking)) avgRank
FROM rankings
GROUP BY rankings.AlgorithmId)

SELECT * FROM totaloftopranked
ORDER BY 2 desc
--ORDER BY avgRank;


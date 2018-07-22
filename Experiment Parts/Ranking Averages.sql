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
          AND MinimumAward = 250),
     cntofffirstranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 1),
     totaloftopranked
AS (SELECT cntofffirstranked.AlgorithmId,
           COUNT(cntofffirstranked.Ranking) cntOf1stRanked
    FROM cntofffirstranked
    GROUP BY cntofffirstranked.AlgorithmId)
SELECT rankings.AlgorithmId,
       AVG(CONVERT(DECIMAL, rankings.Ranking)) avgRank
FROM rankings
GROUP BY rankings.AlgorithmId
ORDER BY avgRank;


--SELECT * FROM dbo.DenormalizedEntryAnalysises
-- INNER JOIN dbo.AwardingGroups ON AwardingGroups.AwardingGroupId = DenormalizedEntryAnalysises.AwardingGroupId
--WHERE MaximumAward=12400 AND MaxApplicants=2 AND MinimumAward =250 
--AND AwardingGroupName ='aw1'
--  ORDER BY RA1 DESC, RA2 DESC, RA3 DESC, UniqueAwardees DESC, MaximumAward DESC, NumberOfAwarded desc


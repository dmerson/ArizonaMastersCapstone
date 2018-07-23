DECLARE @MaximumAward DECIMAL(9, 2) = 10000;
DECLARE @MinimumAward DECIMAL(9, 2) = 250;
DECLARE @MaxApplicants INT = 5;

;WITH rankings
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
    WHERE MaximumAward = @MaximumAward
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MiniumumAwarded >= @MinimumAward),
      cntofffirstranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 1),
      cntof2NDranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 2),
      cntof3RDranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 3),
      cntof4THranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 4),
      cntof5THranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 5),
      cntof6THranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 6),
      cntof7THranked
AS (SELECT *
    FROM rankings
    WHERE rankings.Ranking = 7),
      totaloftopranked
AS (SELECT cntofffirstranked.AlgorithmId,
           COUNT(cntofffirstranked.Ranking) cntOf1stRanked
    FROM cntofffirstranked
    GROUP BY cntofffirstranked.AlgorithmId),
      totalof2NDranked
AS (SELECT AlgorithmId,
           COUNT(Ranking) cntOf2ndRanked
    FROM cntof2NDranked
    GROUP BY AlgorithmId),
      totalof3rdranked
AS (SELECT AlgorithmId,
           COUNT(Ranking) cntOf3rdRanked
    FROM cntof3RDranked
    GROUP BY AlgorithmId),
      totalof4thranked
AS (SELECT AlgorithmId,
           COUNT(Ranking) cntOf4thRanked
    FROM cntof4THranked
    GROUP BY AlgorithmId),
      totalof5thranked
AS (SELECT AlgorithmId,
           COUNT(Ranking) cntOf5thRanked
    FROM cntof5THranked
    GROUP BY AlgorithmId),
      totalof6thranked
AS (SELECT AlgorithmId,
           COUNT(Ranking) cntOf6thRanked
    FROM cntof6THranked
    GROUP BY AlgorithmId),
      totalof7thranked
AS (SELECT AlgorithmId,
           COUNT(Ranking) cntOf7thRanked
    FROM cntof7THranked
    GROUP BY AlgorithmId),
      avgranking
AS (SELECT rankings.AlgorithmId,
           AVG(CONVERT(DECIMAL, rankings.Ranking)) avgRank
    FROM rankings
    GROUP BY rankings.AlgorithmId)
SELECT Algorithms.AlgorithmId,
       AlgorithmName,
       ISNULL(totaloftopranked.cntOf1stRanked, 0) TopRanked,
       ISNULL(cntOf2ndRanked, 0) SecondRanked,
       ISNULL(totalof3rdranked.cntOf3rdRanked, 0) ThirdRanked,
       ISNULL(totalof4thranked.cntOf4thRanked, 0) FourthRanked,
       ISNULL(totalof5thranked.cntOf5thRanked, 0) FifthRanked,
       ISNULL(totalof6thranked.cntOf6thRanked, 0) SixthRanked,
       ISNULL(totalof7thranked.cntOf7thRanked, 0) SeventhRanked,
       avgranking.AlgorithmId,
       avgranking.avgRank
FROM dbo.Algorithms
    LEFT JOIN totaloftopranked
        ON totaloftopranked.AlgorithmId = Algorithms.AlgorithmId
    LEFT JOIN totalof2NDranked
        ON totalof2NDranked.AlgorithmId = Algorithms.AlgorithmId
    LEFT JOIN totalof3rdranked
        ON totalof3rdranked.AlgorithmId = Algorithms.AlgorithmId
    LEFT JOIN totalof4thranked
        ON totalof4thranked.AlgorithmId = Algorithms.AlgorithmId
    LEFT JOIN totalof5thranked
        ON totalof5thranked.AlgorithmId = Algorithms.AlgorithmId
    LEFT JOIN totalof6thranked
        ON totalof6thranked.AlgorithmId = Algorithms.AlgorithmId
    LEFT JOIN totalof7thranked
        ON totalof7thranked.AlgorithmId = Algorithms.AlgorithmId
    INNER JOIN avgranking
        ON avgranking.AlgorithmId = Algorithms.AlgorithmId
ORDER BY TopRanked DESC, SecondRanked DESC, ThirdRanked DESC, avgranking.avgRank desc;
--ORDER BY avgRank;


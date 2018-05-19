DECLARE @awardgroup INT = 1;
DECLARE @MaximumAward DECIMAL(9, 2) = 500;
DECLARE @MinimumAward DECIMAL(9, 2) = 100;
DECLARE @MaxApplicants INT = 2;
DECLARE @top INT =5;
EXEC dbo.RunAllAlgorithms @awardgroup,    -- int
                          @MaximumAward,  -- decimal(9, 2)
                          @MinimumAward,  -- decimal(9, 2)
                          @MaxApplicants; -- int


SELECT *
FROM
(
    SELECT ScholarshipAwardAnalysisId,
           AwardingGroupId,
           ScholarshipAwardAnalysises.AlgorithmId,
           MaximumAward,
           MinimumAward,
           MaxApplicants,
           RA1,
           RA2,
           RA3,
           NumberOfAwarded,
           UniqueAwardees,
           MaximumAwarded,
           MinimumAwarded,
           AlgorithmName,
           AlgorithmDescription,
           ROW_NUMBER() OVER (ORDER BY UniqueAwardees, NumberOfAwarded) TopN
    FROM dbo.ScholarshipAwardAnalysises
        INNER JOIN dbo.Algorithms
            ON Algorithms.AlgorithmId = ScholarshipAwardAnalysises.AlgorithmId
    WHERE AwardingGroupId = @awardgroup
          AND MaximumAward = @MaximumAward
          AND MinimumAward = @MinimumAward
          AND MaxApplicants = @MaxApplicants
          AND RA1 = 1
) REsults
WHERE REsults.TopN <= @top
ORDER BY UniqueAwardees DESC,
         NumberOfAwarded DESC;
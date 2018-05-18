DECLARE @algorithmid INT = 4;
DECLARE @awardgroup INT = 1;
DECLARE @MaximumAward DECIMAL = 1500;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

SELECT * FROM dbo.Algorithms
WHERE AlgorithmId=@algorithmid
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
DECLARE @CurrentScholarshipApplicantId INT;



DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
	  AND AwardingGroupId=@awardgroup;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN;
    SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @ScholarshipCounter AND AwardingGroupId=@awardgroup
    );
    WITH currenttotals
    AS (SELECT ApplicantId,
               SUM(Award)  Total
        FROM dbo.ScholarshipAwards
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
			  AND AwardingGroupId=@awardgroup 
        GROUP BY ApplicantId
        HAVING SUM(Award) >0)
    SELECT TOP 1
           @CurrentScholarshipId = ScholarshipId,
           @CurrentWinner = ApplicantId,
           --@CurrentAmount = ScholarshipAmount,
           @CurrentScholarshipApplicantId = ScholarshipApplicantId,
           @CurrentAmount = ScholarshipAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @ScholarshipCounter
          AND ApplicantId NOT IN
              (
                  SELECT ApplicantId FROM currenttotals
              )
			  AND AwardingGroupId =@awardgroup
    ORDER BY Ranking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



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

SELECT *
FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

SELECT ApplicantId,
       SUM(Award) Total
FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
GROUP BY ApplicantId
ORDER BY Total DESC;
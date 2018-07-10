DECLARE @algorithmid INT = 4;
DECLARE @awardgroup INT = 2;
DECLARE @MaximumAward DECIMAL = 1000;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

SELECT *
FROM dbo.Algorithms
WHERE AlgorithmId = @algorithmid;
--SELECT * FROM dbo.DenormalizedEntries
--WHERE AwardingGroupId =@awardgroup



DECLARE @ScholarshipCounter INT = 1;





DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

-- Set up loop variables
CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable
(
    scholarship,
    Scholarshiporder
)
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward DESC) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,
           ScholarshipAward
    FROM dbo.DenormalizedEntries
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT scholarship) FROM #scholarshiplooptable
        );




WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    -- Get Current Scholarship 
    DECLARE @CurrentCounter VARCHAR(255);
    SET @CurrentCounter =
    (
        SELECT scholarship
        FROM #scholarshiplooptable
        WHERE Scholarshiporder = @ScholarshipCounter
    );

    --set up winner variables
    DECLARE @CurrentWinner VARCHAR(100);
    DECLARE @CurrentScholarshipId VARCHAR(255);
    DECLARE @CurrentAmount DECIMAL(9, 2);

    SET @CurrentAmount =
    (
        SELECT TOP 1
               ScholarshipAward
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );

    --remove all previous winners from applicant pool
    -- get all winners and select where not applicant is not winner
    ;
    WITH currenttotals
    AS (SELECT Applicant,
               SUM(AwardAmount) Total
        FROM dbo.DenormalizedEntyResults
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
              AND AwardingGroupId = @awardgroup
        GROUP BY Applicant
        HAVING SUM(AwardAmount) > 0)
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


    --insert results
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

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid,   -- int
                                         @MaxApplicants, -- int
                                         @MinimumAward,  -- decimal(9, 2)
                                         @MaximumAward,  -- decimal(9, 2)
                                         @awardgroup;    -- int
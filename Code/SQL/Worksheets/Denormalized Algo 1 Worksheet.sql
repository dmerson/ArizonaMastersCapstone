DECLARE @algorithmid INT = 1;
DECLARE @awardgroup INT = 2;
DECLARE @MaximumAward DECIMAL = 1500;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

SELECT *
FROM dbo.Algorithms
WHERE AlgorithmId = @algorithmid;

DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;


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

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CountOfScholarships INT =
        (
            SELECT MAX(Scholarshiporder) FROM #scholarshiplooptable
        );
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
	--Get Name of Current Scholarship In Loop
    DECLARE @CurrentLoopScholarshipName VARCHAR(255);
	
	SET @CurrentLoopScholarshipName =
    (
        SELECT TOP 1
               scholarship
        FROM #scholarshiplooptable
        WHERE Scholarshiporder = @ScholarshipCounter
    );
	--set variables to hold winners
    DECLARE @CurrentWinner VARCHAR(100);
    DECLARE @CurrentScholarship VARCHAR(255);
    DECLARE @CurrentAmount DECIMAL(9, 2);
    


	--set variable for winner
    SELECT TOP 1
           @CurrentScholarship = @CurrentLoopScholarshipName,
           @CurrentWinner = Applicant,
           @CurrentAmount = ScholarshipAward
    FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentLoopScholarshipName
          AND AwardingGroupId = @awardgroup
    ORDER BY ApplicantRanking ASC;

	--insert into results
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
        @CurrentScholarship,           -- ScholarshipApplicantId - int
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
GROUP BY Applicant;

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid,   -- int
                                         @MaxApplicants, -- int
                                         @MinimumAward,  -- decimal(9, 2)
                                         @MaximumAward,  -- decimal(9, 2)
                                         @awardgroup;    -- int

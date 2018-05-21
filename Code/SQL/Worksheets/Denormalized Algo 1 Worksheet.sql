DECLARE @algorithmid INT = 1;
DECLARE @awardgroup INT = 2;
DECLARE @MaximumAward DECIMAL = 1500;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

SELECT *
FROM dbo.Algorithms
WHERE AlgorithmId = @algorithmid;

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT Applicant)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarship VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;



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
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries
) UniqueScholarships
ORDER BY ScholarshipId;
 

SET @CountOfScholarships =(SELECT MAX(Scholarshiporder) FROM #scholarshiplooptable)
DECLARE @CurrentLoopScholarshipName VARCHAR(255)

WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN

SET @CurrentLoopScholarshipName=(SELECT TOP 1 scholarship from #scholarshiplooptable
  WHERE scholarshiporder =@ScholarshipCounter)
  
 

    SELECT TOP 1
           @CurrentScholarship =@CurrentLoopScholarshipName,
           @CurrentWinner = Applicant,
           @CurrentAmount = ScholarshipAward,
           @CurrentScholarshipApplicantId = DenormalizedEntryId
    FROM dbo.DenormalizedEntries
	 
    WHERE Scholarship=@CurrentLoopScholarshipName
          AND AwardingGroupId = @awardgroup
    ORDER BY ApplicantRanking ASC;
    --PRINT 'Current Winner is applicant:';
    --SELECT  @CurrentWinner CurrentWinner;
    --PRINT 'For the scholarship';
    --SELECT  @CurrentScholarship CurrentScholarship;



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
        @CurrentWinner,
		 @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable
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

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int

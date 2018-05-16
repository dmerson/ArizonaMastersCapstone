DECLARE @algorithmid INT = 1;
DECLARE @awardgroup INT = 1;
DECLARE @MaximumAward DECIMAL = 1500;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

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
DECLARE @applicantcounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;


DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SELECT TOP 1
           @CurrentScholarshipId = ScholarshipId,
           @CurrentWinner = ApplicantId,
           @CurrentAmount = ScholarshipAmount,
           @CurrentScholarshipApplicantId = ScholarshipApplicantId,
           @CurrentAmount = ScholarshipAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @ScholarshipCounter
    ORDER BY ApplicantId;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;

     
    INSERT INTO dbo.ScholarshipAwards
    (
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipApplicantId,
        Award
    )
    VALUES
    (   @algorithmid,                   -- AlgorithmId - int
        @MaximumAward,                  -- MaximumAward - decimal(9, 2)
        @MinimumAward,                  -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                 -- MaxApplicants - int
        @CurrentScholarshipApplicantId, -- ScholarshipApplicantId - int
        @CurrentAmount                  -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

SELECT *
FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward;

SELECT ApplicantId, SUM(Award)	 FROM dbo.ScholarshipAwards
INNER JOIN dbo.ScholarshipApplicants ON ScholarshipApplicants.ScholarshipApplicantId = ScholarshipAwards.ScholarshipApplicantId
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
	  GROUP BY ApplicantId;
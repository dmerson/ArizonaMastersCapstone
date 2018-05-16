DECLARE @algorithmid INT =1
DECLARE @awardgroup INT =1
DECLARE @MaximumAward decimal=1500
DECLARE @MinimumAward DECIMAL=500
DECLARE @MaxApplicants int=2	

--SELECT * FROM dbo.NormalizedView
--WHERE AwardingGroupId =@awardgroup

DECLARE @CountOfScholarships INT =(SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView)
DECLARE @CountOfApplicants INT =(SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView)

DECLARE @ScholarshipCounter INT =1
DECLARE @applicantcounter INT =1
DECLARE @CurrentWinner INT 
DECLARE @CurrentScholarshipId INT
DECLARE @CurrentAmount DECIMAL(9,2)
DECLARE @CurrentScholarshipApplicantId INT
WHILE @ScholarshipCounter <=@CountOfScholarships
BEGIN
	SELECT TOP 1  @CurrentScholarshipId=ScholarshipId,  @CurrentWinner=ApplicantId, @CurrentAmount=ScholarshipAmount, @CurrentScholarshipApplicantId=ScholarshipApplicantId,
	@CurrentAmount =ScholarshipAmount FROM dbo.NormalizedView
	WHERE scholarshipid =@ScholarshipCounter
	ORDER BY ApplicantId
	PRINT 'Current Winner is applicant:'
	PRINT @CurrentWinner
	PRINT 'For the scholarship'
	PRINT @CurrentScholarshipId
	
	DELETE FROM dbo.ScholarshipAwards
	WHERE AlgorithmId=@algorithmid
	AND MaximumAward =@MaximumAward
	AND MinimumAward =@MinimumAward
	AND MaxApplicants =@MaxApplicants
	AND ScholarshipApplicantId=@CurrentScholarshipApplicantId
	INSERT INTO dbo.ScholarshipAwards
	(
	    AlgorithmId,
	    MaximumAward,
	    MinimumAward,
	    MaxApplicants,
	    ScholarshipApplicantId,
	    Award
	)
	VALUES (   @algorithmid,    -- AlgorithmId - int
	    @MaximumAward, -- MaximumAward - decimal(9, 2)
	    @MinimumAward, -- MinimumAward - decimal(9, 2)
	    @MaxApplicants,    -- MaxApplicants - int
	    @CurrentScholarshipApplicantId,    -- ScholarshipApplicantId - int
	    @CurrentAmount  -- Award - decimal(9, 2)
		)
	      
	SET @ScholarshipCounter =@ScholarshipCounter + 1
END

SELECT * FROM dbo.ScholarshipAwards
WHERE AlgorithmId =@algorithmid
AND MaxApplicants=@MaxApplicants
AND MinimumAward=@MinimumAward
AND MaximumAward=@MaximumAward
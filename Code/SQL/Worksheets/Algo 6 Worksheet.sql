DECLARE @algorithmid INT = 6;
DECLARE @awardgroup INT = 1;
DECLARE @MaximumAward DECIMAL = 1500;
DECLARE @MinimumAward DECIMAL = 500;
DECLARE @MaxApplicants INT = 2;

SELECT *
FROM dbo.Algorithms
WHERE AlgorithmId = @algorithmid;
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
DECLARE @CurrentScholarshipApplicants INT;
DECLARE @CurrentSplitAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;

DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN;
    SET @CurrentAmount =
    (
        SELECT TOP 1
               ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @ScholarshipCounter
              AND AwardingGroupId = @awardgroup
    );
	 
    SET @CurrentScholarshipApplicants =
    (
	SELECT CASE WHEN CountTotalTable.TotalApplicants > @MaxApplicants THEN @MaxApplicants ELSE CountTotalTable.TotalApplicants end FROM (
        SELECT  COUNT(ApplicantId) TotalApplicants
        FROM dbo.NormalizedView
    WHERE ScholarshipId = @ScholarshipCounter
          AND AwardingGroupId = @awardgroup ) CountTotalTable
    );
	 
	 
    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @CurrentScholarshipApplicants);

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
	SELECT OrderGroup.AwardGroup,
           OrderGroup.AlgorithmId,
           OrderGroup.MaximumAward,
           OrderGroup.MinimumAward,
           OrderGroup.MaxApplicants,
           OrderGroup.ScholarshipId,
           OrderGroup.ApplicantId,
           OrderGroup.CurrentAmount FROM (
    SELECT  @awardgroup AwardGroup,
           @algorithmid AlgorithmId,
           @MaximumAward MaximumAward,
           @MinimumAward MinimumAward,
           @MaxApplicants MaxApplicants,
           ScholarshipId,
           ApplicantId,
           @CurrentSplitAmount CurrentAmount,
		   ROW_NUMBER() OVER (ORDER BY RANKing) OrderId
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @ScholarshipCounter
          AND AwardingGroupId = @awardgroup) OrderGroup
		  WHERE OrderGroup.OrderId <=@MaxApplicants
		 
    ORDER BY OrderGroup.OrderId ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

SELECT *
FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;

SELECT ApplicantId,
       SUM(Award) Total
FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup
GROUP BY ApplicantId
ORDER BY Total DESC;
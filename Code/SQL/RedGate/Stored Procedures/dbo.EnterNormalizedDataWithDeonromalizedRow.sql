SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[EnterNormalizedDataWithDeonromalizedRow]
    @AwardingGroupId INT,
    @scholarshipnname VARCHAR(255),
    @Scholarshipamount DECIMAL(9, 2),
    @firstname VARCHAR(50),
    @lastname VARCHAR(50),
    @applicantranking INT
AS
SET NOCOUNT ON;
DECLARE @applicantid INT;
DECLARE @applicantrankingid INT;
DECLARE @scholarshipid INT;

IF
(
    SELECT COUNT(*)
    FROM dbo.Applicants
    WHERE FirstName = @firstname
          AND LastName = @lastname
) > 0
BEGIN
    SET @applicantid =
    (
        SELECT ApplicantId
        FROM dbo.Applicants
        WHERE FirstName = @firstname
              AND LastName = @lastname
    );

END;
ELSE
BEGIN
    INSERT INTO dbo.Applicants
    (
        FirstName,
        LastName
    )
    VALUES
    (   @firstname, -- FirstName - varchar(50)
        @lastname   -- LastName - varchar(50)
        );
    SET @applicantid = SCOPE_IDENTITY();
END;
IF
(
    SELECT COUNT(*)
    FROM dbo.Scholarships
    WHERE ScholarshipName = @scholarshipnname
          AND ScholarshipAmount = @Scholarshipamount
) > 0
BEGIN
    SET @scholarshipid =
    (
        SELECT ScholarshipId
        FROM Scholarships
        WHERE ScholarshipName = @scholarshipnname
              AND ScholarshipAmount = @Scholarshipamount
    );
END;
ELSE
BEGIN
    INSERT INTO dbo.Scholarships
    (
        ScholarshipName,
        ScholarshipAmount
    )
    VALUES
    (   @scholarshipnname, -- ScholarshipName - varchar(255)
        @Scholarshipamount -- ScholarshipAmount - decimal(9, 2)
        );
    SET @scholarshipid = SCOPE_IDENTITY();
END;
IF
(
    SELECT COUNT(*)
    FROM dbo.ApplicantRankings
    WHERE AwardingGroupId = @AwardingGroupId
          AND ApplicantId = @applicantid
          AND ApplicantRankingId = @applicantranking
) > 0
BEGIN
    SET @applicantrankingid =
    (
        SELECT ApplicantRankingId
        FROM dbo.ApplicantRankings
        WHERE AwardingGroupId = @AwardingGroupId
              AND ApplicantId = @applicantid
              AND ApplicantRankingId = @applicantranking
    );
END;
ELSE
BEGIN
    INSERT INTO dbo.ApplicantRankings
    (
        AwardingGroupId,
        ApplicantId,
        Ranking
    )
    VALUES
    (   @AwardingGroupId, -- AwardingGroupId - int
        @applicantid,     -- ApplicantId - int
        @applicantranking -- Ranking - int
        );
    SET @applicantrankingid = SCOPE_IDENTITY();
END;

IF (SELECT COUNT(*) FROM dbo.ScholarshipApplicants
WHERE AwardingGroupId =@AwardingGroupId AND ScholarshipId=@scholarshipid
AND ApplicantId=@applicantid) <1
BEGIN
	INSERT INTO dbo.ScholarshipApplicants
	(
	    AwardingGroupId,
	    ScholarshipId,
	    ApplicantId
	)
	VALUES
	(   @AwardingGroupId, -- AwardingGroupId - int
	    @scholarshipid, -- ScholarshipId - int
	    @applicantid  -- ApplicantId - int
	    )

end
GO

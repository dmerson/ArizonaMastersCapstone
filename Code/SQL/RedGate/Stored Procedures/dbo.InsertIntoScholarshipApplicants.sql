SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[InsertIntoScholarshipApplicants]
    @awardingroupid INT,
    @Scholarshipid INT,
    @applicantid INT
AS
SET NOCOUNT ON;

INSERT INTO dbo.ScholarshipApplicants
(
    AwardingGroupId,
    ScholarshipId,
    ApplicantId
)
VALUES
(   @awardingroupid, -- AwardingGroupId - int
    @Scholarshipid,  -- ScholarshipId - int
    @applicantid     -- ApplicantId - int
    );

SELECT *
FROM dbo.ScholarshipApplicants
WHERE ScholarshipApplicantId = @@IDENTITY;
GO

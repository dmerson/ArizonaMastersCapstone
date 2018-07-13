SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[InsertIntoDenormalizedEntry]
@AwardingGroupId  INT,
        @Scholarship  varchar(255),
       @ScholarshipAward decimal(9, 2),
        @Applicant  varchar(100),
        @ApplicantRanking  int

AS
SET NOCOUNT on
INSERT INTO dbo.DenormalizedEntries
    (
        AwardingGroupId,
        Scholarship,
        ScholarshipAward,
        Applicant,
        ApplicantRanking
    )
VALUES
    (
      @AwardingGroupId  ,
        @Scholarship ,
        @ScholarshipAward ,
        @Applicant,
        @ApplicantRanking 
    )
	SELECT * FROM dbo.DenormalizedEntries
	WHERE DenormalizedEntryId =SCOPE_IDENTITY()
GO

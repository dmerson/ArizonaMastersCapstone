SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[InsertIntoApplicantRanking]
@awardingroupid INT,
@applicantid INT,
@ranking INT 

AS
SET NOCOUNT ON 

INSERT INTO dbo.ApplicantRankings
(
    AwardingGroupId,
    ApplicantId,
    Ranking
)
VALUES
(   @awardingroupid, -- AwardingGroupId - int
    @applicantid, -- ApplicantId - int
    @ranking  -- Ranking - int
    )

	SELECT * FROM dbo.ApplicantRankings
	WHERE ApplicantRankingId =@@IDENTITY
GO

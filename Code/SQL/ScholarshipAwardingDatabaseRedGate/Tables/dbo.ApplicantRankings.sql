CREATE TABLE [dbo].[ApplicantRankings]
(
[ApplicantRankingId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[ApplicantId] [int] NOT NULL,
[Ranking] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantRankings] ADD CONSTRAINT [PK_ApplicantRankings] PRIMARY KEY CLUSTERED  ([ApplicantRankingId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantRankings] ADD CONSTRAINT [FK_ApplicantRankings_Applicants] FOREIGN KEY ([ApplicantId]) REFERENCES [dbo].[Applicants] ([ApplicantId])
GO
ALTER TABLE [dbo].[ApplicantRankings] ADD CONSTRAINT [FK_ApplicantRankings_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO

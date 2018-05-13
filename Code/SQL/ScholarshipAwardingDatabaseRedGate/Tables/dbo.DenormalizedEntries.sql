CREATE TABLE [dbo].[DenormalizedEntries]
(
[DenormalizedEntryId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Scholarship] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScholarshipAward] [decimal] (9, 2) NOT NULL,
[Applicant] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicantRanking] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DenormalizedEntries] ADD CONSTRAINT [PK_DenormalizedEntries] PRIMARY KEY CLUSTERED  ([DenormalizedEntryId]) ON [PRIMARY]
GO

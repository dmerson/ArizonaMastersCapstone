CREATE TABLE [dbo].[DenormalizedEntryAnalysises]
(
[DenormalizedEntryAnalysisId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[RA1] [bit] NOT NULL,
[RA2] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] ADD CONSTRAINT [PK_DenormalizedEntryAnalysises] PRIMARY KEY CLUSTERED  ([DenormalizedEntryAnalysisId]) ON [PRIMARY]
GO

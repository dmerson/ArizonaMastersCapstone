CREATE TABLE [dbo].[DenormalizedEntryAnalysises]
(
[DenormalizedEntryAnalysisId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[RA1] [bit] NOT NULL,
[RA2] [bit] NOT NULL,
[RA3] [bit] NOT NULL,
[NumberOfAwarded] [int] NOT NULL,
[UniqueAwardees] [int] NOT NULL,
[MaximumAwarded] [int] NOT NULL,
[MiniumumAwarded] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] ADD CONSTRAINT [PK_DenormalizedEntryAnalysises] PRIMARY KEY CLUSTERED  ([DenormalizedEntryAnalysisId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] ADD CONSTRAINT [FK_DenormalizedEntryAnalysises_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO

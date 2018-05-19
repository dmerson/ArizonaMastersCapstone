CREATE TABLE [dbo].[ScholarshipAwardAnalysises]
(
[ScholarshipAwardAnalysisId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[RA1] [bit] NOT NULL,
[RA2] [bit] NOT NULL,
[RA3] [bit] NULL,
[NumberOfAwarded] [int] NULL,
[UniqueAwardees] [int] NULL,
[MaximumAwarded] [decimal] (9, 2) NULL,
[MinimumAwarded] [decimal] (9, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] ADD CONSTRAINT [PK_ScholarshipAwardAnalysises] PRIMARY KEY CLUSTERED  ([ScholarshipAwardAnalysisId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] ADD CONSTRAINT [FK_ScholarshipAwardAnalysises_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] ADD CONSTRAINT [FK_ScholarshipAwardAnalysises_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO

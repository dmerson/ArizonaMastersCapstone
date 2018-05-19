CREATE TABLE [dbo].[ScholarshipAwards]
(
[ScholarshipAwardId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[ScholarshipId] [int] NOT NULL,
[ApplicantId] [int] NOT NULL,
[Award] [decimal] (9, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [PK_ScholarshipAwards] PRIMARY KEY CLUSTERED  ([ScholarshipAwardId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_Applicants] FOREIGN KEY ([ApplicantId]) REFERENCES [dbo].[Applicants] ([ApplicantId])
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_Scholarships] FOREIGN KEY ([ScholarshipId]) REFERENCES [dbo].[Scholarships] ([ScholarshipId])
GO

CREATE TABLE [dbo].[ScholarshipAwards]
(
[ScholarshipAwardId] [int] NOT NULL IDENTITY(1, 1),
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[ScholarshipApplicantId] [int] NOT NULL,
[Award] [decimal] (9, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [PK_ScholarshipAwards] PRIMARY KEY CLUSTERED  ([ScholarshipAwardId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_ScholarshipApplicants] FOREIGN KEY ([ScholarshipApplicantId]) REFERENCES [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId])
GO

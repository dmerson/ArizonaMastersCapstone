CREATE TABLE [dbo].[DenormalizedEntyResults]
(
[DenormalizedEntryResultId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[Scholarship] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Applicant] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AwardAmount] [decimal] (9, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [PK_DenormalizedEntyResults] PRIMARY KEY CLUSTERED  ([DenormalizedEntryResultId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [FK_DenormalizedEntyResults_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO

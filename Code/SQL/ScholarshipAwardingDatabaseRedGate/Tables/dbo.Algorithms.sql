CREATE TABLE [dbo].[Algorithms]
(
[AlgorithmId] [int] NOT NULL IDENTITY(1, 1),
[AlgorithmName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlgorithmDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Algorithms] ADD CONSTRAINT [PK_Algorithms] PRIMARY KEY CLUSTERED  ([AlgorithmId]) ON [PRIMARY]
GO

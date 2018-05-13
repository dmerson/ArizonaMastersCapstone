CREATE TABLE [dbo].[Scholarships]
(
[ScholarshipId] [int] NOT NULL IDENTITY(1, 1),
[ScholarshipName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScholarshipAmount] [decimal] (9, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Scholarships] ADD CONSTRAINT [PK_Scholarships] PRIMARY KEY CLUSTERED  ([ScholarshipId]) ON [PRIMARY]
GO

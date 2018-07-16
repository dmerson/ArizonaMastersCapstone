CREATE TABLE [dbo].[Applicants]
(
[ApplicantId] [int] NOT NULL IDENTITY(1, 1),
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Applicants] ADD CONSTRAINT [PK_Applicants] PRIMARY KEY CLUSTERED  ([ApplicantId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Applicants] ON [dbo].[Applicants] ([LastName], [FirstName]) ON [PRIMARY]
GO

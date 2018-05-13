/*
Run this script on:

        TARDIS\TARDIS.DWConfiguration    -  This database will be modified

to synchronize it with:

        TARDIS\TARDIS.ScholarshipAwardingProcess

You are recommended to back up your database before running this script

Script created by SQL Compare version 13.0.3.5144 from Red Gate Software Ltd at 5/13/2018 4:15:32 AM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Applicants]'
GO
CREATE TABLE [dbo].[Applicants]
(
[ApplicantId] [int] NOT NULL IDENTITY(1, 1),
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Applicants] on [dbo].[Applicants]'
GO
ALTER TABLE [dbo].[Applicants] ADD CONSTRAINT [PK_Applicants] PRIMARY KEY CLUSTERED  ([ApplicantId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ApplicantRankings]'
GO
CREATE TABLE [dbo].[ApplicantRankings]
(
[ApplicantRankingId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[ApplicantId] [int] NOT NULL,
[Ranking] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ApplicantRankings] on [dbo].[ApplicantRankings]'
GO
ALTER TABLE [dbo].[ApplicantRankings] ADD CONSTRAINT [PK_ApplicantRankings] PRIMARY KEY CLUSTERED  ([ApplicantRankingId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AwardingGroups]'
GO
CREATE TABLE [dbo].[AwardingGroups]
(
[AwardingGroupId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_AwardingGroups] on [dbo].[AwardingGroups]'
GO
ALTER TABLE [dbo].[AwardingGroups] ADD CONSTRAINT [PK_AwardingGroups] PRIMARY KEY CLUSTERED  ([AwardingGroupId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Algorithms]'
GO
CREATE TABLE [dbo].[Algorithms]
(
[AlgorithmId] [int] NOT NULL IDENTITY(1, 1),
[AlgorithmName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlgorithmDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Algorithms] on [dbo].[Algorithms]'
GO
ALTER TABLE [dbo].[Algorithms] ADD CONSTRAINT [PK_Algorithms] PRIMARY KEY CLUSTERED  ([AlgorithmId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DenormalizedEntyResults]'
GO
CREATE TABLE [dbo].[DenormalizedEntyResults]
(
[DenormalizedEntryResultId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[RA1] [bit] NOT NULL,
[RA2] [bit] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DenormalizedEntyResults] on [dbo].[DenormalizedEntyResults]'
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [PK_DenormalizedEntyResults] PRIMARY KEY CLUSTERED  ([DenormalizedEntryResultId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ScholarshipApplicants]'
GO
CREATE TABLE [dbo].[ScholarshipApplicants]
(
[ScholarshipApplicantId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[ScholarshipId] [int] NOT NULL,
[ApplicantId] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ScholarshipApplicants] on [dbo].[ScholarshipApplicants]'
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [PK_ScholarshipApplicants] PRIMARY KEY CLUSTERED  ([ScholarshipApplicantId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Scholarships]'
GO
CREATE TABLE [dbo].[Scholarships]
(
[ScholarshipId] [int] NOT NULL IDENTITY(1, 1),
[ScholarshipName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScholarshipAmount] [decimal] (9, 2) NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Scholarships] on [dbo].[Scholarships]'
GO
ALTER TABLE [dbo].[Scholarships] ADD CONSTRAINT [PK_Scholarships] PRIMARY KEY CLUSTERED  ([ScholarshipId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ScholarshipAwardAnalysises]'
GO
CREATE TABLE [dbo].[ScholarshipAwardAnalysises]
(
[ScholarshipAwardAnalysisId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[ScholarshipAwardId] [int] NULL,
[RA1] [bit] NOT NULL,
[RA2] [bit] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ScholarshipAwardAnalysises] on [dbo].[ScholarshipAwardAnalysises]'
GO
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] ADD CONSTRAINT [PK_ScholarshipAwardAnalysises] PRIMARY KEY CLUSTERED  ([ScholarshipAwardAnalysisId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ScholarshipAwards]'
GO
CREATE TABLE [dbo].[ScholarshipAwards]
(
[ScholarshipAwardId] [int] NOT NULL IDENTITY(1, 1),
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[ScholarshipApplicantId] [int] NOT NULL,
[Award] [decimal] (9, 2) NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ScholarshipAwards] on [dbo].[ScholarshipAwards]'
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [PK_ScholarshipAwards] PRIMARY KEY CLUSTERED  ([ScholarshipAwardId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DenormalizedEntries]'
GO
CREATE TABLE [dbo].[DenormalizedEntries]
(
[DenormalizedEntryId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Scholarship] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScholarshipAward] [decimal] (9, 2) NOT NULL,
[Applicant] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicantRanking] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DenormalizedEntries] on [dbo].[DenormalizedEntries]'
GO
ALTER TABLE [dbo].[DenormalizedEntries] ADD CONSTRAINT [PK_DenormalizedEntries] PRIMARY KEY CLUSTERED  ([DenormalizedEntryId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ScholarshipApplicantRankings]'
GO
CREATE TABLE [dbo].[ScholarshipApplicantRankings]
(
[ScholarshipApplicantRankingId] [int] NOT NULL,
[AwardingGroupId] [int] NOT NULL,
[ScholarshipApplicantId] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DenormalizedEntyResults]'
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [FK_DenormalizedEntyResults_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ScholarshipAwardAnalysises]'
GO
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] ADD CONSTRAINT [FK_ScholarshipAwardAnalysises_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] ADD CONSTRAINT [FK_ScholarshipAwardAnalysises_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ScholarshipAwards]'
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_ScholarshipApplicants] FOREIGN KEY ([ScholarshipApplicantId]) REFERENCES [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ApplicantRankings]'
GO
ALTER TABLE [dbo].[ApplicantRankings] ADD CONSTRAINT [FK_ApplicantRankings_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO
ALTER TABLE [dbo].[ApplicantRankings] ADD CONSTRAINT [FK_ApplicantRankings_Applicants] FOREIGN KEY ([ApplicantId]) REFERENCES [dbo].[Applicants] ([ApplicantId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ScholarshipApplicants]'
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [FK_ScholarshipApplicants_Applicants] FOREIGN KEY ([ApplicantId]) REFERENCES [dbo].[Applicants] ([ApplicantId])
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [FK_ScholarshipApplicants_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [FK_ScholarshipApplicants_Scholarships] FOREIGN KEY ([ScholarshipId]) REFERENCES [dbo].[Scholarships] ([ScholarshipId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO

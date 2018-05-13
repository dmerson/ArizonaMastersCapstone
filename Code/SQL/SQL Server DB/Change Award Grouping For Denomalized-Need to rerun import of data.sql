/*
Run this script on:

        TARDIS\TARDIS.ScholarshipAwardingProcessDuplicate    -  This database will be modified

to synchronize it with:

        TARDIS\TARDIS.ScholarshipAwardingProcess

You are recommended to back up your database before running this script

Script created by SQL Compare version 13.3.2.5875 from Red Gate Software Ltd at 5/13/2018 6:30:33 AM

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
PRINT N'Dropping foreign keys from [dbo].[DenormalizedEntyResults]'
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] DROP CONSTRAINT [FK_DenormalizedEntyResults_Algorithms]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[DenormalizedEntries]'
GO
ALTER TABLE [dbo].[DenormalizedEntries] DROP CONSTRAINT [PK_DenormalizedEntries]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[DenormalizedEntryAnalysises]'
GO
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] DROP CONSTRAINT [PK_DenormalizedEntryAnalysises]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[DenormalizedEntyResults]'
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] DROP CONSTRAINT [PK_DenormalizedEntyResults]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NormalizedView]'
GO
CREATE VIEW [dbo].[NormalizedView]
as
SELECT AwardingGroups.AwardingGroupId,
       AwardingGroupName,
       ScholarshipApplicantId,
  
       
       Scholarships.ScholarshipId,
       ScholarshipName,
       ScholarshipAmount,
       Applicants.ApplicantId,
	   Ranking,
       FirstName,
       LastName FROM dbo.AwardingGroups
INNER JOIN dbo.ScholarshipApplicants ON ScholarshipApplicants.AwardingGroupId = AwardingGroups.AwardingGroupId
INNER JOIN dbo.Scholarships ON Scholarships.ScholarshipId = ScholarshipApplicants.ScholarshipId
INNER JOIN dbo.Applicants ON Applicants.ApplicantId = ScholarshipApplicants.ApplicantId
INNER JOIN dbo.ApplicantRankings ON ApplicantRankings.ApplicantId = Applicants.ApplicantId
 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Rebuilding [dbo].[DenormalizedEntyResults]'
GO
CREATE TABLE [dbo].[RG_Recovery_1_DenormalizedEntyResults]
(
[DenormalizedEntryResultId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[Scholarship] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Applicant] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AwardAmount] [decimal] (9, 2) NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET IDENTITY_INSERT [dbo].[RG_Recovery_1_DenormalizedEntyResults] ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
INSERT INTO [dbo].[RG_Recovery_1_DenormalizedEntyResults]([DenormalizedEntryResultId], [AlgorithmId], [MaximumAward], [MinimumAward], [MaxApplicants], [Scholarship], [Applicant], [AwardAmount]) SELECT [DenormalizedEntryResultId], [AlgorithmId], [MaximumAward], [MinimumAward], [MaxApplicants], [Scholarship], [Applicant], [AwardAmount] FROM [dbo].[DenormalizedEntyResults]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET IDENTITY_INSERT [dbo].[RG_Recovery_1_DenormalizedEntyResults] OFF
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @idVal BIGINT
SELECT @idVal = IDENT_CURRENT(N'[dbo].[DenormalizedEntyResults]')
IF @idVal IS NOT NULL
    DBCC CHECKIDENT(N'[dbo].[RG_Recovery_1_DenormalizedEntyResults]', RESEED, @idVal)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DROP TABLE [dbo].[DenormalizedEntyResults]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[RG_Recovery_1_DenormalizedEntyResults]', N'DenormalizedEntyResults', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DenormalizedEntyResults] on [dbo].[DenormalizedEntyResults]'
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [PK_DenormalizedEntyResults] PRIMARY KEY CLUSTERED  ([DenormalizedEntryResultId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Rebuilding [dbo].[DenormalizedEntries]'
GO
CREATE TABLE [dbo].[RG_Recovery_2_DenormalizedEntries]
(
[DenormalizedEntryId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[Scholarship] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScholarshipAward] [decimal] (9, 2) NOT NULL,
[Applicant] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicantRanking] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DELETE FROM dbo.DenormalizedEntries
SET IDENTITY_INSERT [dbo].[RG_Recovery_2_DenormalizedEntries] ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
INSERT INTO [dbo].[RG_Recovery_2_DenormalizedEntries]([DenormalizedEntryId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) SELECT [DenormalizedEntryId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking] FROM [dbo].[DenormalizedEntries]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET IDENTITY_INSERT [dbo].[RG_Recovery_2_DenormalizedEntries] OFF
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @idVal BIGINT
SELECT @idVal = IDENT_CURRENT(N'[dbo].[DenormalizedEntries]')
IF @idVal IS NOT NULL
    DBCC CHECKIDENT(N'[dbo].[RG_Recovery_2_DenormalizedEntries]', RESEED, @idVal)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DROP TABLE [dbo].[DenormalizedEntries]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[RG_Recovery_2_DenormalizedEntries]', N'DenormalizedEntries', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DenormalizedEntries] on [dbo].[DenormalizedEntries]'
GO
ALTER TABLE [dbo].[DenormalizedEntries] ADD CONSTRAINT [PK_DenormalizedEntries] PRIMARY KEY CLUSTERED  ([DenormalizedEntryId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Rebuilding [dbo].[DenormalizedEntryAnalysises]'
GO
CREATE TABLE [dbo].[RG_Recovery_3_DenormalizedEntryAnalysises]
(
[DenormalizedEntryAnalysisId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
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
SET IDENTITY_INSERT [dbo].[RG_Recovery_3_DenormalizedEntryAnalysises] ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
INSERT INTO [dbo].[RG_Recovery_3_DenormalizedEntryAnalysises]([DenormalizedEntryAnalysisId], [AlgorithmId], [MaximumAward], [MinimumAward], [MaxApplicants], [RA1], [RA2]) SELECT [DenormalizedEntryAnalysisId], [AlgorithmId], [MaximumAward], [MinimumAward], [MaxApplicants], [RA1], [RA2] FROM [dbo].[DenormalizedEntryAnalysises]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET IDENTITY_INSERT [dbo].[RG_Recovery_3_DenormalizedEntryAnalysises] OFF
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @idVal BIGINT
SELECT @idVal = IDENT_CURRENT(N'[dbo].[DenormalizedEntryAnalysises]')
IF @idVal IS NOT NULL
    DBCC CHECKIDENT(N'[dbo].[RG_Recovery_3_DenormalizedEntryAnalysises]', RESEED, @idVal)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DROP TABLE [dbo].[DenormalizedEntryAnalysises]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[RG_Recovery_3_DenormalizedEntryAnalysises]', N'DenormalizedEntryAnalysises', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DenormalizedEntryAnalysises] on [dbo].[DenormalizedEntryAnalysises]'
GO

ALTER TABLE [dbo].[DenormalizedEntryAnalysises] ADD CONSTRAINT [PK_DenormalizedEntryAnalysises] PRIMARY KEY CLUSTERED  ([DenormalizedEntryAnalysisId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DenormalizedEntyResults]'
GO

ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [FK_DenormalizedEntyResults_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
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

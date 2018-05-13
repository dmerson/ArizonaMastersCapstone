/*
Run this script on:

TARDIS\TARDIS.ScholarshipAwardingProcessDuplicate    -  This database will be modified

to synchronize it with:

TARDIS\TARDIS.ScholarshipAwardingProcess

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 13.3.2.5875 from Red Gate Software Ltd at 5/13/2018 6:40:34 AM

*/
		
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION

PRINT(N'Add 9 rows to [dbo].[DenormalizedEntries]')
SET IDENTITY_INSERT [dbo].[DenormalizedEntries] ON
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (1, 2, 'SC1', 1000.00, 'A1', 1)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (2, 2, 'SC1', 1000.00, 'A2', 2)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (3, 2, 'SC1', 10000.00, 'A4', 4)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (4, 2, 'SC2', 750.00, 'A1', 1)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (5, 2, 'SC2', 750.00, 'A3', 3)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (6, 2, 'SC3', 500.00, 'A1', 1)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (7, 2, 'SC3', 500.00, 'A2', 2)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (8, 2, 'SC3', 500.00, 'A3', 3)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (9, 2, 'SC3', 500.00, 'A4', 4)
SET IDENTITY_INSERT [dbo].[DenormalizedEntries] OFF
COMMIT TRANSACTION
GO

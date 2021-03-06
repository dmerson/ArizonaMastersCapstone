/*
Run this script on:

TARDIS\TARDIS.SAPClone    -  This database will be modified

to synchronize it with:

TARDIS\TARDIS.ScholarshipAwardingProcess

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 13.3.2.5875 from Red Gate Software Ltd at 7/11/2018 6:40:16 PM

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

PRINT(N'Drop constraints from [dbo].[ScholarshipApplicants]')
ALTER TABLE [dbo].[ScholarshipApplicants] NOCHECK CONSTRAINT [FK_ScholarshipApplicants_Applicants]
ALTER TABLE [dbo].[ScholarshipApplicants] NOCHECK CONSTRAINT [FK_ScholarshipApplicants_AwardingGroups]
ALTER TABLE [dbo].[ScholarshipApplicants] NOCHECK CONSTRAINT [FK_ScholarshipApplicants_Scholarships]

PRINT(N'Drop constraints from [dbo].[DenormalizedEntries]')
ALTER TABLE [dbo].[DenormalizedEntries] NOCHECK CONSTRAINT [FK_DenormalizedEntries_AwardingGroups]

PRINT(N'Drop constraints from [dbo].[ApplicantRankings]')
ALTER TABLE [dbo].[ApplicantRankings] NOCHECK CONSTRAINT [FK_ApplicantRankings_Applicants]
ALTER TABLE [dbo].[ApplicantRankings] NOCHECK CONSTRAINT [FK_ApplicantRankings_AwardingGroups]

PRINT(N'Drop constraint FK_ScholarshipAwards_Scholarships from [dbo].[ScholarshipAwards]')
ALTER TABLE [dbo].[ScholarshipAwards] NOCHECK CONSTRAINT [FK_ScholarshipAwards_Scholarships]

PRINT(N'Drop constraint FK_DenormalizedEntryAnalysises_AwardingGroups from [dbo].[DenormalizedEntryAnalysises]')
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] NOCHECK CONSTRAINT [FK_DenormalizedEntryAnalysises_AwardingGroups]

PRINT(N'Drop constraint FK_DenormalizedEntyResults_AwardingGroups from [dbo].[DenormalizedEntyResults]')
ALTER TABLE [dbo].[DenormalizedEntyResults] NOCHECK CONSTRAINT [FK_DenormalizedEntyResults_AwardingGroups]

PRINT(N'Drop constraint FK_ScholarshipAwardAnalysises_AwardingGroups from [dbo].[ScholarshipAwardAnalysises]')
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] NOCHECK CONSTRAINT [FK_ScholarshipAwardAnalysises_AwardingGroups]

PRINT(N'Drop constraint FK_ScholarshipAwards_AwardingGroups from [dbo].[ScholarshipAwards]')
ALTER TABLE [dbo].[ScholarshipAwards] NOCHECK CONSTRAINT [FK_ScholarshipAwards_AwardingGroups]

PRINT(N'Drop constraint FK_ScholarshipAwards_Applicants from [dbo].[ScholarshipAwards]')
ALTER TABLE [dbo].[ScholarshipAwards] NOCHECK CONSTRAINT [FK_ScholarshipAwards_Applicants]

PRINT(N'Drop constraint FK_DenormalizedEntyResults_Algorithms from [dbo].[DenormalizedEntyResults]')
ALTER TABLE [dbo].[DenormalizedEntyResults] NOCHECK CONSTRAINT [FK_DenormalizedEntyResults_Algorithms]

PRINT(N'Drop constraint FK_ScholarshipAwardAnalysises_Algorithms from [dbo].[ScholarshipAwardAnalysises]')
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] NOCHECK CONSTRAINT [FK_ScholarshipAwardAnalysises_Algorithms]

PRINT(N'Drop constraint FK_ScholarshipAwards_Algorithms from [dbo].[ScholarshipAwards]')
ALTER TABLE [dbo].[ScholarshipAwards] NOCHECK CONSTRAINT [FK_ScholarshipAwards_Algorithms]

PRINT(N'Add 7 rows to [dbo].[Algorithms]')
SET IDENTITY_INSERT [dbo].[Algorithms] ON
INSERT INTO [dbo].[Algorithms] ([AlgorithmId], [AlgorithmName], [AlgorithmDescription]) VALUES (1, 'Merit Only', 'Only use top applicant for scholarship')
INSERT INTO [dbo].[Algorithms] ([AlgorithmId], [AlgorithmName], [AlgorithmDescription]) VALUES (2, 'Merit Only Disqualify After Exceeding Maximum', 'Use top but top out a single person')
INSERT INTO [dbo].[Algorithms] ([AlgorithmId], [AlgorithmName], [AlgorithmDescription]) VALUES (3, 'Merit Only Awarding Can’t Exceed Maximum
', 'Use top but don''t let go over certain amount')
INSERT INTO [dbo].[Algorithms] ([AlgorithmId], [AlgorithmName], [AlgorithmDescription]) VALUES (4, 'Maximum One Award Per Applicant', 'Only allow an applicant to have a single scholalrship')
INSERT INTO [dbo].[Algorithms] ([AlgorithmId], [AlgorithmName], [AlgorithmDescription]) VALUES (5, 'Split with all qualified applicants
', 'Split award with all qualified applicants')
INSERT INTO [dbo].[Algorithms] ([AlgorithmId], [AlgorithmName], [AlgorithmDescription]) VALUES (6, 'Split with minimum qualified applicants
', 'Split award with applicants up to a certain number')
INSERT INTO [dbo].[Algorithms] ([AlgorithmId], [AlgorithmName], [AlgorithmDescription]) VALUES (7, 'Split with minimum amount given
', 'Split evenly up to split doesn''t bring award amount below a certain level')
SET IDENTITY_INSERT [dbo].[Algorithms] OFF

PRINT(N'Add 4 rows to [dbo].[Applicants]')
SET IDENTITY_INSERT [dbo].[Applicants] ON
INSERT INTO [dbo].[Applicants] ([ApplicantId], [FirstName], [LastName]) VALUES (1, 'A1', 'A1')
INSERT INTO [dbo].[Applicants] ([ApplicantId], [FirstName], [LastName]) VALUES (2, 'A2', 'A2')
INSERT INTO [dbo].[Applicants] ([ApplicantId], [FirstName], [LastName]) VALUES (3, 'A3', 'A3')
INSERT INTO [dbo].[Applicants] ([ApplicantId], [FirstName], [LastName]) VALUES (4, 'A4', 'A4')
SET IDENTITY_INSERT [dbo].[Applicants] OFF

PRINT(N'Add 2 rows to [dbo].[AwardingGroups]')
SET IDENTITY_INSERT [dbo].[AwardingGroups] ON
INSERT INTO [dbo].[AwardingGroups] ([AwardingGroupId], [AwardingGroupName]) VALUES (1, 'Paper Demo')
INSERT INTO [dbo].[AwardingGroups] ([AwardingGroupId], [AwardingGroupName]) VALUES (2, 'Paper Denormalized Demo')
SET IDENTITY_INSERT [dbo].[AwardingGroups] OFF

PRINT(N'Add 3 rows to [dbo].[Scholarships]')
SET IDENTITY_INSERT [dbo].[Scholarships] ON
INSERT INTO [dbo].[Scholarships] ([ScholarshipId], [ScholarshipName], [ScholarshipAmount]) VALUES (1, 'SC1', 1000.00)
INSERT INTO [dbo].[Scholarships] ([ScholarshipId], [ScholarshipName], [ScholarshipAmount]) VALUES (2, 'SC2', 750.00)
INSERT INTO [dbo].[Scholarships] ([ScholarshipId], [ScholarshipName], [ScholarshipAmount]) VALUES (3, 'SC3', 500.00)
SET IDENTITY_INSERT [dbo].[Scholarships] OFF

PRINT(N'Add 4 rows to [dbo].[ApplicantRankings]')
SET IDENTITY_INSERT [dbo].[ApplicantRankings] ON
INSERT INTO [dbo].[ApplicantRankings] ([ApplicantRankingId], [AwardingGroupId], [ApplicantId], [Ranking]) VALUES (1, 1, 1, 1)
INSERT INTO [dbo].[ApplicantRankings] ([ApplicantRankingId], [AwardingGroupId], [ApplicantId], [Ranking]) VALUES (2, 1, 2, 2)
INSERT INTO [dbo].[ApplicantRankings] ([ApplicantRankingId], [AwardingGroupId], [ApplicantId], [Ranking]) VALUES (3, 1, 3, 3)
INSERT INTO [dbo].[ApplicantRankings] ([ApplicantRankingId], [AwardingGroupId], [ApplicantId], [Ranking]) VALUES (4, 1, 4, 4)
SET IDENTITY_INSERT [dbo].[ApplicantRankings] OFF

PRINT(N'Add 9 rows to [dbo].[DenormalizedEntries]')
SET IDENTITY_INSERT [dbo].[DenormalizedEntries] ON
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (1, 2, 'SC1', 1000.00, 'A1', 1)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (2, 2, 'SC1', 1000.00, 'A2', 2)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (3, 2, 'SC1', 1000.00, 'A4', 4)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (4, 2, 'SC2', 750.00, 'A1', 1)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (5, 2, 'SC2', 750.00, 'A3', 3)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (6, 2, 'SC3', 500.00, 'A1', 1)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (7, 2, 'SC3', 500.00, 'A2', 2)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (8, 2, 'SC3', 500.00, 'A3', 3)
INSERT INTO [dbo].[DenormalizedEntries] ([DenormalizedEntryId], [AwardingGroupId], [Scholarship], [ScholarshipAward], [Applicant], [ApplicantRanking]) VALUES (9, 2, 'SC3', 500.00, 'A4', 4)
SET IDENTITY_INSERT [dbo].[DenormalizedEntries] OFF

PRINT(N'Add 8 rows to [dbo].[ScholarshipApplicants]')
SET IDENTITY_INSERT [dbo].[ScholarshipApplicants] ON
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (1, 1, 1, 1)
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (2, 1, 2, 1)
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (3, 1, 1, 2)
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (4, 1, 3, 2)
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (5, 1, 2, 3)
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (6, 1, 3, 3)
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (7, 1, 3, 4)
INSERT INTO [dbo].[ScholarshipApplicants] ([ScholarshipApplicantId], [AwardingGroupId], [ScholarshipId], [ApplicantId]) VALUES (8, 1, 3, 1)
SET IDENTITY_INSERT [dbo].[ScholarshipApplicants] OFF

PRINT(N'Add constraints to [dbo].[ScholarshipApplicants]')
ALTER TABLE [dbo].[ScholarshipApplicants] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipApplicants_Applicants]
ALTER TABLE [dbo].[ScholarshipApplicants] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipApplicants_AwardingGroups]
ALTER TABLE [dbo].[ScholarshipApplicants] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipApplicants_Scholarships]

PRINT(N'Add constraints to [dbo].[DenormalizedEntries]')
ALTER TABLE [dbo].[DenormalizedEntries] WITH CHECK CHECK CONSTRAINT [FK_DenormalizedEntries_AwardingGroups]

PRINT(N'Add constraints to [dbo].[ApplicantRankings]')
ALTER TABLE [dbo].[ApplicantRankings] WITH CHECK CHECK CONSTRAINT [FK_ApplicantRankings_Applicants]
ALTER TABLE [dbo].[ApplicantRankings] WITH CHECK CHECK CONSTRAINT [FK_ApplicantRankings_AwardingGroups]
ALTER TABLE [dbo].[ScholarshipAwards] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwards_Scholarships]
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] WITH CHECK CHECK CONSTRAINT [FK_DenormalizedEntryAnalysises_AwardingGroups]
ALTER TABLE [dbo].[DenormalizedEntyResults] WITH CHECK CHECK CONSTRAINT [FK_DenormalizedEntyResults_AwardingGroups]
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwardAnalysises_AwardingGroups]
ALTER TABLE [dbo].[ScholarshipAwards] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwards_AwardingGroups]
ALTER TABLE [dbo].[ScholarshipAwards] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwards_Applicants]
ALTER TABLE [dbo].[DenormalizedEntyResults] WITH CHECK CHECK CONSTRAINT [FK_DenormalizedEntyResults_Algorithms]
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwardAnalysises_Algorithms]
ALTER TABLE [dbo].[ScholarshipAwards] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwards_Algorithms]
COMMIT TRANSACTION
GO

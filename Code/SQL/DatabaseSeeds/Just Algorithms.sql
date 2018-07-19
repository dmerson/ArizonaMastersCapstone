/*
Run this script on:

TARDIS\TARDIS.SAPClone4    -  This database will be modified

to synchronize it with:

TARDIS\TARDIS.ScholarshipAwardingProcess

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 13.3.2.5875 from Red Gate Software Ltd at 7/18/2018 9:45:34 PM

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
ALTER TABLE [dbo].[DenormalizedEntyResults] WITH CHECK CHECK CONSTRAINT [FK_DenormalizedEntyResults_Algorithms]
ALTER TABLE [dbo].[ScholarshipAwardAnalysises] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwardAnalysises_Algorithms]
ALTER TABLE [dbo].[ScholarshipAwards] WITH CHECK CHECK CONSTRAINT [FK_ScholarshipAwards_Algorithms]
COMMIT TRANSACTION
GO

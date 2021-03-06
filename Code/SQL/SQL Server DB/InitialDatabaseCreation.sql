/*
Run this script on:

        TARDIS\TARDIS.SAPClone4    -  This database will be modified

to synchronize it with:

        TARDIS\TARDIS.ScholarshipAwardingProcess

You are recommended to back up your database before running this script

Script created by SQL Compare version 13.3.2.5875 from Red Gate Software Ltd at 7/18/2018 7:40:44 PM

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
PRINT N'Creating index [IX_Scholarships] on [dbo].[Scholarships]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Scholarships] ON [dbo].[Scholarships] ([ScholarshipName], [ScholarshipAmount])
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
PRINT N'Creating index [IX_ScholarshipApplicants] on [dbo].[ScholarshipApplicants]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ScholarshipApplicants] ON [dbo].[ScholarshipApplicants] ([AwardingGroupId], [ApplicantId], [ScholarshipId])
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
PRINT N'Creating index [IX_Applicants] on [dbo].[Applicants]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Applicants] ON [dbo].[Applicants] ([LastName], [FirstName])
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
PRINT N'Creating [dbo].[ScholarshipAwards]'
GO
CREATE TABLE [dbo].[ScholarshipAwards]
(
[ScholarshipAwardId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[ScholarshipId] [int] NOT NULL,
[ApplicantId] [int] NOT NULL,
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
[RA1] [bit] NOT NULL,
[RA2] [bit] NOT NULL,
[RA3] [bit] NULL,
[NumberOfAwarded] [int] NULL,
[UniqueAwardees] [int] NULL,
[MaximumAwarded] [decimal] (9, 2) NULL,
[MinimumAwarded] [decimal] (9, 2) NULL
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
PRINT N'Creating [dbo].[CreateAnalysis]'
GO
CREATE PROC [dbo].[CreateAnalysis]
	@algorithmid INT, 
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS


DELETE FROM dbo.ScholarshipAwardAnalysises
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;

;WITH calculations
AS (SELECT ApplicantRankings.AwardingGroupId,
           Ranking,
           SUM(Award) Total,
           ISNULL(LEAD(Ranking) OVER (ORDER BY Ranking), Ranking + 1) NextRanking,
           ISNULL(LEAD(SUM(Award)) OVER (ORDER BY Ranking), 0) NextAmount
    FROM dbo.ScholarshipAwards
        INNER JOIN dbo.ApplicantRankings
            ON ApplicantRankings.ApplicantId = ScholarshipAwards.ApplicantId
               AND ApplicantRankings.AwardingGroupId = ScholarshipAwards.AwardingGroupId
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND ApplicantRankings.AwardingGroupId = @awardgroup
    GROUP BY ApplicantRankings.AwardingGroupId,
             Ranking),
      maxmin
AS (SELECT AwardingGroupId,
           MAX(Total) MaximumAmount,
           MIN(Total) MinimumAmount
    FROM calculations
    GROUP BY calculations.AwardingGroupId),
      ra1checkraw
AS (SELECT calculations.AwardingGroupId,
           calculations.Ranking,
           calculations.Total,
           calculations.NextRanking,
           calculations.NextAmount,
           CASE
               WHEN calculations.Ranking + 1 = calculations.NextRanking THEN
                   1
               ELSE
                   0
           END OrderPreserved,
           CASE
               WHEN Total > calculations.NextAmount THEN
                   1
               ELSE
                   0
           END AmountPreserved,
           CASE
               WHEN Total >= calculations.NextAmount THEN
                   1
               ELSE
                   0
           END AmountEqualed
    FROM calculations),
      ra1
AS (SELECT ra1checkraw.AwardingGroupId,
           MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) CHECKer,
           CASE
               WHEN MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) = 2 THEN
                   1
               ELSE
                   0
           END r1Check,
           CASE
               WHEN MIN(ra1checkraw.AmountEqualed) + MIN(ra1checkraw.AmountEqualed) = 2 THEN
                   1
               ELSE
                   0
           END r2heck
    FROM ra1checkraw
    GROUP BY ra1checkraw.AwardingGroupId),
      countranks
AS (SELECT calculations.AwardingGroupId,
           COUNT(Ranking) cnt,
           MAX(Ranking) maxrank
    FROM calculations
    GROUP BY calculations.AwardingGroupId),
      ra3table
AS (SELECT countranks.AwardingGroupId,
           CASE
               WHEN countranks.cnt = maxrank THEN
                   1
               ELSE
                   0
           END ra3check
    FROM countranks),
      otherstats
AS (SELECT AwardingGroupId,
           COUNT(Award) NumberOfAwarded,
           COUNT(DISTINCT ApplicantId) UniqueAwardees,
           MAX(Award) MaximumAwarded,
           MIN(Award) MinimumAwarded
    FROM dbo.ScholarshipAwards
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND AwardingGroupId = @awardgroup
    GROUP BY AwardingGroupId)
INSERT INTO dbo.ScholarshipAwardAnalysises
(
    AwardingGroupId,
    AlgorithmId,
    MaximumAward,
    MinimumAward,
    MaxApplicants,
    RA1,
    RA2,
    RA3,
    NumberOfAwarded,
    UniqueAwardees,
    MaximumAwarded,
    MinimumAwarded
)
SELECT TOP 1
       countranks.AwardingGroupId,
       @algorithmid AlgorithmId,
       @MaximumAward MaximumAward,
       @MinimumAward MinimumAward,
       @MaxApplicants MaxApplicants,
       ra1.r1Check,
       ra1.r2heck,
       ra3table.ra3check,
       NumberOfAwarded,
       otherstats.UniqueAwardees,
       maxmin.MaximumAmount,
       maxmin.MinimumAmount
FROM ra1checkraw
    INNER JOIN ra1
        ON ra1.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN countranks
        ON countranks.AwardingGroupId = ra1.AwardingGroupId
    INNER JOIN ra3table
        ON ra3table.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN otherstats
        ON otherstats.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN maxmin
        ON maxmin.AwardingGroupId = ra1checkraw.AwardingGroupId;


		--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAlgorithm1]'
GO
CREATE PROC [dbo].[RunAlgorithm1]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 1;
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;



DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
			WHERE AwardingGroupId=@awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;



DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;


CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    SELECT TOP 1
           @CurrentScholarshipId = ScholarshipId,
           @CurrentWinner = ApplicantId,
           @CurrentAmount = ScholarshipAmount,
           @CurrentScholarshipApplicantId = ScholarshipApplicantId,
           @CurrentAmount = ScholarshipAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @CurrentCounter
          AND AwardingGroupId = @awardgroup
    ORDER BY Ranking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    VALUES
    (   @awardgroup, @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner, @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshipordertable
--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup
--GROUP BY ApplicantId;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int




--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAlgorithm2]'
GO
CREATE PROC [dbo].[RunAlgorithm2]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 2;
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

 

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
						WHERE AwardingGroupId =@awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;



DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants AND AwardingGroupId=@awardgroup;


CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;

WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    WITH currenttotals
    AS (SELECT ApplicantId,
               SUM(Award) Total
        FROM dbo.ScholarshipAwards
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
			  AND AwardingGroupId=@awardgroup
        GROUP BY ApplicantId
        HAVING SUM(Award) > @MaximumAward)
    SELECT TOP 1
           @CurrentScholarshipId = ScholarshipId,
           @CurrentWinner = ApplicantId,
           @CurrentAmount = ScholarshipAmount,
           @CurrentScholarshipApplicantId = ScholarshipApplicantId,
           @CurrentAmount = ScholarshipAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @CurrentCounter
          AND ApplicantId NOT IN
              (
                  SELECT ApplicantId FROM currenttotals
              )
			  AND AwardingGroupId=@awardgroup
    ORDER BY Ranking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    VALUES
    (   @awardgroup, @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner, @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY ApplicantId
--ORDER BY Total desc;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int



	--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAlgorithm3]'
GO
CREATE PROC [dbo].[RunAlgorithm3]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 3;
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT * FROM dbo.NormalizedView
--WHERE AwardingGroupId =@awardgroup

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;


 
DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
	  AND AwardingGroupId =@awardgroup;



CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;


WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter AND AwardingGroupId=@awardgroup
    );
    WITH currenttotals
    AS (SELECT ApplicantId,
               SUM(Award)  Total
        FROM dbo.ScholarshipAwards
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
			  AND AwardingGroupId=@awardgroup
        GROUP BY ApplicantId
        HAVING SUM(Award) +  @CurrentAmount  > @MaximumAward)
    SELECT TOP 1
           @CurrentScholarshipId = ScholarshipId,
           @CurrentWinner = ApplicantId,
            
           @CurrentScholarshipApplicantId = ScholarshipApplicantId,
           @CurrentAmount = ScholarshipAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @CurrentCounter
          AND ApplicantId NOT IN
              (
                  SELECT ApplicantId FROM currenttotals
              )
			  AND AwardingGroupId=@awardgroup
    ORDER BY Ranking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    VALUES
    (   @awardgroup, @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner, @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

DROP TABLE #scholarshipordertable
--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY ApplicantId
--ORDER BY Total desc;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int

	--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAlgorithm4]'
GO
CREATE PROC [dbo].[RunAlgorithm4]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
DECLARE @algorithmid INT = 4;
SET NOCOUNT on
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

 
DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;



DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
	  AND AwardingGroupId=@awardgroup;



CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter AND AwardingGroupId=@awardgroup
    );
    WITH currenttotals
    AS (SELECT ApplicantId,
               SUM(Award)  Total
        FROM dbo.ScholarshipAwards
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
			  AND AwardingGroupId=@awardgroup 
        GROUP BY ApplicantId
        HAVING SUM(Award) >0)
    SELECT TOP 1
           @CurrentScholarshipId = ScholarshipId,
           @CurrentWinner = ApplicantId,
           --@CurrentAmount = ScholarshipAmount,
           @CurrentScholarshipApplicantId = ScholarshipApplicantId,
           @CurrentAmount = ScholarshipAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @CurrentCounter
          AND ApplicantId NOT IN
              (
                  SELECT ApplicantId FROM currenttotals
              )
			  AND AwardingGroupId =@awardgroup
    ORDER BY Ranking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    VALUES
    (   @awardgroup, @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner, @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshipordertable
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;
--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY ApplicantId
--ORDER BY Total desc;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int
--DELETE FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;


	--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAlgorithm5]'
GO
CREATE PROC [dbo].[RunAlgorithm5]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 5;
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

 

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicants INT;
DECLARE @CurrentSplitAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;

DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;



CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;
WHILE @ScholarshipCounter <= @CountOfScholarships


BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    SET @CurrentAmount =
    (
        SELECT TOP 1
               ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );
	 
    SET @CurrentScholarshipApplicants =
    (
        SELECT COUNT(ApplicantId)
        FROM dbo.NormalizedView
    WHERE ScholarshipId = @CurrentCounter
          AND AwardingGroupId = @awardgroup
    );
	 
    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @CurrentScholarshipApplicants);

    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    SELECT  @awardgroup,
           @algorithmid,
           @MaximumAward,
           @MinimumAward,
           @MaxApplicants,
           ScholarshipId,
           ApplicantId,
           @CurrentSplitAmount
    FROM dbo.NormalizedView
    WHERE ScholarshipId = @CurrentCounter
          AND AwardingGroupId = @awardgroup
    ORDER BY Ranking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

DROP TABLE #scholarshipordertable
--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY ApplicantId
--ORDER BY Total desc;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int


--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAlgorithm6]'
GO
CREATE PROC [dbo].[RunAlgorithm6]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 6;
--left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

 

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
			WHERE AwardingGroupId =@awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicants INT;
DECLARE @CurrentSplitAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;

DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;


CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    SET @CurrentAmount =
    (
        SELECT TOP 1
               ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );

    SET @CurrentScholarshipApplicants =
    (
        SELECT CASE
                   WHEN CountTotalTable.TotalApplicants > @MaxApplicants THEN
                       @MaxApplicants
                   ELSE
                       CountTotalTable.TotalApplicants
               END
        FROM
        (
            SELECT COUNT(ApplicantId) TotalApplicants
            FROM dbo.NormalizedView
            WHERE ScholarshipId = @CurrentCounter
                  AND AwardingGroupId = @awardgroup
        ) CountTotalTable
    );


    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @CurrentScholarshipApplicants);

    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    SELECT OrderGroup.AwardGroup,
           OrderGroup.AlgorithmId,
           OrderGroup.MaximumAward,
           OrderGroup.MinimumAward,
           OrderGroup.MaxApplicants,
           OrderGroup.ScholarshipId,
           OrderGroup.ApplicantId,
           OrderGroup.CurrentAmount
    FROM
    (
        SELECT @awardgroup AwardGroup,
               @algorithmid AlgorithmId,
               @MaximumAward MaximumAward,
               @MinimumAward MinimumAward,
               @MaxApplicants MaxApplicants,
               ScholarshipId,
               ApplicantId,
               @CurrentSplitAmount CurrentAmount,
               ROW_NUMBER() OVER (ORDER BY Ranking) OrderId
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    ) OrderGroup
    WHERE OrderGroup.OrderId <= @MaxApplicants
    ORDER BY OrderGroup.OrderId ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

DROP TABLE #scholarshipordertable
--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY ApplicantId
--ORDER BY Total desc;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int

--DELETE FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;


	--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAlgorithm7]'
GO
CREATE PROC [dbo].[RunAlgorithm7]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 7;
-- left for future troubleshooting
--DECLARE @awardgroup INT = 1;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 50;
--DECLARE @MaxApplicants INT = 2;

 
 

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT ScholarshipId) FROM dbo.NormalizedView
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT ApplicantId) FROM dbo.NormalizedView
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner INT;
DECLARE @CurrentScholarshipId INT;
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicants INT;
DECLARE @CurrentSplitAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;
DECLARE @applicantswithMinimumAmounts INT;
DECLARE @CurrentNumberOfWinners INT;
DECLARE @peopletodivdeby INT;

DELETE FROM dbo.ScholarshipAwards
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;


CREATE TABLE #scholarshipordertable
(
    [ScholarshipId] INT,
    scholarshiporder INT
);
INSERT INTO #scholarshipordertable
(
    ScholarshipId,
    scholarshiporder
)
SELECT ScholarshipId,
       ROW_NUMBER() OVER (ORDER BY ScholarshipAmount DESC)
FROM NormalizedView
WHERE AwardingGroupId = @awardgroup;
DECLARE @CurrentCounter INT;


WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT ScholarshipId
        FROM #scholarshipordertable
        WHERE scholarshiporder = @ScholarshipCounter
    );

    --amount in pool
    SET @CurrentAmount =
    (
        SELECT TOP 1
               ScholarshipAmount
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );


    ---max number of people who can win
    SET @applicantswithMinimumAmounts =
    (
        SELECT CONVERT(INT, @CurrentAmount / @MinimumAward)
    );
	IF @applicantswithMinimumAmounts=0
	BEGIN
		SET @applicantswithMinimumAmounts=1
	end
    --total number of people in pool
    SET @CurrentScholarshipApplicants =
    (
        SELECT COUNT(ApplicantId) TotalApplicants
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );

    ---set which ever is lower max number or total real number in pool
    SET @peopletodivdeby =
    (
        SELECT CASE
                   WHEN @CurrentScholarshipApplicants < @applicantswithMinimumAmounts THEN
                       @CurrentScholarshipApplicants
                   ELSE
                       @applicantswithMinimumAmounts
               END
    );

    -- divide people by current amount
    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @peopletodivdeby);


    INSERT INTO dbo.ScholarshipAwards
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        ScholarshipId,
        ApplicantId,
        Award
    )
    SELECT OrderGroup.AwardGroup,
           OrderGroup.AlgorithmId,
           OrderGroup.MaximumAward,
           OrderGroup.MinimumAward,
           OrderGroup.MaxApplicants,
           OrderGroup.ScholarshipId,
           OrderGroup.ApplicantId,
           OrderGroup.CurrentAmount
    FROM
    (
        SELECT @awardgroup AwardGroup,
               @algorithmid AlgorithmId,
               @MaximumAward MaximumAward,
               @MinimumAward MinimumAward,
               @MaxApplicants MaxApplicants,
               ScholarshipId,
               ApplicantId,
               @CurrentSplitAmount CurrentAmount,
               ROW_NUMBER() OVER (ORDER BY Ranking) OrderId
        FROM dbo.NormalizedView
        WHERE ScholarshipId = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    ) OrderGroup
    WHERE OrderGroup.OrderId <= @peopletodivdeby
    ORDER BY OrderGroup.OrderId ASC;
   





    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshipordertable
--left for future troubleshooting possibilites
--SELECT *
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;

--SELECT ApplicantId,
--       SUM(Award) Total
--FROM dbo.ScholarshipAwards
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup
--GROUP BY ApplicantId
--ORDER BY Total DESC;
EXEC dbo.CreateAnalysis @algorithmid ,     -- int
                     @awardgroup ,      -- int
                     @MaximumAward , -- decimal(9, 2)
                     @MinimumAward , -- decimal(9, 2)
                     @MaxApplicants     -- int
--DELETE FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;



		--left for future troubleshooting
--SELECT *
--FROM dbo.ScholarshipAwardAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAllAlgorithms]'
GO
CREATE PROC [dbo].[RunAllAlgorithms]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
EXEC dbo.RunAlgorithm1 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm2 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm3 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm4 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm5 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm6 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm7 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DenormalizedEntyResults]'
GO
CREATE TABLE [dbo].[DenormalizedEntyResults]
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
PRINT N'Creating primary key [PK_DenormalizedEntyResults] on [dbo].[DenormalizedEntyResults]'
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [PK_DenormalizedEntyResults] PRIMARY KEY CLUSTERED  ([DenormalizedEntryResultId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DenormalizedEntryAnalysises]'
GO
CREATE TABLE [dbo].[DenormalizedEntryAnalysises]
(
[DenormalizedEntryAnalysisId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[AlgorithmId] [int] NOT NULL,
[MaximumAward] [decimal] (9, 2) NULL,
[MinimumAward] [decimal] (9, 2) NULL,
[MaxApplicants] [int] NULL,
[RA1] [bit] NOT NULL,
[RA2] [bit] NOT NULL,
[RA3] [bit] NOT NULL,
[NumberOfAwarded] [int] NOT NULL,
[UniqueAwardees] [int] NOT NULL,
[MaximumAwarded] [decimal] (9, 2) NOT NULL,
[MiniumumAwarded] [decimal] (9, 2) NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DenormalizedEntryAnalysises] on [dbo].[DenormalizedEntryAnalysises]'
GO
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] ADD CONSTRAINT [PK_DenormalizedEntryAnalysises] PRIMARY KEY CLUSTERED  ([DenormalizedEntryAnalysisId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DenormalizedEntries]'
GO
CREATE TABLE [dbo].[DenormalizedEntries]
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
PRINT N'Creating primary key [PK_DenormalizedEntries] on [dbo].[DenormalizedEntries]'
GO
ALTER TABLE [dbo].[DenormalizedEntries] ADD CONSTRAINT [PK_DenormalizedEntries] PRIMARY KEY CLUSTERED  ([DenormalizedEntryId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CreateDenormalizedEntryAnalysis]'
GO
CREATE PROC [dbo].[CreateDenormalizedEntryAnalysis]
    @algorithmid INT,
    @MaxApplicants INT,
    @MinimumAward DECIMAL(9, 2),
    @MaximumAward DECIMAL(9, 2),
    @awardgroup INT
AS
SET NOCOUNT ON
 
DELETE FROM dbo.DenormalizedEntryAnalysises
WHERE AlgorithmId = @algorithmid
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
      AND AwardingGroupId = @awardgroup;

;WITH calculations
AS (SELECT DenormalizedEntyResults.AwardingGroupId,
           ApplicantRanking Ranking,
           SUM(AwardAmount) Total,
           ISNULL(LEAD(ApplicantRanking) OVER (ORDER BY ApplicantRanking), ApplicantRanking + 1) NextRanking,
           ISNULL(LEAD(SUM(AwardAmount)) OVER (ORDER BY ApplicantRanking), 0) NextAmount
    FROM dbo.DenormalizedEntyResults
        INNER JOIN dbo.DenormalizedEntries
            ON DenormalizedEntries.AwardingGroupId = DenormalizedEntyResults.AwardingGroupId
               AND DenormalizedEntries.Applicant = DenormalizedEntyResults.Applicant
               AND DenormalizedEntries.Scholarship = DenormalizedEntyResults.Scholarship
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND DenormalizedEntyResults.AwardingGroupId = @awardgroup
    GROUP BY DenormalizedEntyResults.AwardingGroupId,
             ApplicantRanking),
      maxmin
AS (SELECT AwardingGroupId,
           MAX(Total) MaximumAmount,
           MIN(Total) MinimumAmount
    FROM calculations
    GROUP BY calculations.AwardingGroupId),
      ra1checkraw
AS (SELECT calculations.AwardingGroupId,
           calculations.Ranking,
           calculations.Total,
           calculations.NextRanking,
           calculations.NextAmount,
           CASE
               WHEN calculations.Ranking + 1 = calculations.NextRanking THEN
                   1
               ELSE
                   0
           END OrderPreserved,
           CASE
               WHEN Total > calculations.NextAmount THEN
                   1
               ELSE
                   0
           END AmountPreserved,
           CASE
               WHEN Total >= calculations.NextAmount THEN
                   1
               ELSE
                   0
           END AmountEqualed
    FROM calculations),
      ra1
AS (SELECT ra1checkraw.AwardingGroupId,
           MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) CHECKer,
           CASE
               WHEN MIN(ra1checkraw.OrderPreserved) + MIN(ra1checkraw.AmountPreserved) = 2 THEN
                   1
               ELSE
                   0
           END r1Check,
           CASE
               WHEN MIN(ra1checkraw.AmountEqualed) + MIN(ra1checkraw.AmountEqualed) = 2 THEN
                   1
               ELSE
                   0
           END r2heck
    FROM ra1checkraw
    GROUP BY ra1checkraw.AwardingGroupId),
      countranks
AS (SELECT calculations.AwardingGroupId,
           COUNT(Ranking) cnt,
           MAX(Ranking) maxrank
    FROM calculations
    GROUP BY calculations.AwardingGroupId),
      ra3table
AS (SELECT countranks.AwardingGroupId,
           CASE
               WHEN countranks.cnt = maxrank THEN
                   1
               ELSE
                   0
           END ra3check
    FROM countranks),
      otherstats
AS (SELECT distinct DenormalizedEntyResults.AwardingGroupId,
           COUNT(DISTINCT DenormalizedEntryResultId) NumberOfAwarded,
           COUNT(DISTINCT Applicant) UniqueAwardees,
           MAX(AwardAmount) MaximumAwarded,
           MIN(AwardAmount) MinimumAwarded
    FROM dbo.DenormalizedEntyResults
        --INNER JOIN dbo.DenormalizedEntries
        --    ON DenormalizedEntries.AwardingGroupId = DenormalizedEntyResults.AwardingGroupId
    WHERE AlgorithmId = @algorithmid
          AND MaxApplicants = @MaxApplicants
          AND MinimumAward = @MinimumAward
          AND MaximumAward = @MaximumAward
          AND DenormalizedEntyResults.AwardingGroupId = @awardgroup
		  AND AwardAmount >0
    GROUP BY DenormalizedEntyResults.AwardingGroupId)
INSERT INTO dbo.DenormalizedEntryAnalysises
(
    AwardingGroupId,
    AlgorithmId,
    MaximumAward,
    MinimumAward,
    MaxApplicants,
    RA1,
    RA2,
    RA3,
    NumberOfAwarded,
    UniqueAwardees,
    MaximumAwarded,
    MiniumumAwarded
)
SELECT TOP 1
       countranks.AwardingGroupId,
       @algorithmid AlgorithmId,
       @MaximumAward MaximumAward,
       @MinimumAward MinimumAward,
       @MaxApplicants MaxApplicants,
       ra1.r1Check,
       ra1.r2heck,
       ra3table.ra3check,
       NumberOfAwarded,
       otherstats.UniqueAwardees,
       maxmin.MaximumAmount,
       maxmin.MinimumAmount
FROM ra1checkraw
    INNER JOIN ra1
        ON ra1.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN countranks
        ON countranks.AwardingGroupId = ra1.AwardingGroupId
    INNER JOIN ra3table
        ON ra3table.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN otherstats
        ON otherstats.AwardingGroupId = ra1checkraw.AwardingGroupId
    INNER JOIN maxmin
        ON maxmin.AwardingGroupId = ra1checkraw.AwardingGroupId;


--SELECT *
--FROM dbo.DenormalizedEntryAnalysises
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunDeNormalizedAlgorithm1]'
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm1]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS

--SET NOCOUNT on
DECLARE @algorithmid INT = 1;
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT *
--FROM dbo.Algorithms
--WHERE AlgorithmId = @algorithmid;

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT Applicant)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarship VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId INT;



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;


CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;
 

SET @CountOfScholarships =(SELECT MAX(Scholarshiporder) FROM #scholarshiplooptable)
DECLARE @CurrentLoopScholarshipName VARCHAR(255)

WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN

SET @CurrentLoopScholarshipName=(SELECT TOP 1 scholarship from #scholarshiplooptable
  WHERE scholarshiporder =@ScholarshipCounter)
  
 

    SELECT TOP 1
           @CurrentScholarship =@CurrentLoopScholarshipName,
           @CurrentWinner = Applicant,
           @CurrentAmount = ScholarshipAward,
           @CurrentScholarshipApplicantId = DenormalizedEntryId
    FROM dbo.DenormalizedEntries
	 
    WHERE Scholarship=@CurrentLoopScholarshipName
          AND AwardingGroupId = @awardgroup
    ORDER BY ApplicantRanking ASC;
    --PRINT 'Current Winner is applicant:';
    --SELECT  @CurrentWinner CurrentWinner;
    --PRINT 'For the scholarship';
    --SELECT  @CurrentScholarship CurrentScholarship;



    INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    )
    VALUES
    (   @awardgroup, @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarship,           -- ScholarshipApplicantId - int
        @CurrentWinner,
		 @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable
--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup
--GROUP BY Applicant;

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunDeNormalizedAlgorithm2]'
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm2]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 2;
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1500;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT *
--FROM dbo.Algorithms
--WHERE AlgorithmId = @algorithmid;

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
DECLARE @CountOfApplicants INT =
        (
            SELECT COUNT(DISTINCT Applicant)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );

DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);


WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );

	;WITH currenttotals
    AS (SELECT Applicant,
               SUM(AwardAmount) Total
        FROM dbo.DenormalizedEntyResults
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
              AND AwardingGroupId = @awardgroup
        GROUP BY Applicant
        HAVING SUM(AwardAmount) > @MaximumAward)
	SELECT TOP 1
           @CurrentScholarshipId = Scholarship,
           @CurrentWinner = Applicant,
           @CurrentAmount = ScholarshipAward
           
            
    FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND Applicant NOT IN
              (
                  SELECT currenttotals.Applicant FROM currenttotals
              )
          AND AwardingGroupId = @awardgroup
    
    ORDER BY ApplicantRanking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



    INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    )
    
    VALUES
    (   @awardgroup, @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner, @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable;


--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward
--      AND AwardingGroupId = @awardgroup
--GROUP BY Applicant
--ORDER BY Total DESC;


EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunDeNormalizedAlgorithm3]'
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm3]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 3;
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1000;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT *
--FROM dbo.Algorithms
--WHERE AlgorithmId = @algorithmid;
--SELECT * FROM dbo.DenormalizedEntries
--WHERE AwardingGroupId =@awardgroup

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
 
DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);



WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );
    SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAward
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter AND AwardingGroupId=@awardgroup
    );
    ;WITH currenttotals
    AS (SELECT Applicant,
               SUM(AwardAmount)  Total
        FROM dbo.DenormalizedEntyResults
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
			  AND AwardingGroupId=@awardgroup
        GROUP BY Applicant
        HAVING SUM(AwardAmount) +  @CurrentAmount  > @MaximumAward)
    SELECT TOP 1
           @CurrentScholarshipId = Scholarship,
           @CurrentWinner = Applicant,
           
           @CurrentAmount =ScholarshipAward
    FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND Applicant NOT IN
              (
                  SELECT currenttotals.Applicant FROM currenttotals
              )
			  AND AwardingGroupId=@awardgroup
    ORDER BY ApplicantRanking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;

	 

    INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    )
 
    VALUES
    (   @awardgroup,
		 @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner,
		 @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;

DROP TABLE #scholarshiplooptable
--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY Applicant
--ORDER BY Total desc;

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunDeNormalizedAlgorithm4]'
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm4]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 4;
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1000;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT *
--FROM dbo.Algorithms
--WHERE AlgorithmId = @algorithmid;
--SELECT * FROM dbo.DenormalizedEntries
--WHERE AwardingGroupId =@awardgroup

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
 
DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);



WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
   SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );
     SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAward
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter AND AwardingGroupId=@awardgroup
    );
    ;WITH currenttotals
    AS (SELECT Applicant,
               SUM(AwardAmount)  Total
        FROM dbo.DenormalizedEntyResults
        WHERE AlgorithmId = @algorithmid
              AND MaxApplicants = @MaxApplicants
              AND MinimumAward = @MinimumAward
              AND MaximumAward = @MaximumAward
			  AND AwardingGroupId=@awardgroup
        GROUP BY Applicant
        HAVING SUM(AwardAmount) >0)
    SELECT TOP 1
           @CurrentScholarshipId = Scholarship,
           @CurrentWinner = Applicant,
           
           @CurrentAmount =ScholarshipAward
    FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND Applicant NOT IN
              (
                  SELECT currenttotals.Applicant FROM currenttotals
              )
			  AND AwardingGroupId=@awardgroup
    ORDER BY ApplicantRanking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;



     INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    )
    VALUES
    (   @awardgroup,
		 @algorithmid,     -- AlgorithmId - int
        @MaximumAward,                 -- MaximumAward - decimal(9, 2)
        @MinimumAward,                 -- MinimumAward - decimal(9, 2)
        @MaxApplicants,                -- MaxApplicants - int
        @CurrentScholarshipId,         -- ScholarshipApplicantId - int
        @CurrentWinner, @CurrentAmount -- Award - decimal(9, 2)
        );

    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable


--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY Applicant
--ORDER BY Total desc;

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunDeNormalizedAlgorithm5]'
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm5]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 5;
 --for testing
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1000;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

 

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
 
DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);

DECLARE @CurrentScholarshipApplicants VARCHAR(100)
DECLARE @CurrentSplitAmount DECIMAL(9,2)

WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );
     SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAward
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter AND AwardingGroupId=@awardgroup
    );
	 
    SET @CurrentScholarshipApplicants =
    (
        SELECT COUNT(Applicant	)
        FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND AwardingGroupId = @awardgroup
    );
	 
    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @CurrentScholarshipApplicants);

      INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    )
    SELECT  @awardgroup,
           @algorithmid,
           @MaximumAward,
           @MinimumAward,
           @MaxApplicants,
           Scholarship,
           Applicant,
           @CurrentSplitAmount
    FROM dbo.DenormalizedEntries
    WHERE Scholarship = @CurrentCounter
          AND AwardingGroupId = @awardgroup
    ORDER BY ApplicantRanking ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable


--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY Applicant
--ORDER BY Total desc;
 
EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunDeNormalizedAlgorithm6]'
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm6]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 6;
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1000;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT *
--FROM dbo.Algorithms
--WHERE AlgorithmId = @algorithmid;
--SELECT * FROM dbo.DenormalizedEntries
--WHERE AwardingGroupId =@awardgroup

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
 
DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);

DECLARE @CurrentScholarshipApplicants VARCHAR(100)
DECLARE @CurrentSplitAmount DECIMAL(9,2)

WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );
       SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAward
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter AND AwardingGroupId=@awardgroup
    );

    SET @CurrentScholarshipApplicants =
    (
        SELECT CASE
                   WHEN CountTotalTable.TotalApplicants > @MaxApplicants THEN
                       @MaxApplicants
                   ELSE
                       CountTotalTable.TotalApplicants
               END
        FROM
        (
            SELECT COUNT(Applicant) TotalApplicants
            FROM dbo.DenormalizedEntries
            WHERE Scholarship = @CurrentCounter
                  AND AwardingGroupId = @awardgroup
        ) CountTotalTable
    );


    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @CurrentScholarshipApplicants);

     INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    ) 
    SELECT OrderGroup.AwardGroup,
           OrderGroup.AlgorithmId,
           OrderGroup.MaximumAward,
           OrderGroup.MinimumAward,
           OrderGroup.MaxApplicants,
           OrderGroup.Scholarship,
           OrderGroup.Applicant,
           OrderGroup.CurrentAmount
    FROM
    (
        SELECT @awardgroup AwardGroup,
               @algorithmid AlgorithmId,
               @MaximumAward MaximumAward,
               @MinimumAward MinimumAward,
               @MaxApplicants MaxApplicants,
               Scholarship,
               Applicant,
               @CurrentSplitAmount CurrentAmount,
               ROW_NUMBER() OVER (ORDER BY ApplicantRanking) OrderId
        FROM dbo.DenormalizedEntries
        WHERE scholarship = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    ) OrderGroup
    WHERE OrderGroup.OrderId <= @MaxApplicants
    ORDER BY OrderGroup.OrderId ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable


--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY Applicant
--ORDER BY Total desc;

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunDeNormalizedAlgorithm7]'
GO
CREATE PROC [dbo].[RunDeNormalizedAlgorithm7]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
DECLARE @algorithmid INT = 7;
--DECLARE @awardgroup INT = 2;
--DECLARE @MaximumAward DECIMAL = 1000;
--DECLARE @MinimumAward DECIMAL = 500;
--DECLARE @MaxApplicants INT = 2;

--SELECT *
--FROM dbo.Algorithms
--WHERE AlgorithmId = @algorithmid;
--SELECT * FROM dbo.DenormalizedEntries
--WHERE AwardingGroupId =@awardgroup

DECLARE @CountOfScholarships INT =
        (
            SELECT COUNT(DISTINCT Scholarship)
            FROM dbo.DenormalizedEntries
            WHERE AwardingGroupId = @awardgroup
        );
 
DECLARE @ScholarshipCounter INT = 1;
DECLARE @CurrentWinner VARCHAR(100);
DECLARE @CurrentScholarshipId VARCHAR(255);
DECLARE @CurrentAmount DECIMAL(9, 2);
DECLARE @CurrentScholarshipApplicantId VARCHAR(100);



DELETE FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @algorithmid
      AND MaximumAward = @MaximumAward
      AND MinimumAward = @MinimumAward
      AND MaxApplicants = @MaxApplicants
      AND AwardingGroupId = @awardgroup;

CREATE TABLE #scholarshiplooptable
(
    [scholarship] VARCHAR(255),
    [Scholarshiporder] INT
);
INSERT INTO #scholarshiplooptable(
    scholarship,
    Scholarshiporder
)
 
SELECT Scholarship,
       ROW_NUMBER() OVER (ORDER BY UniqueScholarships.ScholarshipAward desc) ScholarshipId
FROM
(
    SELECT DISTINCT
           Scholarship,ScholarshipAward
    FROM dbo.DenormalizedEntries WHERE AwardingGroupId=@awardgroup
) UniqueScholarships
ORDER BY ScholarshipId;

DECLARE @CurrentCounter VARCHAR(255);

DECLARE @CurrentScholarshipApplicants int
DECLARE @CurrentSplitAmount DECIMAL(9,2)
DECLARE @applicantswithMinimumAmounts INT ;
DECLARE @peopletodivdeby INT;
WHILE @ScholarshipCounter <= @CountOfScholarships
BEGIN
    SET @CurrentCounter =
    (
        SELECT Scholarship
        FROM #scholarshiplooptable
        WHERE scholarshiporder = @ScholarshipCounter
    );
       SET @CurrentAmount =
    (
        SELECT TOP 1 ScholarshipAward
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter AND AwardingGroupId=@awardgroup
    );

	PRINT @CurrentAmount

    ---max number of people who can win
    SET @applicantswithMinimumAmounts =
    (
        SELECT CONVERT(INT, @CurrentAmount / @MinimumAward)
    );
	IF @applicantswithMinimumAmounts=0
	BEGIN
		SET @applicantswithMinimumAmounts=1
	end
    --total number of people in pool
    SET @CurrentScholarshipApplicants =
    (
        SELECT COUNT(Applicant) TotalApplicants
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    );

    ---set which ever is lower max number or total real number in pool
    SET @peopletodivdeby =
    (
        SELECT CASE
                   WHEN @CurrentScholarshipApplicants < @applicantswithMinimumAmounts THEN
                       @CurrentScholarshipApplicants
                   ELSE
                       @applicantswithMinimumAmounts
               END
    );

    -- divide people by current amount
    SET @CurrentSplitAmount = @CurrentAmount / CONVERT(DECIMAL(9, 2), @peopletodivdeby);


    INSERT INTO dbo.DenormalizedEntyResults
    (
        AwardingGroupId,
        AlgorithmId,
        MaximumAward,
        MinimumAward,
        MaxApplicants,
        Scholarship,
        Applicant,
        AwardAmount
    ) 
    SELECT OrderGroup.AwardGroup,
           OrderGroup.AlgorithmId,
           OrderGroup.MaximumAward,
           OrderGroup.MinimumAward,
           OrderGroup.MaxApplicants,
           OrderGroup.scholarship,
           OrderGroup.applicant,
           OrderGroup.CurrentAmount
    FROM
    (
        SELECT @awardgroup AwardGroup,
               @algorithmid AlgorithmId,
               @MaximumAward MaximumAward,
               @MinimumAward MinimumAward,
               @MaxApplicants MaxApplicants,
               scholarship,
               Applicant,
               @CurrentSplitAmount CurrentAmount,
               ROW_NUMBER() OVER (ORDER BY ApplicantRanking) OrderId
        FROM dbo.DenormalizedEntries
        WHERE Scholarship = @CurrentCounter
              AND AwardingGroupId = @awardgroup
    ) OrderGroup
    WHERE OrderGroup.OrderId <= @peopletodivdeby
    ORDER BY OrderGroup.OrderId ASC;
    PRINT 'Current Winner is applicant:';
    PRINT @CurrentWinner;
    PRINT 'For the scholarship';
    PRINT @CurrentScholarshipId;






    SET @ScholarshipCounter = @ScholarshipCounter + 1;
END;
DROP TABLE #scholarshiplooptable


--SELECT *
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup;

--SELECT Applicant,
--       SUM(AwardAmount) Total
--FROM dbo.DenormalizedEntyResults
--WHERE AlgorithmId = @algorithmid
--      AND MaxApplicants = @MaxApplicants
--      AND MinimumAward = @MinimumAward
--      AND MaximumAward = @MaximumAward AND AwardingGroupId=@awardgroup
--GROUP BY Applicant
--ORDER BY Total desc;

 

EXEC dbo.CreateDenormalizedEntryAnalysis @algorithmid ,     -- int
                                         @MaxApplicants ,   -- int
                                         @MinimumAward , -- decimal(9, 2)
                                         @MaximumAward , -- decimal(9, 2)
                                         @awardgroup       -- int
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RunAllDenormalizedAlgorithms]'
GO
CREATE PROC [dbo].[RunAllDenormalizedAlgorithms]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT on
EXEC dbo.RunDenormalizedAlgorithm1 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm2 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm3 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm4 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm5 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
				 
EXEC dbo.RunDenormalizedAlgorithm6 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
					   
EXEC dbo.RunDenormalizedAlgorithm7 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetAnalysis]'
GO
CREATE PROC [dbo].[GetAnalysis]
    @AwardingGroupId  INT,
    @MaximumAward     DECIMAL(9, 2),
    @MinimumAward     DECIMAL(9, 2),
    @MaxApplicants    INT,
    @RunAnalysisFirst BIT = 0
AS
    SET NOCOUNT ON;
    DECLARE @whichTable bit;
    SET @whichTable =
        (
            SELECT TOP 1
                   whichTable.IsNormalized
            FROM
                   (
                       SELECT TOP 1
                              '1' IsNormalized
                       FROM
                              dbo.NormalizedView
                       WHERE
                              AwardingGroupId = @AwardingGroupId
                       UNION
                       SELECT TOP 1
                              '0' IsNormalized
                       FROM
                              dbo.DenormalizedEntries
                       WHERE
                              AwardingGroupId = @AwardingGroupId
                       UNION
                       SELECT
                           -1 IsNormalized
                   ) whichTable
            ORDER BY
                   1 DESC
        );
    IF @whichTable = 1
        BEGIN
            IF @RunAnalysisFirst = 1
                BEGIN
                    EXEC dbo.RunAllAlgorithms
                        @AwardingGroupId, -- int
                        @MaximumAward,    -- decimal(9, 2)
                        @MinimumAward,    -- decimal(9, 2)
                        @MaxApplicants;   -- int

                END;
            SELECT
                *
            FROM
                dbo.ScholarshipAwardAnalysises
            WHERE
                AwardingGroupId = @AwardingGroupId
                AND MaxApplicants = @MaxApplicants
                AND MinimumAward = @MinimumAward
                AND MaximumAward = @MaximumAward
				ORDER BY RA1 DESC, RA2 DESC, RA3 DESC, UniqueAwardees DESC, MaximumAward DESC, NumberOfAwarded desc
				;
        END;
    IF @whichTable = 0
        BEGIN
            IF @RunAnalysisFirst = 1
                BEGIN
                    EXEC dbo.RunAllDenormalizedAlgorithms
                        @AwardingGroupId, -- int
                        @MaximumAward,    -- decimal(9, 2)
                        @MinimumAward,    -- decimal(9, 2)
                        @MaxApplicants;   -- int

                END;
            SELECT
                *
            FROM
                dbo.DenormalizedEntryAnalysises
            WHERE
                AwardingGroupId = @AwardingGroupId
                AND MaxApplicants = @MaxApplicants
                AND MinimumAward = @MinimumAward
                AND MaximumAward = @MaximumAward
				ORDER BY RA1 DESC, RA2 DESC, RA3 DESC, UniqueAwardees DESC, MaximumAward DESC, NumberOfAwarded desc
				;
        END;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CreateAwardingGroup]'
GO
CREATE PROC [dbo].[CreateAwardingGroup]
@AwardingGroupName VARCHAR(50)

AS
SET NOCOUNT ON 
INSERT INTO dbo.AwardingGroups
    (
        AwardingGroupName
    )
VALUES
    (
        @AwardingGroupName -- AwardingGroupName - varchar(50)
    )
	SELECT AwardingGroupId,
           AwardingGroupName FROM dbo.AwardingGroups
	WHERE AwardingGroupId =SCOPE_IDENTITY()
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InsertIntoDenormalizedEntry]'
GO
CREATE PROC [dbo].[InsertIntoDenormalizedEntry]
@AwardingGroupId  INT,
        @Scholarship  varchar(255),
       @ScholarshipAward decimal(9, 2),
        @Applicant  varchar(100),
        @ApplicantRanking  int

AS
SET NOCOUNT on
INSERT INTO dbo.DenormalizedEntries
    (
        AwardingGroupId,
        Scholarship,
        ScholarshipAward,
        Applicant,
        ApplicantRanking
    )
VALUES
    (
      @AwardingGroupId  ,
        @Scholarship ,
        @ScholarshipAward ,
        @Applicant,
        @ApplicantRanking 
    )
	SELECT * FROM dbo.DenormalizedEntries
	WHERE DenormalizedEntryId =SCOPE_IDENTITY()
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetScholarshipAwards]'
GO
CREATE PROC [dbo].[GetScholarshipAwards]
    @AlgorithmId INT,
    @AwardingGroupId INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT ON;
	
SELECT ScholarshipAwardId,
       AwardingGroupId,
	   ScholarshipName,
	   dbo.Applicants.FirstName,
	   LastName,
      AlgorithmId,
       Award
FROM dbo.ScholarshipAwards
INNER JOIN dbo.Applicants ON Applicants.ApplicantId = ScholarshipAwards.ApplicantId
INNER JOIN dbo.Scholarships ON Scholarships.ScholarshipId = ScholarshipAwards.ScholarshipId
WHERE AlgorithmId = @AlgorithmId
      AND AwardingGroupId = @AwardingGroupId
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
	  ORDER BY ScholarshipAwardId
	  
	  ;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetDeonormalizedScholarshipAwards]'
GO
CREATE PROC [dbo].[GetDeonormalizedScholarshipAwards]
    @AlgorithmId INT,
    @AwardingGroupId INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT ON;
	
SELECT * FROM dbo.DenormalizedEntyResults
WHERE AlgorithmId = @AlgorithmId
      AND AwardingGroupId = @AwardingGroupId
      AND MaxApplicants = @MaxApplicants
      AND MinimumAward = @MinimumAward
      AND MaximumAward = @MaximumAward
	  ORDER BY DenormalizedEntryResultId
	  
	  ;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InsertScholarship]'
GO
CREATE PROC [dbo].[InsertScholarship]
@ScholarshipName VARCHAR(255),
@ScholarshipAmount DECIMAL(9,2)

AS
SET NOCOUNT ON 

INSERT INTO dbo.Scholarships
(
    ScholarshipName,
    ScholarshipAmount
)
VALUES
(   @ScholarshipName,  -- ScholarshipName - varchar(255)
    @ScholarshipAmount -- ScholarshipAmount - decimal(9, 2)
    )

	SELECT * FROM dbo.Scholarships
	WHERE ScholarshipId =@@IDENTITY
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InsertApplicant]'
GO
CREATE PROC [dbo].[InsertApplicant]
@firstname VARCHAR(50),
@lastname VARCHAR(50)

AS
SET NOCOUNT ON 

INSERT INTO dbo.Applicants
(
    FirstName,
    LastName
)
VALUES
(   @firstname, -- FirstName - varchar(50)
    @lastname  -- LastName - varchar(50)
    )

	SELECT * FROM dbo.Applicants
	WHERE ApplicantId =@@IDENTITY
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InsertIntoApplicantRanking]'
GO
CREATE PROC [dbo].[InsertIntoApplicantRanking]
@awardingroupid INT,
@applicantid INT,
@ranking INT 

AS
SET NOCOUNT ON 

INSERT INTO dbo.ApplicantRankings
(
    AwardingGroupId,
    ApplicantId,
    Ranking
)
VALUES
(   @awardingroupid, -- AwardingGroupId - int
    @applicantid, -- ApplicantId - int
    @ranking  -- Ranking - int
    )

	SELECT * FROM dbo.ApplicantRankings
	WHERE ApplicantRankingId =@@IDENTITY
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InsertIntoScholarshipApplicants]'
GO
CREATE PROC [dbo].[InsertIntoScholarshipApplicants]
    @awardingroupid INT,
    @Scholarshipid INT,
    @applicantid INT
AS
SET NOCOUNT ON;

INSERT INTO dbo.ScholarshipApplicants
(
    AwardingGroupId,
    ScholarshipId,
    ApplicantId
)
VALUES
(   @awardingroupid, -- AwardingGroupId - int
    @Scholarshipid,  -- ScholarshipId - int
    @applicantid     -- ApplicantId - int
    );

SELECT *
FROM dbo.ScholarshipApplicants
WHERE ScholarshipApplicantId = @@IDENTITY;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[EnterNormalizedDataWithDeonromalizedRow]'
GO
CREATE PROC [dbo].[EnterNormalizedDataWithDeonromalizedRow]
    @AwardingGroupId INT,
    @scholarshipnname VARCHAR(255),
    @Scholarshipamount DECIMAL(9, 2),
    @firstname VARCHAR(50),
    @lastname VARCHAR(50),
    @applicantranking INT
AS
SET NOCOUNT ON;
DECLARE @applicantid INT;
DECLARE @applicantrankingid INT;
DECLARE @scholarshipid INT;

IF
(
    SELECT COUNT(*)
    FROM dbo.Applicants
    WHERE FirstName = @firstname
          AND LastName = @lastname
) > 0
BEGIN
    SET @applicantid =
    (
        SELECT ApplicantId
        FROM dbo.Applicants
        WHERE FirstName = @firstname
              AND LastName = @lastname
    );

END;
ELSE
BEGIN
    INSERT INTO dbo.Applicants
    (
        FirstName,
        LastName
    )
    VALUES
    (   @firstname, -- FirstName - varchar(50)
        @lastname   -- LastName - varchar(50)
        );
    SET @applicantid = SCOPE_IDENTITY();
END;
IF
(
    SELECT COUNT(*)
    FROM dbo.Scholarships
    WHERE ScholarshipName = @scholarshipnname
          AND ScholarshipAmount = @Scholarshipamount
) > 0
BEGIN
    SET @scholarshipid =
    (
        SELECT ScholarshipId
        FROM Scholarships
        WHERE ScholarshipName = @scholarshipnname
              AND ScholarshipAmount = @Scholarshipamount
    );
END;
ELSE
BEGIN
    INSERT INTO dbo.Scholarships
    (
        ScholarshipName,
        ScholarshipAmount
    )
    VALUES
    (   @scholarshipnname, -- ScholarshipName - varchar(255)
        @Scholarshipamount -- ScholarshipAmount - decimal(9, 2)
        );
    SET @scholarshipid = SCOPE_IDENTITY();
END;
IF
(
    SELECT COUNT(*)
    FROM dbo.ApplicantRankings
    WHERE AwardingGroupId = @AwardingGroupId
          AND ApplicantId = @applicantid
          AND ApplicantRankingId = @applicantranking
) > 0
BEGIN
    SET @applicantrankingid =
    (
        SELECT ApplicantRankingId
        FROM dbo.ApplicantRankings
        WHERE AwardingGroupId = @AwardingGroupId
              AND ApplicantId = @applicantid
              AND ApplicantRankingId = @applicantranking
    );
END;
ELSE
BEGIN
    INSERT INTO dbo.ApplicantRankings
    (
        AwardingGroupId,
        ApplicantId,
        Ranking
    )
    VALUES
    (   @AwardingGroupId, -- AwardingGroupId - int
        @applicantid,     -- ApplicantId - int
        @applicantranking -- Ranking - int
        );
    SET @applicantrankingid = SCOPE_IDENTITY();
END;

IF (SELECT COUNT(*) FROM dbo.ScholarshipApplicants
WHERE AwardingGroupId =@AwardingGroupId AND ScholarshipId=@scholarshipid
AND ApplicantId=@applicantid) <1
BEGIN
	INSERT INTO dbo.ScholarshipApplicants
	(
	    AwardingGroupId,
	    ScholarshipId,
	    ApplicantId
	)
	VALUES
	(   @AwardingGroupId, -- AwardingGroupId - int
	    @scholarshipid, -- ScholarshipId - int
	    @applicantid  -- ApplicantId - int
	    )

end
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FixApplicantRanking]'
GO
CREATE PROC [dbo].[FixApplicantRanking] @awardinggroup INT
AS
    SET NOCOUNT ON;
    CREATE TABLE #temptable
        (
            [ApplicantRanking] INT,
            [RealRankingID]    BIGINT
        );
    WITH applicants
    AS (   SELECT DISTINCT
                  ApplicantRanking,
                  AwardingGroupId
           FROM
                  dbo.DenormalizedEntries
           WHERE
                  AwardingGroupId = @awardinggroup),
         realrankings
    AS (   SELECT
               applicants.ApplicantRanking,
               ROW_NUMBER() OVER (ORDER BY
                                      applicants.ApplicantRanking
                                 ) RealRankingID
           FROM
               applicants)
    INSERT INTO #temptable
                SELECT
                        applicants.ApplicantRanking,
                        realrankings.RealRankingID
                FROM
                        applicants
                    INNER JOIN
                        realrankings
                            ON realrankings.ApplicantRanking = applicants.ApplicantRanking
                WHERE
                        applicants.AwardingGroupId = @awardinggroup
                        AND applicants.ApplicantRanking = realrankings.ApplicantRanking;

    DECLARE @count INT =
                (
                    SELECT
                        COUNT(*)
                    FROM
                        #temptable
                );
    DECLARE @counter INT = 1;
    DECLARE @currentId INT;
    DECLARE @realid INT;
    WHILE (@counter < @count)
        BEGIN
            PRINT @counter;

            SET @realid =
                (
                    SELECT
                        RealRankingID
                    FROM
                        #temptable
                    WHERE
                        RealRankingID = @counter
                );
            SET @currentId =
                (
                    SELECT
                        ApplicantRanking
                    FROM
                        #temptable
                    WHERE
                        RealRankingID = @counter
                );


            UPDATE
                dbo.DenormalizedEntries
            SET
                ApplicantRanking = @realid
            WHERE
                AwardingGroupId = @awardinggroup
                AND ApplicantRanking = @currentId;
            SET @counter = @counter + 1;
        END;

    DROP TABLE #temptable;

--TRUNCATE TABLE dbo.DenormalizedEntryAnalysises

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
PRINT N'Adding foreign keys to [dbo].[DenormalizedEntyResults]'
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [FK_DenormalizedEntyResults_Algorithms] FOREIGN KEY ([AlgorithmId]) REFERENCES [dbo].[Algorithms] ([AlgorithmId])
GO
ALTER TABLE [dbo].[DenormalizedEntyResults] ADD CONSTRAINT [FK_DenormalizedEntyResults_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
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
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_Applicants] FOREIGN KEY ([ApplicantId]) REFERENCES [dbo].[Applicants] ([ApplicantId])
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO
ALTER TABLE [dbo].[ScholarshipAwards] ADD CONSTRAINT [FK_ScholarshipAwards_Scholarships] FOREIGN KEY ([ScholarshipId]) REFERENCES [dbo].[Scholarships] ([ScholarshipId])
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
PRINT N'Adding foreign keys to [dbo].[DenormalizedEntries]'
GO
ALTER TABLE [dbo].[DenormalizedEntries] ADD CONSTRAINT [FK_DenormalizedEntries_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DenormalizedEntryAnalysises]'
GO
ALTER TABLE [dbo].[DenormalizedEntryAnalysises] ADD CONSTRAINT [FK_DenormalizedEntryAnalysises_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
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

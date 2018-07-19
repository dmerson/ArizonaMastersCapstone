SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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

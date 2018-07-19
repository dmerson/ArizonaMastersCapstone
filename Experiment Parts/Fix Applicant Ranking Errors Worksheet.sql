--SELECT * FROM dbo.DenormalizedEntyResults
--WHERE AwardingGroupId=23
DECLARE @awardinggroup INT = 35;
SELECT 'BEFORE'
;WITH applicants
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
SELECT
        *
FROM
        applicants
    INNER JOIN
        realrankings
            ON realrankings.ApplicantRanking = applicants.ApplicantRanking;



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
--UPDATE
--    dbo.DenormalizedEntries
--SET
--    DenormalizedEntries.ApplicantRanking = realrankings.RealRankingID
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
	 --SELECT @currentId,@realid

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
SELECT 'AFTER';
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
SELECT
        *
FROM
        applicants
    INNER JOIN
        realrankings
            ON realrankings.ApplicantRanking = applicants.ApplicantRanking;
--SELECT
--    *
--FROM
--    dbo.DenormalizedEntries
--WHERE
--    AwardingGroupId = @awardinggroup;
--SELECT * FROM dbo.DenormalizedEntries
--WHERE AwardingGroupId =@wardinggroup

--TRUNCATE TABLE dbo.DenormalizedEntries
--TRUNCATE TABLE dbo.DenormalizedEntyResults
--TRUNCATE TABLE dbo.DenormalizedEntryAnalysises


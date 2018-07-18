DECLARE @whichshownid INT = 3;
WITH sourcesin25
AS (   SELECT  DISTINCT
               Scholarships.SourceId,
               SourceName
       FROM
               dbo.ScholarshipPackages
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
           INNER JOIN
               dbo.Sources
                   ON Sources.SourceID = Scholarships.SourceId
           INNER JOIN
               dbo.DenormalizedApplications
                   ON DenormalizedApplications.ScholarshipPackageId = ScholarshipPackages.ScholarshipPackageId
       WHERE
               IsCollege = 1
               AND ScholarshipAwardTypeId = 25),
     anonymousawardinggroups
AS (   SELECT
           sourcesin25.SourceId,
           sourcesin25.SourceName,
           ROW_NUMBER() OVER (ORDER BY
                                  sourcesin25.SourceId
                             ) ShownId
       FROM
           sourcesin25),
     scholarships25
AS (   SELECT
               ScholarshipPackageId,
               TotalAmountAvailable,
               ROW_NUMBER() OVER (ORDER BY
                                      ScholarshipPackageId
                                 ) ScholarshipName
       FROM
               dbo.ScholarshipPackages
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
           INNER JOIN
               dbo.Sources
                   ON Sources.SourceID = Scholarships.SourceId
           INNER JOIN
               anonymousawardinggroups
                   ON anonymousawardinggroups.SourceId = Sources.SourceID
       WHERE
               anonymousawardinggroups.ShownId = @whichshownid
               AND ScholarshipAwardTypeId = 25),
     usersforscholarship
AS (   SELECT  DISTINCT
               EMPLID
       FROM
               dbo.ScholarshipPackages
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
           INNER JOIN
               dbo.Sources
                   ON Sources.SourceID = Scholarships.SourceId
           INNER JOIN
               anonymousawardinggroups
                   ON anonymousawardinggroups.SourceId = Sources.SourceID
           INNER JOIN
               dbo.DenormalizedApplications
                   ON DenormalizedApplications.ScholarshipPackageId = ScholarshipPackages.ScholarshipPackageId
       WHERE
               anonymousawardinggroups.ShownId = @whichshownid
       
               AND ScholarshipAwardTypeId = 25),
     userranking
AS (   SELECT
           usersforscholarship.EMPLID,
           ROW_NUMBER() OVER (ORDER BY
                                  usersforscholarship.EMPLID
                             ) applicantnumber
       FROM
           usersforscholarship),
     userscholarships
AS (   SELECT  DISTINCT
               DenormalizedApplications.EMPLID,
               userranking.applicantnumber,
               DenormalizedApplications.ScholarshipPackageId
       FROM
               dbo.ScholarshipPackages
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
           INNER JOIN
               dbo.Sources
                   ON Sources.SourceID = Scholarships.SourceId
           INNER JOIN
               anonymousawardinggroups
                   ON anonymousawardinggroups.SourceId = Sources.SourceID
           INNER JOIN
               dbo.DenormalizedApplications
                   ON DenormalizedApplications.ScholarshipPackageId = ScholarshipPackages.ScholarshipPackageId
           INNER JOIN
               userranking
                   ON userranking.EMPLID = DenormalizedApplications.EMPLID
       WHERE
               anonymousawardinggroups.ShownId = @whichshownid
               AND ScholarshipAwardTypeId = 25),
     userrankingsbase
AS (   SELECT  DISTINCT
               userscholarships.applicantnumber,
               EPM_CURFUT_PERSON.EMPLID,
               CASE
                   WHEN CUM_GPA = 0
                       THEN
                       .5
                   ELSE
                       CUM_GPA / 4.0
               END GPARank,
               CASE
                   WHEN FED_YEAR_COA > 0.0
                       THEN
                       FED_UNMET_NEED / FED_YEAR_COA
                   ELSE
                       .5
               END NeedRanking
       FROM
               userscholarships
           LEFT JOIN
               EPM_Extract.dbo.EPM_CURFUT_PERSON
                   ON EPM_CURFUT_PERSON.EMPLID = userscholarships.EMPLID
           LEFT JOIN
               EPM_Extract.dbo.EPM_FA_AWARD
                   ON EPM_FA_AWARD.EMPLID = EPM_CURFUT_PERSON.EMPLID
       WHERE
               STRM = '2181'
               AND AID_YEAR = '2018'),
     userrankings
AS (   SELECT
           userrankingsbase.applicantnumber,
           userrankingsbase.GPARank,
           userrankingsbase.NeedRanking,
           (userrankingsbase.GPARank + userrankingsbase.NeedRanking) / 2.0 TotalRanking
       FROM
           userrankingsbase),
     userrankingsfinals
AS (   SELECT
           userrankings.applicantnumber,
           ROW_NUMBER() OVER (ORDER BY
                                  userrankings.TotalRanking DESC
                             ) ApplicantRanking,
           userrankings.TotalRanking
       FROM
           userrankings)
SELECT
        scholarships25.ScholarshipName,
        scholarships25.TotalAmountAvailable,
        userrankingsbase.applicantnumber,
        ApplicantRanking
 
FROM
        userscholarships
    LEFT JOIN
        userrankingsbase
            ON userrankingsbase.applicantnumber = userscholarships.applicantnumber
               AND userrankingsbase.applicantnumber = userscholarships.applicantnumber
    INNER JOIN
        scholarships25
            ON scholarships25.ScholarshipPackageId = userscholarships.ScholarshipPackageId
    INNER JOIN
        userrankingsfinals
            ON userrankingsfinals.applicantnumber = userrankingsbase.applicantnumber
WHERE
        scholarships25.TotalAmountAvailable NOT IN ('0','')
ORDER BY
        CONVERT(DECIMAL(9,2),scholarships25.TotalAmountAvailable) DESC,
        scholarships25.ScholarshipName,
        ApplicantRanking DESC;

DECLARE	 @sourceid INT
DECLARE @AwardYearId INT 

SET @sourceid =3
SET @AwardYearId =24

;WITH rawdata
AS (   SELECT
               ScholarshipName,
               DenormalizedApplications.ScholarshipPackageId,
               TotalAmountAvailable,
               EMPLID,
               ROW_NUMBER() OVER (PARTITION BY
                                      DenormalizedApplications.ScholarshipPackageId
                                  ORDER BY
                                      EMPLID
                                 ) Ranking
       FROM
               dbo.ScholarshipPackages
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
           INNER JOIN
               dbo.DenormalizedApplications
                   ON DenormalizedApplications.ScholarshipPackageId = ScholarshipPackages.ScholarshipPackageId
       WHERE
               SourceId = @sourceid
               AND ScholarshipAwardTypeId = @AwardYearId
               AND TotalAmountAvailable NOT IN (
                                                   '', '0'
                                               )),
     STUDENTIDS
AS (   SELECT
           BaseEMPLIDS.EMPLID,
           ROW_NUMBER() OVER (ORDER BY
                                  BaseEMPLIDS.EMPLID
                             ) StudentId
       FROM
           (
               SELECT  DISTINCT
                       EMPLID
               FROM
                       dbo.ScholarshipPackages
                   INNER JOIN
                       dbo.Scholarships
                           ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
                   INNER JOIN
                       dbo.DenormalizedApplications
                           ON DenormalizedApplications.ScholarshipPackageId = ScholarshipPackages.ScholarshipPackageId
               WHERE
                       SourceId = @sourceid
                       AND ScholarshipAwardTypeId = @AwardYearId
           ) BaseEMPLIDS ),
     Scholarshipids
AS (   SELECT
               ScholarshipPackages.ScholarshipPackageId,
               ROW_NUMBER() OVER (ORDER BY
                                      ScholarshipPackageId
                                 ) ScholarshipId
       FROM
               dbo.ScholarshipPackages
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
       WHERE
               SourceId = @sourceid
               AND ScholarshipAwardTypeId = @AwardYearId),

			   results AS (
SELECT  DISTINCT
        LEN(rawdata.TotalAmountAvailable) Lt,
        rawdata.ScholarshipName           Scholarship,
        Scholarshipids.ScholarshipId,
        rawdata.TotalAmountAvailable,
        rawdata.EMPLID,
        STUDENTIDS.StudentId
FROM
        rawdata
    INNER JOIN
        STUDENTIDS
            ON STUDENTIDS.EMPLID = rawdata.EMPLID
    INNER JOIN
        Scholarshipids
            ON Scholarshipids.ScholarshipPackageId = rawdata.ScholarshipPackageId)

			SELECT  
                   'SC' + CONVERT(VARCHAR(4),results.ScholarshipId) ScholarshipId,
                   results.TotalAmountAvailable,
                   --results.EMPLID,
                  'Applicant'+ CONVERT(VARCHAR(4),results.StudentId),
				   results.StudentId StudentRanking FROM results
ORDER BY
        Lt DESC,
         TotalAmountAvailable DESC,
         ScholarshipId,
		 StudentId;
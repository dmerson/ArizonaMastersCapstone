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
     TotalApplications
AS (   SELECT
               anonymousawardinggroups.ShownId,
               COUNT(DISTINCT DenormalizedApplicationId) TotalApplicationsForAwardingGroup
       FROM
               anonymousawardinggroups
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.SourceId = anonymousawardinggroups.SourceId
           INNER JOIN
               dbo.ScholarshipPackages
                   ON ScholarshipPackages.Scholarshipid = Scholarships.ScholarshipId
           INNER JOIN
               dbo.DenormalizedApplications
                   ON DenormalizedApplications.ScholarshipPackageId = ScholarshipPackages.ScholarshipPackageId
       WHERE
               ScholarshipAwardTypeId = 25
       GROUP BY
               anonymousawardinggroups.ShownId),
     DISTINCTApplicants
AS (   SELECT
               anonymousawardinggroups.ShownId,
               COUNT(DISTINCT DenormalizedApplications.EMPLID) DistinctApplicantsForGroup
       FROM
               anonymousawardinggroups
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.SourceId = anonymousawardinggroups.SourceId
           INNER JOIN
               dbo.ScholarshipPackages
                   ON ScholarshipPackages.Scholarshipid = Scholarships.ScholarshipId
           INNER JOIN
               dbo.DenormalizedApplications
                   ON DenormalizedApplications.ScholarshipPackageId = ScholarshipPackages.ScholarshipPackageId
				   INNER JOIN dbo.PersonalInformation ON PersonalInformation.EMPLID = DenormalizedApplications.EMPLID
       WHERE
               ScholarshipAwardTypeId = 25
       GROUP BY
               anonymousawardinggroups.ShownId)
SELECT
    TotalApplications.ShownId,
    TotalApplications.TotalApplicationsForAwardingGroup,
  
    DISTINCTApplicants.DistinctApplicantsForGroup
FROM
    TotalApplications
	INNER JOIN DISTINCTApplicants ON DISTINCTApplicants.ShownId = TotalApplications.ShownId
ORDER BY
    TotalApplications.ShownId;
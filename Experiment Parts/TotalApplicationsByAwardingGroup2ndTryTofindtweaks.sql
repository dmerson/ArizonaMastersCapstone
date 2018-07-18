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
           INNER JOIN
               dbo.PersonalInformation
                   ON PersonalInformation.EMPLID = DenormalizedApplications.EMPLID
       WHERE
               ScholarshipAwardTypeId = 25
       GROUP BY
               anonymousawardinggroups.ShownId),
     distinctAwards
AS (   SELECT
               anonymousawardinggroups.ShownId,
               COUNT(DISTINCT ApprovedAllocationId) DistinctAwards
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
           INNER JOIN
               dbo.ApprovedAllocations
                   ON ApprovedAllocations.ScholarshipPackageId = DenormalizedApplications.ScholarshipPackageId
       WHERE
               ScholarshipAwardTypeId = 25
               AND Award > 0
       GROUP BY
               anonymousawardinggroups.ShownId),
     distinctawardees
AS (   SELECT
               anonymousawardinggroups.ShownId,
               COUNT(DISTINCT StudentEMPLID) DistinctAwardees
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
           INNER JOIN
               dbo.ApprovedAllocations
                   ON ApprovedAllocations.ScholarshipPackageId = DenormalizedApplications.ScholarshipPackageId
       WHERE
               ScholarshipAwardTypeId = 25
               AND Award > 0
       GROUP BY
               anonymousawardinggroups.ShownId),
     packagestoshownid
AS (   SELECT  DISTINCT
               anonymousawardinggroups.ShownId,
               ScholarshipPackageId
       FROM
               dbo.ScholarshipPackages
           INNER JOIN
               dbo.Scholarships
                   ON Scholarships.ScholarshipId = ScholarshipPackages.Scholarshipid
           INNER JOIN
               anonymousawardinggroups
                   ON anonymousawardinggroups.SourceId = Scholarships.SourceId
				   WHERE ScholarshipAwardTypeId=25
				   ),
     usertotalawards
AS (   SELECT
               packagestoshownid.ShownId,
               StudentEMPLID,
               SUM(Award) TotalAwards
       FROM
               dbo.ApprovedAllocations
           INNER JOIN
               packagestoshownid
                   ON packagestoshownid.ScholarshipPackageId = ApprovedAllocations.ScholarshipPackageId
				    WHERE Award > 0
       GROUP BY
               packagestoshownid.ShownId,
               StudentEMPLID),
     minmax
AS (   SELECT
           usertotalawards.ShownId,
           MAX(usertotalawards.TotalAwards) MaxAward,
           MIN(usertotalawards.TotalAwards) MinAward
       FROM
           usertotalawards
       GROUP BY
           usertotalawards.ShownId)

--SELECT * FROM usertotalawards ORDER BY usertotalawards.TotalAwards desc
SELECT
        TotalApplications.ShownId,
        TotalApplications.TotalApplicationsForAwardingGroup,
        DISTINCTApplicants.DistinctApplicantsForGroup,
        ISNULL(distinctAwards.DistinctAwards, 0)     DistinctAwards,
        ISNULL(distinctawardees.DistinctAwardees, 0) DistinctAwardees,
        ISNULL(minmax.MaxAward, 0)                   MaxAward,
        ISNULL(minmax.MinAward, 0)                   MinAward
FROM
        TotalApplications
    INNER JOIN
        DISTINCTApplicants
            ON DISTINCTApplicants.ShownId = TotalApplications.ShownId
    LEFT JOIN
        distinctAwards
            ON distinctAwards.ShownId = TotalApplications.ShownId
    LEFT JOIN
        distinctawardees
            ON distinctawardees.ShownId = TotalApplications.ShownId
    LEFT JOIN
        minmax
            ON minmax.ShownId = TotalApplications.ShownId
ORDER BY
        TotalApplications.ShownId;

--SELECT * FROM dbo.ApprovedAllocations
--WHERE StudentEMPLID ='23110683'
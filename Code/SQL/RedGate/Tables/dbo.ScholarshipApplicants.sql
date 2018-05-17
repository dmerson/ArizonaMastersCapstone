CREATE TABLE [dbo].[ScholarshipApplicants]
(
[ScholarshipApplicantId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupId] [int] NOT NULL,
[ScholarshipId] [int] NOT NULL,
[ApplicantId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [PK_ScholarshipApplicants] PRIMARY KEY CLUSTERED  ([ScholarshipApplicantId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [FK_ScholarshipApplicants_Applicants] FOREIGN KEY ([ApplicantId]) REFERENCES [dbo].[Applicants] ([ApplicantId])
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [FK_ScholarshipApplicants_AwardingGroups] FOREIGN KEY ([AwardingGroupId]) REFERENCES [dbo].[AwardingGroups] ([AwardingGroupId])
GO
ALTER TABLE [dbo].[ScholarshipApplicants] ADD CONSTRAINT [FK_ScholarshipApplicants_Scholarships] FOREIGN KEY ([ScholarshipId]) REFERENCES [dbo].[Scholarships] ([ScholarshipId])
GO

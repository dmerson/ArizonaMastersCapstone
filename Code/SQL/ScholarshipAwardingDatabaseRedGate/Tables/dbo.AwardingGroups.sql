CREATE TABLE [dbo].[AwardingGroups]
(
[AwardingGroupId] [int] NOT NULL IDENTITY(1, 1),
[AwardingGroupName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AwardingGroups] ADD CONSTRAINT [PK_AwardingGroups] PRIMARY KEY CLUSTERED  ([AwardingGroupId]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[CreateAwardinGroup]
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

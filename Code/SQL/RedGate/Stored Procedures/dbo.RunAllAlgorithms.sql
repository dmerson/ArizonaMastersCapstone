SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[RunAllAlgorithms]
    @AwardingGroupId INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
SET NOCOUNT ON;
DECLARE @whichTable CHAR(1);
SET @whichTable =
(
    SELECT TOP 1
           *
    FROM
    (
        SELECT TOP 1
               '1' IsNormalized
        FROM dbo.NormalizedView
        WHERE AwardingGroupId = @AwardingGroupId
        UNION
        SELECT TOP 1
               '0' IsNormalized
        FROM dbo.DenormalizedEntries
        WHERE AwardingGroupId = @AwardingGroupId
        UNION
        SELECT -1 IsNormalized
    ) whichTable
    ORDER BY 1 DESC
);
IF @whichTable = 1
BEGIN
    EXEC dbo.RunAlgorithm1 @AwardingGroupId,
                           @MaximumAward,
                           @MinimumAward,
                           @MaxApplicants;
    EXEC dbo.RunAlgorithm2 @AwardingGroupId,
                           @MaximumAward,
                           @MinimumAward,
                           @MaxApplicants;
    EXEC dbo.RunAlgorithm3 @AwardingGroupId,
                           @MaximumAward,
                           @MinimumAward,
                           @MaxApplicants;
    EXEC dbo.RunAlgorithm4 @AwardingGroupId,
                           @MaximumAward,
                           @MinimumAward,
                           @MaxApplicants;
    EXEC dbo.RunAlgorithm5 @AwardingGroupId,
                           @MaximumAward,
                           @MinimumAward,
                           @MaxApplicants;
    EXEC dbo.RunAlgorithm6 @AwardingGroupId,
                           @MaximumAward,
                           @MinimumAward,
                           @MaxApplicants;
    EXEC dbo.RunAlgorithm7 @AwardingGroupId,
                           @MaximumAward,
                           @MinimumAward,
                           @MaxApplicants;

END;
IF @whichTable = 0
BEGIN
    EXEC dbo.RunAllDenormalizedAlgorithms @AwardingGroupId,    -- int
                                          @MaximumAward,  -- decimal(9, 2)
                                          @MinimumAward,  -- decimal(9, 2)
                                          @MaxApplicants; -- int

END;
GO

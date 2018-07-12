SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetAnalysis] 
	@AwardingGroupId INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT,
	@RunAnalysisFirst BIT=0
AS
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
IF @whichTable =1
BEGIN
	IF @RunAnalysisFirst =1
	BEGIN
		EXEC dbo.RunAllAlgorithms @AwardingGroupId ,      -- int
		                          @MaximumAward , -- decimal(9, 2)
		                          @MinimumAward , -- decimal(9, 2)
		                          @MaxApplicants     -- int
		
	end
	SELECT * FROM dbo.ScholarshipAwardAnalysises
	WHERE AwardingGroupId =@AwardingGroupId
END
IF @whichTable =0
BEGIN
	IF @RunAnalysisFirst =1
	BEGIN
		EXEC dbo.RunAllDenormalizedAlgorithms @AwardingGroupId,      -- int
		                                      @MaximumAward , -- decimal(9, 2)
		                                      @MinimumAward , -- decimal(9, 2)
		                                      @MaxApplicants     -- int
		
	end
	SELECT * FROM dbo.DenormalizedEntryAnalysises
	WHERE AwardingGroupId =@AwardingGroupId
end
GO

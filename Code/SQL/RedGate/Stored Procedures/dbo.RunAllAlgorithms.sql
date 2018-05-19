SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[RunAllAlgorithms]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
EXEC dbo.RunAlgorithm1 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm2 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm3 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm4 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm5 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm6 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunAlgorithm7 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;

GO

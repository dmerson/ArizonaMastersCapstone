SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[RunAllDenormalizedAlgorithms]
    @awardgroup INT,
    @MaximumAward DECIMAL(9, 2),
    @MinimumAward DECIMAL(9, 2),
    @MaxApplicants INT
AS
EXEC dbo.RunDenormalizedAlgorithm1 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm2 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm3 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm4 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm5 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm6 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;
EXEC dbo.RunDenormalizedAlgorithm7 @awardgroup,
                       @MaximumAward,
                       @MinimumAward,
                       @MaxApplicants;

GO

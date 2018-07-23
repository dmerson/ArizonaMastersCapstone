--with this database this is where the data is
DECLARE @counter INT = 18;
DECLARE @maxcounter INT = 34;
DECLARE @MaximumAward DECIMAL(9, 2) = 800;
DECLARE @MinimumAward DECIMAL(9, 2) = 250;
DECLARE @MaxApplicants INT = 10;
WHILE @counter <= @maxcounter
BEGIN
    PRINT @counter;

    EXEC dbo.GetAnalysis @counter, @MaximumAward, @MinimumAward, @MaxApplicants, 1;

    SET @counter = @counter + 1;
END;



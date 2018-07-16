SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[InsertScholarship]
@ScholarshipName VARCHAR(255),
@ScholarshipAmount DECIMAL(9,2)

AS
SET NOCOUNT ON 

INSERT INTO dbo.Scholarships
(
    ScholarshipName,
    ScholarshipAmount
)
VALUES
(   @ScholarshipName,  -- ScholarshipName - varchar(255)
    @ScholarshipAmount -- ScholarshipAmount - decimal(9, 2)
    )

	SELECT * FROM dbo.Scholarships
	WHERE ScholarshipId =@@IDENTITY
GO

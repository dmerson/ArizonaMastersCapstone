SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[InsertApplicant]
@firstname VARCHAR(50),
@lastname VARCHAR(50)

AS
SET NOCOUNT ON 

INSERT INTO dbo.Applicants
(
    FirstName,
    LastName
)
VALUES
(   @firstname, -- FirstName - varchar(50)
    @lastname  -- LastName - varchar(50)
    )

	SELECT * FROM dbo.Applicants
	WHERE ApplicantId =@@IDENTITY
GO

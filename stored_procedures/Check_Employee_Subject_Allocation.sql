IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Check_Employee_Subject_Allocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Check_Employee_Subject_Allocation]  
    @Employee_Id BIGINT,
    @Semster_Subject_Id BIGINT
AS              
BEGIN    
    SET NOCOUNT ON;

    DECLARE @RecordCount INT;

    -- Store the count result in @RecordCount
    SELECT @RecordCount = COUNT(*)
    FROM Tbl_Emp_Intake_Program_Course_Mapping
    WHERE Employee_Id = @Employee_Id
      AND Subject_Id = @Semster_Subject_Id
      AND Del_status=0;

    -- If count is 0, return -1; otherwise, return 1
    IF @RecordCount = 0
        SELECT -1 AS ReturnValue;
    ELSE
        SELECT 1 AS ReturnValue;
END
    ')
END
ELSE
BEGIN
EXEC('ALTER PROCEDURE [dbo].[Check_Employee_Subject_Allocation]  
    @Employee_Id BIGINT,
    @Semster_Subject_Id BIGINT
AS              
BEGIN    
    SET NOCOUNT ON;

    DECLARE @RecordCount INT;

    -- Store the count result in @RecordCount
    SELECT @RecordCount = COUNT(*)
    FROM Tbl_Emp_Intake_Program_Course_Mapping
    WHERE Employee_Id = @Employee_Id
      AND Subject_Id = @Semster_Subject_Id
	  AND Del_status=0;

    -- If count is 0, return -1; otherwise, return 1
    IF @RecordCount = 0
        SELECT -1 AS ReturnValue;
    ELSE
        SELECT 1 AS ReturnValue;
END


')
END

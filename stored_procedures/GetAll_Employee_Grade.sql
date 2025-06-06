-- Create procedure GetAll_Employee_Grade if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetAll_Employee_Grade]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[GetAll_Employee_Grade]

AS

BEGIN

    SELECT  Emp_Grade_Id,Emp_Grade_Name
  FROM [dbo].[Tbl_Employee_Grade] where Emp_Grade_Status=0;
            
END
    ')
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Employee_Mail_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Proc_Get_Employee_Mail_By_Id](@Emp_ID int)

AS

BEGIN

    SELECT * from Tbl_Employee Where Employee_Id=@Emp_ID
END
    ')
END

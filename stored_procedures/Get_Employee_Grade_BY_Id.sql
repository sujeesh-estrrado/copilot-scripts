-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Employee_Grade_BY_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_Employee_Grade_BY_Id](@Emp_Grade_Id bigint)

AS

BEGIN

    select Emp_Grade_Id,Emp_Grade_Name
    from Tbl_Employee_Grade
    where Emp_Grade_Status=0 and Emp_Grade_Id=@Emp_Grade_Id
END
    ')
END;
GO

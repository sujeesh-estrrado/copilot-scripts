IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Employee_Sal]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Employee_Sal]
(@Emp_Id bigint)
AS
BEGIN
DELETE FROM Tbl_Employee_Salary  
  
WHERE Emp_Id=@Emp_Id  
  
END
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Sal_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employee_Sal_By_Employee_Id]  
(@Emp_Id bigint)    
    
AS    
    
BEGIN    
    
SELECT * from dbo.Tbl_Employee_Salary where Emp_Id=@Emp_Id    
    
end

	');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Emp_Salary_By_EmpID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Emp_Salary_By_EmpID]          
(@Emp_Id bigint)              
              
AS                      
            
BEGIN     
SELECT 
*     
FROM         Tbl_Employee_Salary    
WHERE Emp_Id=@Emp_Id    
END
');
END;

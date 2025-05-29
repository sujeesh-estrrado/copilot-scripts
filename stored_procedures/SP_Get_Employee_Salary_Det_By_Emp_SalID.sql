IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Salary_Det_By_Emp_SalID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employee_Salary_Det_By_Emp_SalID]
(@Employee_Salary_Id bigint)  
  
AS  
  
BEGIN  
  
SELECT * from dbo.Tbl_Employee_Salary_Details where Employee_Salary_Id=@Employee_Salary_Id  
  
end

	');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Salary_Verified_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Salary_Verified_By_ID](@Sal_Verified_id bigint)  
  
AS  
Set NoCount ON  
BEGIN  
  
 SELECT     dbo.Tbl_Employee.Employee_FName + dbo.Tbl_Employee.Employee_LName AS Employee, dbo.Tbl_Salary_Verified.Sal_Verified_id,   
                      dbo.Tbl_Salary_Verified.Sal_Employee_Id, dbo.Tbl_Salary_Verified.Sal_Month_Year, dbo.Tbl_Salary_Verified.Sal_Verified_Date,dbo.Tbl_Employee.Employee_Type  
FROM         dbo.Tbl_Salary_Verified INNER JOIN  
                      dbo.Tbl_Employee ON dbo.Tbl_Salary_Verified.Sal_Employee_Id = dbo.Tbl_Employee.Employee_Id  
WHERE     (dbo.Tbl_Salary_Verified.Sal_Verified_Status = 0) AND (dbo.Tbl_Employee.Employee_Status = 0)  
  
AND  Tbl_Salary_Verified.Sal_Verified_id=@Sal_Verified_id  
  
END

						 ');
END;

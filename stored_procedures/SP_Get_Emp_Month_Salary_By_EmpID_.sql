IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Emp_Month_Salary_By_EmpID_]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Emp_Month_Salary_By_EmpID_]       
(@Emp_Id bigint)                
                
AS                        
              
BEGIN       
SELECT Distinct ES.Employee_Salary_Id,
ES.Basic_Salary,
ES.Date,
ES.Gross_Salary,
SH.Salary_Head_Name,
ESD.Grade_Sal_Value

   


FROM         Tbl_Employee_Salary  ES  
Inner join   Tbl_Employee_Salary_Details ESD on ESD.Employee_Salary_Id=ES.Employee_Salary_Id
inner join dbo.Tbl_Salary_Head SH on SH.Salary_Head_Id=ESD.Salary_Head_Id
WHERE Emp_Id=@Emp_Id      
END');
END;

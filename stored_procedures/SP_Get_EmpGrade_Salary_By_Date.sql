IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_EmpGrade_Salary_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_EmpGrade_Salary_By_Date]        
(@Grade_Id bigint, @Emp_Id bigint,@Date varchar(15))            
            
AS            
Set NoCount ON        
          
BEGIN   
SELECT es.Employee_Salary_Id,es.Grade_Id,es.Emp_Id,es.Basic_salary,es.Date,es.Gross_Salary,esd.Salary_Head_Id,esd.Grade_sal_Value,esd.Mode_Calculation,  
    sh.Salary_Head_Id,sh.Salary_Head_Name,sh.Salary_Type     
FROM         Tbl_Employee_Salary es INNER JOIN  
                      Tbl_Employee_Salary_Details esd ON es.Employee_Salary_Id = esd.Employee_Salary_Id INNER JOIN  
                      Tbl_Salary_Head sh ON esd.Salary_Head_Id = sh.Salary_Head_Id  
WHERE (sh.Salary_head_Delete_Status = 0) AND (Grade_Id=@Grade_Id) AND (Emp_Id=@Emp_Id) AND (Date=@Date)  
END
');
END;

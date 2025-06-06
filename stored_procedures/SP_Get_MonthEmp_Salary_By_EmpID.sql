IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_MonthEmp_Salary_By_EmpID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Get_MonthEmp_Salary_By_EmpID]  
@Employee_Id bigint                  
As                  
Begin    
DECLARE @Emp_Id varchar(10)             
SET @Emp_Id=cast (@Employee_Id As varchar(10))              
            
                
DECLARE @query VARCHAR(4000)                  
DECLARE @head_name VARCHAR(2000)                  
SELECT  @head_name = STUFF(( SELECT DISTINCT                  
                        ''],['' + Salary_Head_Name      
                        FROM  Tbl_Employee_Salary  ES    
Inner Join Tbl_Employee E on E.Employee_Id=ES.Emp_Id  
Inner join   Tbl_Employee_Salary_Details ESD on ESD.Employee_Salary_Id=ES.Employee_Salary_Id  
inner join Tbl_Salary_Head SH on SH.Salary_Head_Id=ESD.Salary_Head_Id  
WHERE Emp_Id=@Employee_Id         
                
                        ORDER BY ''],['' + Salary_Head_Name                  
                        FOR XML PATH('''')                  
                        ), 1, 2, '''') + '']''                  
                  
                  
SET @query =                  
''SELECT * FROM                  
(                  
SELECT   
  
 Salary_Head_Name,   
  
  
 ISNULL(Grade_Sal_Value ,0) AS Grade_Sal_Value ,   
ES.Date as [Month Year],  
ES.Basic_Salary as [Basic Salary],  
  
ES.Gross_Salary as [Net Salary]                  
  FROM  Tbl_Employee_Salary  ES   
Inner Join Tbl_Employee E on E.Employee_Id=ES.Emp_Id   
Inner join   Tbl_Employee_Salary_Details ESD on ESD.Employee_Salary_Id=ES.Employee_Salary_Id  
inner join dbo.Tbl_Salary_Head SH on SH.Salary_Head_Id=ESD.Salary_Head_Id  
WHERE Emp_Id=''+@Emp_Id+''    
)t                  
PIVOT (MAX(Grade_Sal_Value) FOR Salary_Head_Name                 
IN (''+@head_name+'')) AS pvt''                  
EXECUTE (@query)                  
                  
                  
End


    ')
END

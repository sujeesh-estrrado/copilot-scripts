IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_Department_NonTeaching_check]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                     
CREATE procedure [dbo].[SP_Get_All_Employee_Department_NonTeaching_check]     
AS                
BEGIN   
  
SELECT *                      
FROM                          
   (               
        SELECT       
ROW_NUMBER() OVER                         
   (PARTITION BY Tbl_Emp_Department.Dept_Id ORDER BY Tbl_Emp_Department.Dept_Id) as num,Tbl_Emp_Department.Dept_Id , Tbl_Emp_Department.Dept_Name  as Department ,Tbl_Employee.Employee_Id,Tbl_Employee.Employee_FName+'' ''+Tbl_Employee.Employee_LName as [Name
]  
FROM            Tbl_Employee INNER JOIN  
                Tbl_Employee_Official ON Tbl_Employee.Employee_Id = Tbl_Employee_Official.Employee_Id  Inner Join
                
          
                      Tbl_Emp_Department on Tbl_Emp_Department.Dept_Id = Tbl_Employee_Official.Department_Id
where Tbl_Employee.Employee_Type=''Non-Teaching'')tbl                        
where tbl.num=1                         
ORDER BY Dept_Id desc    
  
END
    ')
END

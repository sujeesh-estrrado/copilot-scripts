IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_PayInSlip_By_DepID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_All_Employee_PayInSlip_By_DepID] 
        
@Dept_Id bigint ,
@Date varchar(15)          
AS                        
BEGIN         
        
SELECT *                            
FROM                                
   (                     
        SELECT             
ROW_NUMBER() OVER                               
   (PARTITION BY Tbl_Employee.Employee_Id ORDER BY Tbl_Employee.Employee_Id) as num, Tbl_Emp_Department.Dept_Name ,Tbl_Emp_Department.Dept_Id,Tbl_Employee.Employee_Id,Tbl_Employee.Employee_FName+'' ''+Tbl_Employee.Employee_LName as [Name]      
 , Tbl_Grade_Mapping.Emp_Grade_Id ,Tbl_Employee_Grade.Emp_Grade_Name  ,Tbl_Grade_Salary.Total_Salary ,Tbl_Grade_Salary.Basic_Salary , Tbl_Grade_Salary.Salary_Head_ID,Tbl_Grade_Salary.Grade_Sal_Value,Tbl_Grade_Salary.Mode_Calculation    
,Tbl_Employee_Salary.Gross_Salary,Tbl_Employee_Salary.Emp_Id,Tbl_Employee_Salary.Date FROM Tbl_Employee INNER JOIN       
                      Tbl_Grade_Mapping ON Tbl_Employee.Employee_Id = Tbl_Grade_Mapping.Employee_Id INNER JOIN        
                      Tbl_Employee_Grade ON Tbl_Grade_Mapping.Emp_Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id        
      INNER JOIN        
                      Tbl_Employee_Official ON Tbl_Employee.Employee_Id = Tbl_Employee_Official.Employee_Id          
                          inner JOIN          
                      Tbl_Emp_Department on Tbl_Emp_Department.Dept_Id =Tbl_Employee_Official.Department_Id   
   inner join        
                      Tbl_Grade_Salary on Tbl_Grade_Salary.Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id   
   inner join    Tbl_Employee_Salary on    Tbl_Employee_Salary.Emp_Id=Tbl_Employee.Employee_Id 
where Employee_Type = ''Teaching'' and Tbl_Emp_Department.Dept_Id = @Dept_Id and Tbl_Employee_Salary.Date=@Date )tbl                              
where tbl.num=1                               
ORDER BY Employee_Id desc          
END
    ')
END

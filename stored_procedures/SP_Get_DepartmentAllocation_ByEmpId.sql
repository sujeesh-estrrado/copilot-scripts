IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_DepartmentAllocation_ByEmpId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_DepartmentAllocation_ByEmpId]   -- 10003    
(@Employee_Id bigint)            
AS      
BEGIN        
        
SELECT  
DISTINCT
 D.Department_ID ,  
 ECA.Emp_DepartmentAllocation_Id,    
ECA.Employee_Id,    
E.Employee_FName+'' ''+E.Employee_LName as EmployeeName,      
ED.Dept_Name,      
ECA.Allocated_CourseDepartment_Id,D.Department_Name,CD.Course_Department_Id,D.Course_Code,
CC.Course_Category_Name,CC.Course_Category_Id,     
CC.Course_Category_Name+''-''+D.Department_Name as SubDept ,MM.Course_Level_Name as Faculty      
      
FROM Tbl_Emp_CourseDepartment_Allocation ECA      
inner join  Tbl_Employee E on E.Employee_Id=ECA.Employee_Id      
inner join dbo.Tbl_Employee_Official EO on EO.Employee_Id=E.Employee_Id      
inner join  Tbl_Emp_Department ED on ED.Dept_Id=EO.Department_Id       
inner join  Tbl_Course_Department CD On CD.Course_Department_Id=ECA.Allocated_CourseDepartment_Id      
inner join Tbl_Department D On D.Department_Id=CD.Department_Id      
left join Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id  
left join Tbl_Course_Level MM on MM.Course_Level_Id=ECA.Allocated_CourseDepartment_Id    
 
 
        
Where ECA.Employee_Id=@Employee_Id and Emp_DepartmentAllocation_Status=0        
        
END
	');
END;

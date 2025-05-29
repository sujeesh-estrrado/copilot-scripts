IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Assigned_Department_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[SP_Get_Employee_Assigned_Department_Search_Count]            
(          
@SearchTerm  varchar(100)          
)          
          
as          
          
begin          
          
SELECT     
   ROW_NUMBER() OVER (ORDER BY Emp_DepartmentAllocation_Id DESC) AS RowNumber,  
   ECA.Emp_DepartmentAllocation_Id,    
   ECA.Employee_Id,    
   E.Employee_FName+'' ''+E.Employee_LName as EmployeeName,      
   ED.Dept_Name,      
   ECA.Allocated_CourseDepartment_Id,      
   CC.Course_Category_Name+''-''+D.Department_Name as SubDept  
         
      
FROM Tbl_Emp_CourseDepartment_Allocation ECA      
inner join  Tbl_Employee E on E.Employee_Id=ECA.Employee_Id      
inner join dbo.Tbl_Employee_Official EO on EO.Employee_Id=E.Employee_Id      
inner join  Tbl_Emp_Department ED on ED.Dept_Id=EO.Department_Id       
inner join  Tbl_Course_Department CD On CD.Course_Department_Id=ECA.Allocated_CourseDepartment_Id      
inner join Tbl_Department D On D.Department_Id=CD.Department_Id      
inner join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id      
        
Where Emp_DepartmentAllocation_Status=0       
         
and  (Emp_DepartmentAllocation_Id like  ''''+ @SearchTerm+''%''    
    
or  ECA.Employee_Id like  ''''+ @SearchTerm+''%''    
    
or  E.Employee_FName+'' ''+E.Employee_LName like  ''''+ @SearchTerm+''%''    
    
or  Dept_Name like  ''''+ @SearchTerm+''%''          
        
or  CC.Course_Category_Name+''-''+D.Department_Name like  ''''+ @SearchTerm+''%''    
      
)          
          
end
    ');
END;

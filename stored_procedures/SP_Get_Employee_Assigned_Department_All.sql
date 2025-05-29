IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Assigned_Department_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                
CREATE procedure [dbo].[SP_Get_Employee_Assigned_Department_All]                     
(                    
                        
@CurrentPage int = null,                    
@PageSize int = null                  
--@SearchTerm varchar(100)                  
)                    
                        
AS                    
                    
BEGIN                    
    SET NOCOUNT ON                    
                    
    DECLARE @SqlString nvarchar(max)                
    Declare @SqlStringWithout nvarchar(max)                    
    Declare @UpperBand int                    
    Declare @LowerBand int                            
                        
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize                    
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                        
                    
    BEGIN                    
                     
              
              
--IF @SearchTerm IS NOT NULL              
--              
--BEGIN              
              
 SET @SqlString=''WITH tempProfile AS                    
        (SELECT         
   ECA.Emp_DepartmentAllocation_Id as ID,        
   ECA.Employee_Id,        
   E.Employee_FName+'''' ''''+E.Employee_LName as EmployeeName,          
   ED.Dept_Name as Department,          
   ECA.Allocated_CourseDepartment_Id,          
   CC.Course_Category_Name+''''-''''+D.Department_Name as AssignedDepartments,      
   ROW_NUMBER() OVER (ORDER BY Emp_DepartmentAllocation_Id DESC) AS RowNumber          
          
FROM Tbl_Emp_CourseDepartment_Allocation ECA          
inner join  Tbl_Employee E on E.Employee_Id=ECA.Employee_Id          
inner join dbo.Tbl_Employee_Official EO on EO.Employee_Id=E.Employee_Id          
inner join  Tbl_Emp_Department ED on ED.Dept_Id=EO.Department_Id           
inner join  Tbl_Course_Department CD On CD.Course_Department_Id=ECA.Allocated_CourseDepartment_Id          
inner join Tbl_Department D On D.Department_Id=CD.Department_Id          
inner join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id          
            
Where Emp_DepartmentAllocation_Status=0           
             
             
                   
              
  )                         
                    
        SELECT            
   ID,        
   Employee_Id,        
   EmployeeName,          
   Department,          
   Allocated_CourseDepartment_Id,          
   AssignedDepartments,         
            RowNumber                                       
        FROM                     
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)           
                 
end              
              
   EXEC sp_executesql @SqlString                    
                
                   
                 
END
    ');
END;
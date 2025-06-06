IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Employees_By_Student_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_All_Employees_By_Student_Id]    
@Student_Id bigint    
AS    
BEGIN    
SELECT      
Distinct Employee_id,       
E.Employee_Fname+'' ''+E.EMployee_Lname As [Name]    
From LMS_Tbl_Class c
Inner Join LMS_Tbl_Student_Class sc On sc.Class_Id=c.Class_Id     
Inner Join LMS_Tbl_Emp_Class ec On sc.Class_Id=ec.Class_Id      
Inner Join Tbl_Employee E On ec.Emp_Id=E.Employee_id      
Where c.Active_Status=1 and c.Delete_Status=0 and ec.Active_Status=1      
and sc.Student_id=@Student_Id
END
    ')
END

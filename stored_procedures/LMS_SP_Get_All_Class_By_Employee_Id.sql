IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Class_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_All_Class_By_Employee_Id]      
@Emp_Id bigint      
AS      
BEGIN      
SELECT      
Distinct c.Class_Id,      
c.Class_Name,  
ec.Is_Class_Owner,    
ec.Active_Status      
From LMS_Tbl_Class c      
Inner Join LMS_Tbl_Emp_Class ec On c.Class_Id=ec.Class_Id      
Where   
--c.Active_Status=1 and   
c.Delete_Status=0 and  ec.Emp_Id=@Emp_Id    
order by   c.Class_Id Desc  
END
    ')
END

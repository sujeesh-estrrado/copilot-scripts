IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Employees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_All_Employees]  
AS    
BEGIN    
select Employee_Id,Employee_FName+'' ''+Employee_LName as Employee_Name from Tbl_Employee where Employee_Status=0
END
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Department_By_DeptId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Department_By_DeptId]  --2  
    
(@Department_Id bigint)    
    
AS BEGIN    
    
SELECT Department_Id,Department_Name,Course_Code,Program_Type_Id,Course_rereg_status FROM Tbl_Department WHERE Department_Id=@Department_Id    
    
END  
  
--select * from Tbl_Department  
--select * from tbl_course_category  
  
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_DepartmentActiveStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
     CREATE procedure [dbo].[SP_Update_DepartmentActiveStatus]          
(@Department_Id bigint)          
as         
Begin          
    Update dbo.Tbl_Department          
    set           
        Active_Status = (CASE Active_Status WHEN ''Active'' THEN ''Inactive'' ELSE ''Active'' END),
        Updated_Date = getdate()
    where Department_Id=@Department_Id          
end  
  
--  select * from Tbl_Department
    ')
END

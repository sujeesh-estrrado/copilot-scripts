IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Department_Subjects_by_Department_subject_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Department_Subjects_by_Department_subject_Id]  
(@Department_Subject_Id bigint)    
    
AS    
    
BEGIN    
    
 DELETE FROM [Tbl_Department_Subjects]    
  WHERE  Department_Subject_Id= @Department_Subject_Id
END
    ')
END

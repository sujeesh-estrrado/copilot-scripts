IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Semester_Subjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Semester_Subjects]   
@Duration_Mapping_Id bigint,    
@Department_Subjects_Id bigint   
AS    
BEGIN    
 Update Tbl_Semester_Subjects
Set Duration_Mapping_Id=@Duration_Mapping_Id
Where  Department_Subjects_Id=@Department_Subjects_Id

END
    ')
END;

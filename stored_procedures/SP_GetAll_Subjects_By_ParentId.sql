IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Subjects_By_ParentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Subjects_By_ParentId]  
@Parent_Subject_Id bigint
As
Begin
Select 
Subject_Id,
Subject_Name,
Subject_Code
From Tbl_Subject
Where Parent_Subject_Id=@Parent_Subject_Id
and subject_status=0
End
    ')
END

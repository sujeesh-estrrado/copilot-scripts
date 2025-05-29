IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_DepartmentSubjects_By_ParentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_DepartmentSubjects_By_ParentId] 
@Department_Subject_Id bigint,
@Course_Department_Id bigint    
As    
Begin    
Select     
DS.Department_Subject_Id,    
DS.Course_Department_Id,    
DS.Subject_Id    
From Tbl_Department_Subjects DS    
Inner Join Tbl_Subject S On DS.Subject_Id=S.Subject_Id    
Where S.Parent_Subject_Id=@Department_Subject_Id and DS.Course_Department_Id=@Course_Department_Id   
End

');
END;
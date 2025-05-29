IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_MainSubjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_MainSubjects]           
As        
Begin        
Select         
Subject_Id,        
Subject_Name+''-''+Subject_Code AS Subject_Code,  
Subject_Name+''-''+Subject_Code as Subject_Name        
--Subject_Code        
From Tbl_Subject        
Where Parent_Subject_Id=0 and Subject_Status=0        
        
End
    ')
END;

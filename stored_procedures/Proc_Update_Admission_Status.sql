IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Admission_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Update_Admission_Status] (@Course_Level_Id bigint ,@Course_Category_Id bigint,@Department_Id bigint)
    
AS
    
BEGIN 
    
        update dbo.tbl_New_Admission

     set

Admission_Status=0 where Course_Level_Id=@Course_Level_Id and 

Course_Category_Id=@Course_Category_Id and Department_Id=@Department_Id

        


END
    ')
END

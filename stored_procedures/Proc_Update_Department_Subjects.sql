IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Department_Subjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Update_Department_Subjects]       
 (@Course_Department_Id bigint,@Subject_Id bigint)      
AS      
       
BEGIN   
UPDATE Tbl_Department_Subjects  
SET Course_Department_Id=@Course_Department_Id 
OUTPUT INSERTED.Department_Subject_Id
Where Subject_Id=@Subject_Id  
END

    ')
END

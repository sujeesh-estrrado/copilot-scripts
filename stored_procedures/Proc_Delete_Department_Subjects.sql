IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Department_Subjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Department_Subjects] 
(@Subject_id bigint,  
 @Course_department_id bigint)    
  
AS
BEGIN TRY  
    
 DELETE FROM [Tbl_Department_Subjects]    
  WHERE  Subject_id= @Subject_id  and Course_department_id=@Course_department_id  
END TRY

BEGIN CATCH

 RAISERROR(''Please delete Other References Subject'',16,1)
  

END CATCH
    ')
END

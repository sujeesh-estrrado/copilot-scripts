IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Subject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Subject]          
 (@parent_subject_id bigint, @subject_name varchar(300),@subject_Code varchar(50),@subject_Descripition varchar(500),@subject_date datetime)        
AS        
        
IF EXISTS(SELECT Subject_Name FROM Tbl_Subject Where Subject_Name = @subject_name and Subject_Code=@subject_Code and Subject_Status=0)        
BEGIN        
RAISERROR (''Data Already Exists.'', -- Message text.        
               16, -- Severity.        
               1 -- State.        
               );        
END        
ELSE        
         
BEGIN         
         
  insert into Tbl_Subject(Parent_Subject_Id,Subject_Name,Subject_Code,Subject_Descripition,Subject_Date)        
  values(@parent_subject_id ,@subject_name,@subject_Code,@subject_Descripition,@subject_date)        
        
 SELECT SCOPE_IDENTITY()        
END
    ')
END

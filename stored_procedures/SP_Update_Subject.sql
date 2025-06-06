IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Subject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Subject](@parent_subject_id bigint,@Subject_Id bigint,@Subject_Name varchar(300),              
     @subject_Code varchar(50),@Subject_Descripition varchar(500),@Subject_Date datetime)              
              
AS         
        
 IF EXISTS(SELECT * FROM Tbl_Subject Where Subject_Name = @subject_name and Subject_Id<>@Subject_Id and Subject_Status=0 )            
BEGIN            
RAISERROR (''Data Already Exists.'', -- Message text.            
               16, -- Severity.            
               1 -- State.            
               );            
END            
ELSE              
              
BEGIN              
              
 UPDATE [dbo].[Tbl_Subject]              
  SET   Parent_Subject_Id      = @parent_subject_id,              
               subject_Name      = @Subject_Name,              
               Subject_Code= @subject_Code,              
      subject_Descripition      = @Subject_Descripition,   
             
               subject_Date              = @Subject_Date         
                    
 OUTPUT INSERTED.subject_Id                          
  WHERE  subject_Id                = @Subject_Id              
              
END
    ')
END

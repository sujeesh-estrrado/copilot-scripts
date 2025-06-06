IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Semester_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Course_Semester_Update]  
@Semester_Id bigint,  
@Semester_Code varchar(50),  
@Semester_Name varchar(200)  
AS  
 IF EXISTS(SELECT Semester_Name FROM Tbl_Course_Semester Where (Semester_Name = @Semester_Name or Semester_Code=@Semester_Code) and Semester_Id<>@Semester_Id  )        
     
BEGIN      
RAISERROR (''Date Already Exists.'', -- Message text.        
               16, -- Severity.        
               1 -- State.        
               );        
END      
ELSE
BEGIN  
UPDATE [Tbl_Course_Semester]  
   SET [Semester_Code] = @Semester_Code  
      ,[Semester_Name] = @Semester_Name  
 WHERE Semester_Id=@Semester_Id  
END
    ')
END

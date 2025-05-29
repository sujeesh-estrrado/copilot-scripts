IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Initial_Application]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Proc_Insert_Initial_Application]             
(@Course_Level_Id  bigint,@Course_Category_Id  bigint,        
@Department_Id  bigint,      
@New_Admission_id bigint,            
@Name varchar(50),      
@DOB varchar(50),      
@Mobile varchar(50),      
@Email varchar(50) ,      
@Confirm_Email varchar(50),
@Apllication_Status varchar(50))            
AS            
             
BEGIN             
             
  insert into dbo.Tbl_Initial_Application_Registration            
        (Course_Level_Id,Course_Category_Id,Department_Id,New_Admission_id,Name,DOB,Mobile,Email,Confirm_Email,Application_status,Created_Date,Delete_Status)            
              
        values            
        (@Course_Level_Id,@Course_Category_Id,@Department_Id,@New_Admission_id,            
            
         @Name,@DOB,@Mobile,@Email,@Confirm_Email,@Apllication_Status,getdate(),0)            
            
select Scope_Identity()            
            
            
END   
    ')
END;

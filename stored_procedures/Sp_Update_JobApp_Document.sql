IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_JobApp_Document]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Update_JobApp_Document]     
      (          
  @JobApplication_Id bigint,                  
  @Document_Name varchar(max),    
  @Document_URl varchar(max),    
  @Flag bigint    
                  
   )          
As                  
                  
Begin         
if(@Flag=0)        
begin        
         Update  [dbo].[Tbl_JobApp_Attachments] set [Resume_Name]=@Document_Name,[Resume_Url]=@Document_URl where Job_Id=@JobApplication_Id    
               
      end          
  if(@Flag=1)        
begin        
         Update  [dbo].[Tbl_JobApp_Attachments] set [Passport_Name]=@Document_Name,[Passport_Url]=@Document_URl where Job_Id=@JobApplication_Id    
               
      end    
   if(@Flag=2)        
begin        
         Update  [dbo].[Tbl_JobApp_Attachments] set [Teaching_Permit_Name]=@Document_Name,[Teaching_Permit_Url]=@Document_URl where Job_Id=@JobApplication_Id    
               
      end    
   if(@Flag=3)        
begin        
         Update  [dbo].[Tbl_JobApp_Attachments] set [Medical_Report_Name]=@Document_Name,[Medical_Report_Url]=@Document_URl where Job_Id=@JobApplication_Id    
               
      end    
   if(@Flag=4)        
begin        
         Update  [dbo].[Tbl_JobApp_Attachments] set [Driving_License_Name]=@Document_Name,[Driving_License_Url]=@Document_URl where Job_Id=@JobApplication_Id    
               
      end    
      if(@Flag=5)        
begin        
         insert into  [dbo].[Tbl_JobApp_Academic_Transcripts_Attachment] ([Job_Id],[Academic_Transcripts_Name],[Academic_Transcripts_URL],[Del_Status]) values(@JobApplication_Id,@Document_Name,@Document_URl,0)  
               
      end    
      if(@Flag=6)        
begin        
 insert into  [dbo].[Tbl_JobApp_Certificate_Copies_Attachment]  ([Job_Id],[Certificate_Copies_Name],[Certificate_Copies_URL],[Del_Status]) values(@JobApplication_Id,@Document_Name,@Document_URl,0)              
      end    
    
End
    ')
END

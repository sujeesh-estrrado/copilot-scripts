IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Candidate_Accademic_Qualifications]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Candidate_Accademic_Qualifications]  
 (@Candidate_Id bigint  
           ,@Institution_Level varchar(MAX)=''''
           ,@Institution_Name varchar(MAX)
           ,@Institution_Location varchar(MAX) 
           ,@Yearof_Pass bigint
           ,@Qualification varchar(MAX)='''' 
           ,@Filepath varchar(MAX)=''''
           ,@Other_Level varchar(MAX)='''',
           @Curriculum varchar(100)
)  
AS  
BEGIN  
  
 if not exists(select * from Tbl_Candidate_EducationDetails where Candidate_Id=@Candidate_Id and Qualification=@Qualification) 
 begin
INSERT INTO [Tbl_Candidate_EducationDetails]  
           ([Candidate_Id]  
           ,[Institution_Level]  
           ,Institution_Name,Institution_Location,
           Yearof_Pass,Qualification,Created_Date,Delete_Status,Edu_Details_DelStatus,Filepath,Other_Level,Curriculum)  
     VALUES  
       (@Candidate_Id  
           ,@Institution_Level
           ,@Institution_Name 
           ,@Institution_Location  
           ,@Yearof_Pass  
           ,@Qualification
           ,getdate(),0,0,@Filepath,@Other_Level,@Curriculum)  
  end
  else
  begin
  Update Tbl_Candidate_EducationDetails set Institution_Level=@Institution_Level,Institution_Name=@Institution_Name,Other_Level=@Other_Level
  ,Institution_Location=@Institution_Location,Yearof_Pass=@Yearof_Pass,Qualification=@Qualification,Filepath=@Filepath,Curriculum=@Curriculum,Updated_Date=GETDATE()
   where Candidate_Id=@Candidate_Id and Qualification=@Qualification
  end
END
    ')
END

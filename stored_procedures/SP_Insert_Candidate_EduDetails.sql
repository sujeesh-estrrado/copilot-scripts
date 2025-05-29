IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Candidate_EduDetails]')
    AND type = N'P'
)
BEGIN
    EXEC('
 
CREATE procedure [dbo].[SP_Insert_Candidate_EduDetails]  
 (@Candidate_Id bigint  
           ,@Exam_Name varchar(300)
           ,@Exam_Board varchar(300)  
           ,@University_Board varchar(300)  
           ,@Reg_No varchar(50)  
           ,@Yearof_Pass varchar(5)  
           ,@Institution_Name varchar(300)  
           ,@Percentage float  
           ,@Edu_Details_DelStatus bit)  
AS  
BEGIN  
  
  
INSERT INTO [Tbl_Candidate_EducationDetails]  
           ([Candidate_Id]  
           ,[Exam_Name]  
           ,[Exam_Board]
           ,[University_Board]  
           ,[Reg_No]  
           ,[Yearof_Pass]  
           ,[Institution_Name]  
           ,[Percentage]  
           ,[Edu_Details_DelStatus])  
     VALUES  
       (@Candidate_Id  
           ,@Exam_Name 
           ,@Exam_Board 
           ,@University_Board  
           ,@Reg_No  
           ,@Yearof_Pass  
           ,@Institution_Name  
           ,@Percentage  
           ,@Edu_Details_DelStatus)  
  
END
    ')
END
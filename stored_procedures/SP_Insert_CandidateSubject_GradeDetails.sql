IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_CandidateSubject_GradeDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_CandidateSubject_GradeDetails]  
 (@Sub_Name varchar(MAX)  
           ,@Sub_Grade varchar(MAX)
		   ,@Education_Type varchar(MAX) 
           ,@Cand_Id bigint )  
AS  
BEGIN  
  if not exists(select * from Tbl_Candidate_Education_Grade where Sub_Name=@Sub_Name and  Cand_Id=@Cand_Id and Education_Type=@Education_Type)
  begin
INSERT INTO [Tbl_Candidate_Education_Grade]  
           (Sub_Name  
           ,Sub_Grade  
		   ,Education_Type
           ,Cand_Id,Created_Date,Delete_status)  
     VALUES  
       (@Sub_Name  
           ,@Sub_Grade 
		   ,@Education_Type 
           ,@Cand_Id  
           ,getdate(),0)  
  end
  else
  begin
  Update Tbl_Candidate_Education_Grade set
  Sub_Grade=@Sub_Grade where Sub_Name=@Sub_Name and  Cand_Id=@Cand_Id and Education_Type=@Education_Type

  end
END');
END;

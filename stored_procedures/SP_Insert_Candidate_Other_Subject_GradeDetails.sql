IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Candidate_Other_Subject_GradeDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Candidate_Other_Subject_GradeDetails]  
 (@Sub_Name varchar(MAX)  
           ,@Sub_Grade varchar(MAX)
		   ,@Education_Type varchar(MAX) 
           ,@Cand_Id bigint,
		   @Sub_other varchar(MAX) )  
AS  
BEGIN  
  if not exists(select * from Tbl_Candidate_Education_Grade where Sub_Name=@Sub_Name and  Cand_Id=@Cand_Id and Education_Type=@Education_Type)
  begin
INSERT INTO [Tbl_Candidate_Education_Grade]  
           (Sub_Name  
           ,Sub_Grade  
		   ,Education_Type
           ,Cand_Id,
		   Sub_other,Created_Date,Delete_status)  
     VALUES  
			(@Sub_Name  
           ,@Sub_Grade 
		   ,@Education_Type 
           ,@Cand_Id,
		   @Sub_other  
           ,getdate(),0)  
  end
  else
  begin
  Update Tbl_Candidate_Education_Grade set
  Sub_Grade=@Sub_Grade,Delete_status=0  where Sub_Name=@Sub_Name and  Cand_Id=@Cand_Id and Education_Type=@Education_Type and Sub_other=@Sub_other

  end
  End');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_MISC_DUEDATE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GET_MISC_DUEDATE] --10,14
@CandidateID BIGINT,  
@IntakeId BIGINT  
  
AS  
BEGIN  
  
SELECT max(FM.Fee_Entry_Id) FROM Tbl_Fee_Entry_Main FM   
INNER JOIN Tbl_Fee_Entry FE on FE.Amount=FM.Amount and FE.IntakeId=FM.IntakeId and   
FE.Candidate_Id=FM.Candidate_Id and  FE.Feeid=FM.Feeid and Fm.ActiveStatus is null WHERE FM.Candidate_Id=@CandidateID and FM.IntakeId=@IntakeId AND FM.TYP=''MISC''  
  
END 
   ')
END;

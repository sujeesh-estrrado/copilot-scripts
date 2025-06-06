-- Create Get_StudentName_By_BatchId procedure if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_StudentName_By_BatchId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_StudentName_By_BatchId]--11830
@Batch_Id bigint
as
begin

select distinct(c.Candidate_Id),c.Candidate_Fname+'' ''+ c.Candidate_Mname+'' ''+c.Candidate_Lname CandidateName,    
c.AdharNumber,NA.Batch_Id from Tbl_Candidate_Personal_Det C          
  inner join tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id where Batch_Id=@Batch_Id
 
 
  end
    ')
END;
GO

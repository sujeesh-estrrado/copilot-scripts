IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ReceiptNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_ReceiptNo] --3,28       11830,157         
      
@Batch_Id bigint,      
@Candidate_Id bigint      
      
      
as      
begin      
      
select distinct(c.Candidate_Id),c.Candidate_Fname+'' ''+ c.Candidate_Mname+'' ''+c.Candidate_Lname CandidateName,          
c.AdharNumber,FE.IntakeId as Batch_Id,FE.ReceiptNo      
from Tbl_Candidate_Personal_Det C                
--inner join Tbl_Fee_Entry_Details F on c.Candidate_Id=F.CandidateId    
INNER JOIN  dbo.Tbl_Fee_Entry FE ON c.Candidate_Id=FE.Candidate_Id    
--inner join tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id 
where FE.IntakeId=@Batch_Id and c.Candidate_Id=@Candidate_Id      
      
end 
	');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Update_MatrixNo_by_candidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[sp_Update_MatrixNo_by_candidate_id] (@MatrixNo    varchar(max),@candidateID bigint)  
as  
begin  
 update tbl_candidate_personal_det   
 set IDMatrixNo=@MatrixNo   
 where Candidate_Id=@candidateID and (active=3 or active=2) and Candidate_DelStatus=0  
  
end 
    ')
END;

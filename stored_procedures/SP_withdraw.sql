IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_withdraw]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_withdraw](@Candidate_Id bigint=0,@flag bigint=0)
as
begin
  if not exists(select Candidate_Id from tbl_Fee_Entry where Candidate_id=@Candidate_Id)   
      begin
      if(@flag>0)
      begin

      update dbo.Tbl_Candidate_Personal_Det     
  Set Active_Status = ''Incative'', [Status]= ''Incative'',active=7 ,Candidate_DelStatus=1 
  where Candidate_Id=@Candidate_Id  ; 
  update Tbl_Student_Tc_request set Delete_status=1,Final_Approval_date=GETDATE() where Candidate_id=@Candidate_Id and Request_type=''Termination'' and Delete_status=0; 
      end
      else
      begin
  update dbo.Tbl_Candidate_Personal_Det     
  Set Active_Status = ''Incative'', [Status]= ''Incative'',active=6 ,Candidate_DelStatus=1 
  where Candidate_Id=@Candidate_Id  ; 
  update Tbl_Student_Tc_request set Delete_status=1,Final_Approval_date=GETDATE() where Candidate_id=@Candidate_Id and Request_type=''Withdraw'' and Delete_status=0; 
     end
  end
  END

 -- select * from Tbl_Student_status
    ')
END

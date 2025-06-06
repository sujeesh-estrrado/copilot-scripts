IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Preactivate_studentBackend]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Preactivate_studentBackend] --151911
--Preactivate_studentBackend 151911
(@icno varchar(500))
AS
begin
declare @candidate_id bigint
set @candidate_id=(select Candidate_Id from Tbl_Candidate_Personal_Det where AdharNumber=@icno)

if not exists(select * from Tbl_Student_NewApplication where Candidate_Id=@candidate_id)
begin

update Tbl_Candidate_Personal_Det set ApplicationStatus=''Preactivated'',Candidate_DelStatus=0,Status=''ACTIVE'',Active_Status=''ACTIVE'' where Candidate_Id=@candidate_id
update tbl_approval_log set Offerletter_sent=1,Offerletter_status=1,offer_letter_accept_date=GETDATE() where Candidate_Id=@candidate_id AND delete_status=0
end
else
begin
update Tbl_Student_NewApplication set ApplicationStatus=''Preactivated'',Candidate_DelStatus=0,Active_Status=''ACTIVE'' where Candidate_Id=@candidate_id
update tbl_approval_log set Offerletter_sent=1,Offerletter_status=1,offer_letter_accept_date=GETDATE() where Candidate_Id=@candidate_id AND delete_status=0



end



end
    ')
END

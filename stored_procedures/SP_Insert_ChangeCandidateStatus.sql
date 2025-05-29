IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ChangeCandidateStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_ChangeCandidateStatus](@Candidate_Id bigint ,@employeeid bigint,@Status varchar(500))
as
begin
if not exists(select * from Tbl_Status_change_by_Marketing where Candidate_id=@Candidate_Id)
begin
insert into Tbl_Status_change_by_Marketing(Candidate_id,Status_changed_by,status,Create_date,delete_status)
values(@Candidate_Id,@employeeid,@Status,GETDATE(),0);
end
else
begin
update Tbl_Status_change_by_Marketing set status=@Status,Create_date=GETDATE(),Status_changed_by=@employeeid where Candidate_id=@Candidate_Id;
end
end
')
END

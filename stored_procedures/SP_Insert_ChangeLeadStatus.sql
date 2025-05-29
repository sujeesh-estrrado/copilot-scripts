IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_ChangeLeadStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_ChangeLeadStatus](@Candidate_Id bigint ,@employeeid bigint,@Status varchar(500))
as
begin
if not exists(select * from Tbl_LeadStatus_Change_by_Marketing where Candidate_id=@Candidate_Id)
begin
insert into Tbl_LeadStatus_Change_by_Marketing(Candidate_Id,Status_Changed_By,status,Create_Date,delete_status)
values(@Candidate_Id,@employeeid,@Status,GETDATE(),0);
end
else
begin
update Tbl_LeadStatus_Change_by_Marketing set status=@Status,Create_Date=GETDATE(),Status_Changed_By=@employeeid where Candidate_id=@Candidate_Id;
end
end');
END;

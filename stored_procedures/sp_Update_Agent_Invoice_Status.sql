IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Update_Agent_Invoice_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_Update_Agent_Invoice_Status] --3,60950
(
@flag bigint=0,
@Candidate_id bigint=0
)
AS

BEGIN
if(@flag=0)
begin
Update Tbl_Candidate_Personal_Det set Invoice_Status=''Raise'' where Candidate_Id=@Candidate_id
end
if(@flag=1)
begin
Update Tbl_Candidate_Personal_Det set Payment_Request_Status=''Raise'' where Candidate_Id=@Candidate_id
end

if(@flag=3)
begin
select Payment_Request_Status from Tbl_Candidate_Personal_Det  where
 Payment_Request_Status=''Raise'' and
 Candidate_Id=@Candidate_id
end
End
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Reject_Candidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Reject_Candidate]
(@candidate_id bigint,
@status varchar(50),
@Activestatus varchar(50)=''ACTIVE'',
@Flag bigint=0,
@RejectRemark varchar(50)=''''
)
as
begin
if(@Flag=0)
begin
	update Tbl_Candidate_Personal_Det set 
	ApplicationStatus=@status,Candidate_DelStatus=1,
	Active_Status=@Activestatus
    where Candidate_Id=@candidate_id
end
if(@Flag=1)
begin
	update Tbl_Student_NewApplication set 
	ApplicationStatus=@status,Candidate_DelStatus=1,
	Active_Status=@Activestatus
    where Candidate_Id=@candidate_id
end
end
');
END;
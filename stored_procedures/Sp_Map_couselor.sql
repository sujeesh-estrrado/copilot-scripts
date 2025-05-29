IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Map_couselor]') 
    AND type = N'P'
)
BEGIN
    EXEC ('  
    CREATE procedure [dbo].[Sp_Map_couselor](@Candidate bigint,@Counselorid bigint)
as
begin
if not exists (select * from Tbl_Student_Tc_request where Request_status=''Progress'' and Candidate_id=@Candidate and Delete_status=0)
begin
update Tbl_Student_Tc_request set Counselor_id=@Counselorid,Request_status=''Progress'' where Candidate_id=@Candidate;
end
end    ')
END;

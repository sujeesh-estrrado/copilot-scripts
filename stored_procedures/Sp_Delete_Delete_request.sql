IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_Delete_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure  [dbo].[Sp_Delete_Delete_request](@candidate_id bigint=0,@remark varchar(max)='''')
as
begin
Update Tbl_Delete_Request set Delete_status=1,Registrar_remark=@remark where Candidate_id=@candidate_id
end
    ')
END

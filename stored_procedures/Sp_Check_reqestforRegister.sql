IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Check_reqestforRegister]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure  [dbo].[Sp_Check_reqestforRegister] (@Candidate_Id bigint)
as
begin
select * from Tbl_Delete_Request where Candidate_id=@Candidate_Id and Delete_status=0;
end

    ')
END

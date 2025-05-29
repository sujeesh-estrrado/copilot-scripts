IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetProgramChangeRequest]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetProgramChangeRequest](@User_Id bigint)
as
begin
select * from Tbl_Program_change_request where Candidate_id=@User_Id and delete_status=0;
end
');
END;
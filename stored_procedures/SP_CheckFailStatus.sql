IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_CheckFailStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_CheckFailStatus](@candidate_id bigint)
as
begin 
select * from Tbl_Interview_Schedule_Log where candidate_id=@candidate_id and delete_status=0;
end

    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetInterviewDetails_byId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetInterviewDetails_byId](@id bigint)
as
begin
select * from Tbl_Interview_Schedule_Log where schedule_id=@id;
end
');
END;
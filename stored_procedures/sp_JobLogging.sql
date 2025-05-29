IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_JobLogging]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_JobLogging]
as
begin
	insert into Tbl_JobScheduleLog values(getdate(),1)
end
');
END;
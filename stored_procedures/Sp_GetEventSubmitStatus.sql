IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventSubmitStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventSubmitStatus]
@eventId bigint
as
begin 
select JoinedStatus from Tbl_EventStudentSubmit where Event_Id=@eventId
end
   ')
END;

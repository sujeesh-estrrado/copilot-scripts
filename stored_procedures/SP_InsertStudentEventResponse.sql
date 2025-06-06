IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertStudentEventResponse]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_InsertStudentEventResponse]
@Eventid bigint,
@userId bigint
as
begin
insert into Tbl_EventStudentSubmit(Event_Id,Student_Id,JoinDate,JoinedStatus,Type)
values(@Eventid,@userId,GETDATE(),''Submitted'',''Student'')
end
   ')
END;

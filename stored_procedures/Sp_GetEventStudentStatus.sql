IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventStudentStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventStudentStatus]
@Event_Id bigint,
@User_Id bigint
as
begin
select JoinedStatus from Tbl_EventStudentSubmit where Event_Id=@Event_Id and Student_Id=@User_Id
end
   ')
END;

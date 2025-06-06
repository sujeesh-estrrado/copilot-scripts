IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetSubmitedEventRespond]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetSubmitedEventRespond]
@Event_Id bigint
as
begin
select Question,Answer,Description as EventDescription,Event_Title as EventTitle,
CONVERT(VARCHAR, es.JoinDate, 103) AS JoinDate,EA.QuestionType,EA.Options

from Tbl_EventAnswer EA
left join Tbl_EventList EL on EA.Event_Id=EL.Event_Id
left join Tbl_EventStudentSubmit ES on ES.Event_Id=EL.Event_Id
where EA.Event_Id=@Event_Id
end
   ')
END;

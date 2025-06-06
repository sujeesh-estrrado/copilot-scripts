IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventDetailsById_ForSubmit]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventDetailsById_ForSubmit]
@EventId bigint
as
begin 
BEGIN
    SET NOCOUNT ON;

    SELECT 
        EL.Event_Id, 
        EL.Event_Title, 
        EL.Description, 
        EL.CreatedDate AS EventCreatedDate,
        EQM.QuestionMapping_Id,
        EQM.QuestionType,
        EQM.Question,
        EQM.Options,
        EQM.UploadType,
        EQM.CreatedDate AS QuestionCreatedDate,
        EQM.Del_Status
    FROM 
        Tbl_EventList EL
    INNER JOIN 
        Tbl_EventQuestionMapping EQM ON EL.Event_Id = EQM.Event_Id
    WHERE 
        EL.Event_Id = @EventId
        AND EQM.Del_Status = 0;
END
end
   ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_DeleteEventMappingQuestionBy_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_DeleteEventMappingQuestionBy_Id]
@Event_Id bigint
as
begin
delete Tbl_EventQuestionMapping where Event_Id=@Event_Id

end

   ')
END;

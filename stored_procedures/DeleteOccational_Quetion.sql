IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[DeleteOccational_Quetion]') 
    AND type = N'P'
)
BEGIN
    EXEC('

Create procedure [dbo].[DeleteOccational_Quetion]
@OccasionalForm_FormId bigint
as
begin
delete Occationalform_QuestionMapping where OccasionalForm_FormId=@OccasionalForm_FormId

end
   ')
END;

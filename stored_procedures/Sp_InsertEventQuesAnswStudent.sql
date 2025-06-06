IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertEventQuesAnswStudent]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE  [dbo].[Sp_InsertEventQuesAnswStudent]
@Event_Id bigint,
@Question Varchar(MAX),
@answer varchar(MAX),
@CreatedBy bigint,
@UploadFile varchar(max),
@Option varchar(50),
@QuestionType bigint,
@Question_MappingId bigint

as
begin
INSERT into Tbl_EventAnswer(Question,Answer,Event_Id,Type,CreatedBy,Options,UploadFile,QuestionType,Question_MappingId,CreatedDate)
values(@Question,@answer,@Event_Id,''Student'',@CreatedBy,@Option,@UploadFile,@QuestionType,@Question_MappingId,GETDATE())
end
   ')
END;

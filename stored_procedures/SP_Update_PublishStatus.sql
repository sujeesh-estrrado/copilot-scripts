IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_PublishStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Update_PublishStatus]
@exam_master_id bigint=0
as
begin
update Tbl_Exam_Master set Publish_status=1 where Exam_Master_id=@exam_master_id

end
    ')
END;

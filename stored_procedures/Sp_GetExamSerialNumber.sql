IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetExamSerialNumber]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetExamSerialNumber]
  @Exam_Master_id int 
as
begin
  select Exam_Name,Exam_Master_id from Tbl_Exam_Master where Publish_by=1 and delete_status=0

end
 ');
END;
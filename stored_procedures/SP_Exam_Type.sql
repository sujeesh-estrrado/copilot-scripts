IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Exam_Type](@flag bigint=0,@examType varchar(500)='''')
as begin
if(@flag=1)
begin
 select * from Tbl_Exam_Type where Exam_Type_DelStatus=0 and Active=1
 end
 end
   ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectMarkersMark]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_SelectMarkersMark]
(@marker varchar(50),@ExamCode varchar(100))
as
begin
select * from Tbl_Exam_Mark_Entry_Child where Marker=@marker and ExamCode=@ExamCode
     

      
end

    ')
END;

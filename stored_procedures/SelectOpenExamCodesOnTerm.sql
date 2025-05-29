IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectOpenExamCodesOnTerm]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SelectOpenExamCodesOnTerm]  
(@ExamTerm varchar(50),@SubjectId bigint)  
as  
Begin  
select distinct(GC.ExamCode) ExamCode from Tbl_GroupChangeExamDates GC  
inner join Tbl_Exam_Code_Child EC on EC.Exam_Code_final=GC.ExamCode
inner join  Tbl_Exam_Code_Master EM on EM.Exam_Code_Master_Id=EC.Exam_Code_Master_Id
  
where GC.ExamTerm=@ExamTerm and EM.Subject_Id=@SubjectId and GC.OpenStatus=1   
end

    ')
END;

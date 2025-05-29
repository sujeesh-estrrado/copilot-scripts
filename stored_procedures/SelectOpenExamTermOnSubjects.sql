IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectOpenExamTermOnSubjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SelectOpenExamTermOnSubjects] 
(@SubJectId bigint)  
as  
Begin  
select distinct(Exam_Term) ExamTerm from Tbl_GroupChangeExamDates GC 
inner join Tbl_Exam_Code_Child ECC on ECC.Exam_Code_final=GC.ExamCode
inner join Tbl_Exam_Code_Master ECM on ECM.Exam_Code_Master_Id=ECC.Exam_Code_Master_Id  
where ECM.Subject_Id=@SubJectId and GC.OpenStatus=1   
end

    ')
END;

IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectGradeSchemeAndPoitsForResult1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_SelectGradeSchemeAndPoitsForResult1]    
(@Candidate_Id bigint)    
as    
begin    
select distinct EC.Candidate_Id,(GS.Grade_Scheme) Grade_Scheme,GSS.Grade,GSS.GradePoint from Tbl_Exam_Mark_Entry_Child EC     
inner join  Tbl_StudentExamSubjectsChild SC on SC.ExamCode=EC.ExamCode    
inner join Tbl_GradingScheme GS on GS.Grade_Scheme=SC.GradingScherme    
inner join Tbl_GradeSchemeSetup GSS on GSS.Grade_Scheme_Id=GS.Grade_Scheme_Id    
         
where EC.Candidate_Id=@Candidate_Id     
          
end
    ')
END

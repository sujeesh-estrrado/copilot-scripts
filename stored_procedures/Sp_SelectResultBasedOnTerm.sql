IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectResultBasedOnTerm]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_SelectResultBasedOnTerm]  
        @Candidate_Id BIGINT  
        AS   
        BEGIN  
            SELECT 
                EC.ExamCode,
                SC.SubjectName,
                SC.CurrentStatus,
                SC.Term AS Exam_Term,
                EC.Candidate_Id,
                S.Contact_Hours AS timing,
                EC.Grade,
                GSS.GradePoint,
                S.Contact_Hours * GSS.GradePoint AS TotalGP 
            FROM 
                Tbl_Exam_Mark_Entry_Child EC  
            INNER JOIN 
                Tbl_StudentExamSubjectsChild SC ON EC.ExamCode = SC.ExamCode  
            INNER JOIN 
                Tbl_GradingScheme GS ON GS.Grade_Scheme = SC.GradingScherme  
            INNER JOIN 
                Tbl_GradeSchemeSetup GSS ON GSS.Grade_Scheme_Id = GS.Grade_Scheme_Id 
                AND EC.Grade = GSS.Grade  
            INNER JOIN 
                Tbl_GroupChangeExamDates GD ON GD.ExamCode = EC.ExamCode
            INNER JOIN 
                Tbl_Subject S ON SC.SubjectId = S.Subject_Id 
            WHERE 
                EC.Candidate_Id = @Candidate_Id  
        END
    ')
END

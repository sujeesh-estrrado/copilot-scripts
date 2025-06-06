IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectGradeSchemeAndPoitsForResult]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_SelectGradeSchemeAndPoitsForResult]  
        (@Candidate_Id bigint)  
        AS  
        BEGIN  
            SELECT DISTINCT EC.Candidate_Id,
                            GS.Grade_Scheme AS Grade_Scheme,
                            GSS.Grade,
                            GSS.GradePoint
            FROM Tbl_Exam_Mark_Entry_Child EC   
            INNER JOIN Tbl_StudentExamSubjectsChild SC ON SC.ExamCode = EC.ExamCode  
            INNER JOIN Tbl_GradingScheme GS ON GS.Grade_Scheme = SC.GradingScherme  
            INNER JOIN Tbl_GradeSchemeSetup GSS ON GSS.Grade_Scheme_Id = GS.Grade_Scheme_Id  
            WHERE EC.Candidate_Id = @Candidate_Id  
        END
    ')
END

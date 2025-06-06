IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_selectblockEntry]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_selectblockEntry] 
        (@Coursecode VARCHAR(50),
         @term VARCHAR(50))
        AS
        BEGIN
            ;WITH ExamData AS (
                SELECT DISTINCT 
                    ECM.Subject_Description,
                    ECM.Subject_Id,
                    ECM.Assessment_Code,
                    ECC.AssesmentType,
                    EMEC.Marker,
                    EMEC.Marks,
                    ECM.Exam_Term,
                    EMEC.IC_Passport,
                    EMEC.Name,
                    EMEC.Intake_Number,
                    EMEC.Grade,
                    EMEC.Course_Code,
                    GSS.GradePoint
                FROM dbo.Tbl_Exam_Code_Master ECM
                INNER JOIN dbo.Tbl_Exam_Code_Child ECC ON ECC.Exam_Code_Master_Id = ECM.Exam_Code_Master_Id
                INNER JOIN dbo.Tbl_Exam_Mark_Entry_Child EMEC ON EMEC.ExamCode = ECC.Exam_Code_final
                INNER JOIN Tbl_Subject S ON ECM.Subject_Id = S.Subject_Id
                INNER JOIN Tbl_Subject_Master SM ON SM.Subject_Master_Code_Id = S.Subject_Master_Code_Id
                INNER JOIN dbo.Tbl_GradingScheme GS ON GS.Grade_Scheme = SM.Grading_Scheme
                INNER JOIN dbo.Tbl_GradeSchemeSetup GSS ON GSS.Grade_Scheme_Id = GS.Grade_Scheme_Id 
                AND GSS.Grade = EMEC.Grade
            )

            -- First Select: Subject_Id and Subject_Description
            SELECT DISTINCT 
                A.Subject_Id,
                A.Subject_Description
            FROM ExamData A
            WHERE A.Course_Code = @Coursecode 
              AND A.Exam_Term = @term;

            -- Second Select: All details
            SELECT DISTINCT 
                ECM.Subject_Description,
                ECM.Subject_Id,
                ECM.Assessment_Code,
                ECC.AssesmentType,
                EMEC.Marker,
                EMEC.Marks,
                ECM.Exam_Term,
                EMEC.IC_Passport,
                EMEC.Name,
                EMEC.Intake_Number,
                EMEC.Grade,
                EMEC.Course_Code,
                GSS.GradePoint
            FROM dbo.Tbl_Exam_Code_Master ECM
            INNER JOIN dbo.Tbl_Exam_Code_Child ECC ON ECC.Exam_Code_Master_Id = ECM.Exam_Code_Master_Id
            INNER JOIN dbo.Tbl_Exam_Mark_Entry_Child EMEC ON EMEC.ExamCode = ECC.Exam_Code_final
            INNER JOIN Tbl_Subject S ON ECM.Subject_Id = S.Subject_Id
            INNER JOIN Tbl_Subject_Master SM ON SM.Subject_Master_Code_Id = S.Subject_Master_Code_Id
            INNER JOIN dbo.Tbl_GradingScheme GS ON GS.Grade_Scheme = SM.Grading_Scheme
            INNER JOIN dbo.Tbl_GradeSchemeSetup GSS ON GSS.Grade_Scheme_Id = GS.Grade_Scheme_Id 
            AND GSS.Grade = EMEC.Grade
            WHERE EMEC.Course_Code = @Coursecode 
              AND ECM.Exam_Term = @term;

            -- Third Select: Marker details
            SELECT DISTINCT 
                A.Marker
            FROM ExamData A
            WHERE A.Course_Code = @Coursecode 
              AND A.Exam_Term = @term;

            -- Fourth Select: Name, IC_Passport, and Intake_Number details
            SELECT DISTINCT 
                A.Name,
                A.IC_Passport,
                A.Intake_Number
            FROM ExamData A
            WHERE A.Course_Code = @Coursecode 
              AND A.Exam_Term = @term;

        END
    ')
END

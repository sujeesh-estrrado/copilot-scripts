IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectStudentontermandsubject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_SelectStudentontermandsubject]
        (
            @SubjectID BIGINT,
            @term VARCHAR(50)
        )
        AS
        BEGIN
            DECLARE @AssesmentCode VARCHAR(50)

            SET @AssesmentCode = (
                SELECT DISTINCT(SC.AssesmentCode) 
                FROM Tbl_StudentExamSubjectsChild SC 
                WHERE SC.SubjectId = @SubjectID 
                AND SC.Term = @term
            )

            SELECT DISTINCT 
                SC.AssesmentCode,
                SM.Candidate_Id, 
                CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName,
                CPD.AdharNumber,
                CS.Semester_Code,
                CB.Batch_Code
            FROM Tbl_StudentExamSubjectsChild SC
            INNER JOIN dbo.Tbl_StudentExamSubjectMaster SM 
                ON SC.StudentExamSubjectMasterId = SM.StudentExamSubjectMasterId
            INNER JOIN Tbl_Candidate_Personal_Det CPD 
                ON CPD.Candidate_Id = SM.Candidate_Id
            INNER JOIN dbo.Tbl_Course_Duration_Mapping DM 
                ON DM.Duration_Mapping_Id = SM.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails DP 
                ON DM.Duration_Period_Id = DP.Duration_Period_Id
            INNER JOIN Tbl_Course_Batch_Duration CB 
                ON CB.Batch_Id = DP.Batch_Id
            INNER JOIN dbo.Tbl_Course_Semester CS 
                ON CS.Semester_Id = DP.Semester_Id
            WHERE SC.SubjectId = @SubjectID 
            AND SC.Term = @term

            EXEC Sp_getasssesmentType @AssesmentCode
        END
    ')
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Candidates_BySemesterSubjectID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetAll_Candidates_BySemesterSubjectID]
    (
        @Semester_Subjects_Id BIGINT
    )
    AS
    BEGIN
        DECLARE @Parent_Id BIGINT;
        SET @Parent_Id = (
            SELECT Parent_Subject_Id 
            FROM Tbl_Semester_Subjects SS 
            INNER JOIN Tbl_Department_Subjects DS ON DS.Department_Subject_Id = SS.Department_Subjects_Id 
            INNER JOIN Tbl_Subject S ON S.Subject_Id = DS.Subject_Id
            WHERE SS.Semester_Subject_Id = @Semester_Subjects_Id
        );

        IF (@Parent_Id = 0)
        BEGIN
            SELECT      
                S.Candidate_Id,  
                S.Duration_Mapping_Id,
                SS.Semester_Subject_Id,  
                C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname AS [CandidateName],
                ISNULL(CIM.Internal_Marks, 0) AS Internal_Marks,
                CRN.RollNumber, 
                CUR.University_Regno,
                IM.Total_Marks, 
                IM.Min_Marks
            FROM Tbl_Student_Semester S    
            INNER JOIN Tbl_Candidate_Personal_Det C ON S.Candidate_Id = C.Candidate_Id    
            INNER JOIN dbo.Tbl_Semester_Subjects SS ON SS.Duration_Mapping_Id = S.Duration_Mapping_Id
            LEFT JOIN Tbl_Exam_Internal_Marks IM ON IM.Semester_Subject_Id = SS.Semester_Subject_Id
            LEFT JOIN Tbl_Exam_Candidate_Internal_Marks CIM ON CIM.Exam_InternalMarks_Id = IM.Exam_InternalMarks_Id AND CIM.Candidate_Id = C.Candidate_Id
            LEFT JOIN Tbl_Candidate_RollNumber CRN ON CRN.Candidate_Id = C.Candidate_Id
            LEFT JOIN dbo.Tbl_Candidate_University_Regno CUR ON CUR.Candidate_Id = C.Candidate_Id
            WHERE SS.Semester_Subject_Id = @Semester_Subjects_Id 
            AND Student_Semester_Delete_Status = 0
            AND Student_Semester_Current_Status = 1 
            AND C.Candidate_DelStatus = 0
            ORDER BY CandidateName;
        END
        ELSE
        BEGIN
            SELECT 
                SE.Candidate_Id,
                SE.Semester_Subjects_Id,
                SS.Duration_Mapping_Id,
                CP.Candidate_Fname + '' '' + CP.Candidate_Mname + '' '' + CP.Candidate_Lname AS [CandidateName],
                ISNULL(CIM.Internal_Marks, 0) AS Internal_Marks,
                IM.Total_Marks,
                IM.Min_Marks,
                CRN.RollNumber, 
                CUR.University_Regno
            FROM dbo.Tbl_Semester_Elective_Students SE
            INNER JOIN Tbl_Semester_Subjects SS ON SE.Semester_Subjects_Id = SS.Semester_Subject_Id
            INNER JOIN Tbl_Candidate_Personal_Det CP ON SE.Candidate_Id = CP.Candidate_Id
            LEFT JOIN Tbl_Exam_Internal_Marks IM ON IM.Semester_Subject_Id = SS.Semester_Subject_Id
            LEFT JOIN Tbl_Exam_Candidate_Internal_Marks CIM ON CIM.Exam_InternalMarks_Id = IM.Exam_InternalMarks_Id AND CIM.Candidate_Id = CP.Candidate_Id
            LEFT JOIN Tbl_Candidate_RollNumber CRN ON CRN.Candidate_Id = SE.Candidate_Id
            LEFT JOIN dbo.Tbl_Candidate_University_Regno CUR ON CUR.Candidate_Id = SE.Candidate_Id
            WHERE SE.Semester_Subjects_Id = @Semester_Subjects_Id 
            AND CP.Candidate_DelStatus = 0;
        END
    END
    ')
END
GO

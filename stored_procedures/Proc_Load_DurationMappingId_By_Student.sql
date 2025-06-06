IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Load_DurationMappingId_By_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Load_DurationMappingId_By_Student] (@Candidate_Id BIGINT)
        AS
        BEGIN
            SELECT DISTINCT
                CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS StudentName,
                SS.Candidate_Id,
                cdm.Duration_Mapping_Id,
                Batch_Code + ''-'' + Semester_Code AS BatchSemester
            FROM 
                dbo.Tbl_Student_Semester SS
            INNER JOIN 
                Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SS.Candidate_Id
            INNER JOIN 
                Tbl_Course_Duration_Mapping cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id
            INNER JOIN 
                Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id
            INNER JOIN 
                Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdp.Batch_Id
            INNER JOIN 
                Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id
            WHERE 
                SS.Candidate_Id = @Candidate_Id
                AND SS.Student_Semester_Delete_Status = 0
                AND SS.Student_Semester_Current_Status = 1
        END
    ')
END

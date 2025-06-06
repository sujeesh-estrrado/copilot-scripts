IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetStudentOverallPerformanceGraph]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetStudentOverallPerformanceGraph]
            @Candidate_Id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;
            
            SELECT 
                SUM(SP.Marks) AS Marks,
                SP.Duration_Mapping_Id,
                SP.Candidate_Id,
                cs.Semester_Code
            FROM LMS_Tbl_StudPerformance SP
            INNER JOIN Tbl_Course_Duration_Mapping cdm 
                ON cdm.Duration_Mapping_Id = SP.Duration_Mapping_Id
            INNER JOIN Tbl_Course_Duration_PeriodDetails cdp 
                ON cdm.Duration_Period_Id = cdp.Duration_Period_Id
            INNER JOIN Tbl_Course_Batch_Duration cbd 
                ON cbd.Batch_Id = cdp.Batch_Id
            INNER JOIN Tbl_Course_Semester cs 
                ON cs.Semester_Id = cdp.Semester_Id
            INNER JOIN Tbl_Course_Department CD 
                ON cdm.Course_Department_Id = CD.Course_Department_Id
            WHERE SP.Candidate_Id = @Candidate_Id
            GROUP BY SP.Duration_Mapping_Id, SP.Candidate_Id, cs.Semester_Code;
        END
    ')
END;

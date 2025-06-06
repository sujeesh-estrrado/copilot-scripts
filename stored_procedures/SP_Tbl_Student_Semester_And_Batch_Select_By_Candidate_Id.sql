IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Semester_And_Batch_Select_By_Candidate_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Student_Semester_And_Batch_Select_By_Candidate_Id] 
        @Candidate_Id bigint
        AS
        BEGIN
            SELECT DISTINCT 
                d.Department_Id,
                Department_Name,
                SS.Duration_Mapping_Id,
                SR.Department_Id,
                SR.Course_Category_Id,
                SS.Student_Semester_Id,
                CD.Course_Department_Id,
                CBD.Batch_Code
            FROM Tbl_Student_Semester SS
            INNER JOIN dbo.Tbl_Student_Registration SR ON SS.Candidate_Id = SR.Candidate_Id
            INNER JOIN dbo.Tbl_Course_Department CD ON SR.Department_Id = CD.Department_Id 
                AND SR.Course_Category_Id = CD.Course_Category_Id
            INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SS.Candidate_Id
            INNER JOIN dbo.tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
            INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id
            INNER JOIN dbo.Tbl_Course_Department CDP ON CDP.Department_Id = NA.Department_Id
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDPD ON CDPD.Batch_Id = CBD.Batch_Id
            INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Period_Id = CDPD.Duration_Period_Id
            INNER JOIN Tbl_Department d ON d.Department_Id = CDP.Department_Id
            WHERE SS.Candidate_Id = @Candidate_Id
            AND SS.Student_Semester_Current_Status = 1
        END
    ')
END

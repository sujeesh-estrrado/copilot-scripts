IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetStudentsBy_CourseId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetStudentsBy_CourseId]
            @Course_Id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;
            
            SELECT 
                C.Course_Name,
                SC.Student_id,
                CPD.Candidate_Fname + '' '' + 
                CPD.Candidate_Mname + '' '' + 
                CPD.Candidate_Lname AS Candidate_Name
            FROM LMS_Tbl_Student_Course SC 
            INNER JOIN LMS_Tbl_Course C 
                ON SC.Course_Id = C.Course_Id
            INNER JOIN Tbl_Candidate_Personal_Det CPD 
                ON CPD.Candidate_Id = SC.Student_id
            WHERE SC.Course_Id = @Course_Id 
              AND SC.Approval_Status = 1;
        END
    ')
END;

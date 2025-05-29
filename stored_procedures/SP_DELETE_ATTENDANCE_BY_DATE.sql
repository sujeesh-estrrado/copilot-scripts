IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_ATTENDANCE_BY_DATE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_DELETE_ATTENDANCE_BY_DATE]
    @Course_department_id BIGINT,
    @DateofAttendance DATETIME,
    @SemesterSubjectId BIGINT,
    @ClassTimingId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Tbl_Student_Absence
    SET DeleteStatus = 1
    WHERE Subject_Id = @SemesterSubjectId
      AND Class_Timings_Id = @ClassTimingId
      AND Absent_Date = @DateofAttendance
      AND Course_Department_Id = @Course_department_id
      AND DeleteStatus = 0; 

   SELECT @@ROWCOUNT AS RowsAffected;
END;
    ')
END;

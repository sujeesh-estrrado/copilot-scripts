IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_STUDENTS_Attendance_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
           
create PROCEDURE [dbo].[SP_GET_STUDENTS_Attendance_Details] 
(
    @Course_department_id BIGINT,
    @Employee_Id BIGINT,                                   
    @BatchId BIGINT, 
    @Candidate_Id BIGINT,                                   
    @DateofAttendance DATETIME,                         
    @SemesterSubjectId BIGINT,              
    @Class_Timings_Id BIGINT 
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Absent_Type, 
        Remark 
    FROM 
        Tbl_Student_Absence 
    WHERE 
        Candidate_Id = @Candidate_Id
        AND Absent_Date = @DateofAttendance
        AND Subject_Id = @SemesterSubjectId
        AND Class_Timings_Id = @Class_Timings_Id
        AND Employee_Id = @Employee_Id
        and Course_Department_Id=@Course_department_id
        and Duration_Mapping_Id=@BatchId;
END
');
END;

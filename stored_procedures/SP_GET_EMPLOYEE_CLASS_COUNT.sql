IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPLOYEE_CLASS_COUNT]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GET_EMPLOYEE_CLASS_COUNT]
(
    @WeekDay_Settings_Id BIGINT,
    @Class_Timings_Id BIGINT,
    @Employee_Id BIGINT,
    @Day_Id BIGINT,
    @Semester_Subject_Id BIGINT
)
AS
BEGIN 
    -- Check if the employee already has a class for the given time slot
    IF EXISTS (
        SELECT 1
        FROM Tbl_Class_TimeTable
        WHERE Employee_Id = @Employee_Id
          AND Day_Id = @Day_Id
          AND Class_Timings_Id = @Class_Timings_Id
          AND Semster_Subject_Id = @Semester_Subject_Id
		  AND Del_Status=0
    )
    BEGIN
        -- Get Employee Name
        SELECT 2 AS ReturnValue, E.Employee_FName AS EmployeeName
        FROM Tbl_Class_TimeTable T
        JOIN Tbl_Employee E ON T.Employee_Id = E.Employee_Id
        WHERE T.Employee_Id = @Employee_Id
        AND   T.Del_Status=0;
        RETURN;
    END

    -- Check if the class time slot is already taken by another employee or subject
    IF EXISTS (
        SELECT 1
        FROM Tbl_Class_TimeTable
        WHERE Class_Timings_Id = @Class_Timings_Id
          AND Day_Id = @Day_Id  AND   Del_Status=0
          AND (Employee_Id != @Employee_Id OR Semster_Subject_Id != @Semester_Subject_Id)
    )
    BEGIN 
        SELECT 3 AS ReturnValue, NULL AS EmployeeName;
        RETURN;
    END

    -- Return 0 if the class time slot is available for the employee
    SELECT 0 AS ReturnValue, NULL AS EmployeeName;
END

'

);
END;

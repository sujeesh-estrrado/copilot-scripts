IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_CheckEmployeeAllocation_TimeTable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_CheckEmployeeAllocation_TimeTable]
(
    @EmployeeId bigint, 
    @WeekDay_Settings_Id bigint,    
    @Duration_Mapping_Id bigint,
    @Class_Timings_Id bigint,
    @DepartmentId bigint,
    @SemesterSubjectsID bigint 
)
AS
BEGIN
    DECLARE @NewStartTime DATETIME, @NewEndTime DATETIME;

    -- Get the start and end time for the Class_Timings_Id passed
    SELECT @NewStartTime = CC.Start_Time, @NewEndTime = CC.End_Time
    FROM Tbl_Customize_ClassTiming CC
    WHERE CC.Customize_ClassTimingId = @Class_Timings_Id;

    -- Now check if the employee is already assigned in the same department, batch, and subject with overlapping class timings
    IF EXISTS (
        SELECT 1
        FROM Tbl_Class_TimeTable C
        INNER JOIN Tbl_Customize_ClassTiming CC
            ON C.Class_Timings_Id = CC.Customize_ClassTimingId
        WHERE C.Employee_Id = @EmployeeId
          AND C.Department_Id = @DepartmentId
          AND C.Duration_Mapping_Id = @Duration_Mapping_Id
          AND C.Class_Timings_Id != @Class_Timings_Id  -- Ensure weare checking existing allocations (excluding the current one)
          AND (
              -- Check if the new class timing overlaps with an existing one
              (@NewStartTime < CC.End_Time AND @NewEndTime > CC.Start_Time)
          )
    )
    BEGIN
        -- If a match is found, return -1 to indicate a conflict
        SELECT -1 AS ConflictResult;
    END
    ELSE
    BEGIN
        -- No conflict, return 0 (success)
        SELECT 0 AS ConflictResult;
    END
END
    ')
END

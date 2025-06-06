IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[CheckClassAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[CheckClassAllocation]
            @Semster_Subject_Id BIGINT,
            @Duration_Mapping_Id BIGINT,
            @WeekDay_Settings_Id BIGINT,
            @Class_Timings_Id BIGINT,
            @Employee_Id BIGINT,
            @Day_Id BIGINT,
            @Department_Id BIGINT,
            @Location_Id BIGINT = 0
        AS
        BEGIN
          

            DECLARE @ReturnValue INT;
            DECLARE @New_Start_Time DATETIME;
            DECLARE @New_End_Time DATETIME;
            DECLARE @Employee_FName NVARCHAR(100);

            -- Get the new start and end times into variables
            SELECT 
                @New_Start_Time = Start_Time,
                @New_End_Time = End_Time
            FROM Tbl_Customize_ClassTiming
            WHERE Customize_ClassTimingId = @Class_Timings_Id;

            -- Get the Employee Name
            SELECT @Employee_FName = Employee_FName 
            FROM Tbl_Employee
            WHERE Employee_Id = @Employee_Id;

            -- Check if there is an overlapping class for the same employee, batch, and department
            IF EXISTS (
                SELECT 1
                FROM Tbl_Class_TimeTable AS tct
                JOIN Tbl_Customize_ClassTiming AS tcct
                    ON tct.Class_Timings_Id = tcct.Customize_ClassTimingId
                WHERE tct.Employee_Id = @Employee_Id
                  AND tct.Duration_Mapping_Id = @Duration_Mapping_Id
                  AND tct.Department_Id = @Department_Id
                  AND tct.Day_Id = @Day_Id
                  AND tct.Del_Status = 0
                  AND (
                      -- Check for overlapping time slots
                      CAST(tcct.Start_Time AS TIME) < CAST(@New_End_Time AS TIME) 
                      AND CAST(tcct.End_Time AS TIME) > CAST(@New_Start_Time AS TIME)
                  )
            )
            BEGIN
                SET @ReturnValue = -1;  -- Conflict found
            END
            ELSE
            BEGIN
                SET @ReturnValue = 1;  -- No conflict
            END

            -- Return the value along with the employee name
            SELECT @ReturnValue AS ReturnValue, @Employee_FName AS EmployeeName;
        END
    ')
END

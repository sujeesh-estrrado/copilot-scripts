IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Merged_ClassTimeTable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Insert_Merged_ClassTimeTable]
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
    SET NOCOUNT ON;
    
    DECLARE @New_Start_Time DATETIME;
    DECLARE @New_End_Time DATETIME;
    DECLARE @ConflictingClassId BIGINT = 0;
    
    -- Get the new start and end times
    SELECT 
        @New_Start_Time = Start_Time,
        @New_End_Time = End_Time
    FROM Tbl_Customize_ClassTiming
    WHERE Customize_ClassTimingId = @Class_Timings_Id;
    
    -- Find any conflicting class for the same employee and day
    SELECT @ConflictingClassId = tct.Class_TimeTable_Id
    FROM Tbl_Class_TimeTable AS tct
    JOIN Tbl_Customize_ClassTiming AS tcct
        ON tct.Class_Timings_Id = tcct.Customize_ClassTimingId
    WHERE tct.Employee_Id = @Employee_Id 
    AND tct.Day_Id = @Day_Id
    AND tct.Del_Status = 0
    AND (
        CAST(tcct.Start_Time AS TIME) < CAST(@New_End_Time AS TIME) 
        AND CAST(tcct.End_Time AS TIME) > CAST(@New_Start_Time AS TIME)
    );
    
    -- If conflicting class exists, update its merged_status to 1
    IF @ConflictingClassId IS NOT NULL AND @ConflictingClassId <> 0
    BEGIN
        UPDATE Tbl_Class_TimeTable
        SET merged_status = 1
        WHERE Class_TimeTable_Id = @ConflictingClassId;
    END
     
    -- Insert the new merged class with merged_status = 1
    INSERT INTO Tbl_Class_TimeTable
        (Semster_Subject_Id, Duration_Mapping_Id, WeekDay_Settings_Id, 
         Class_Timings_Id, Employee_Id, Class_TimeTable_Status, 
         Day_Id, Location_Id, Department_Id, Del_Status, merged_status)
    VALUES
        (@Semster_Subject_Id, @Duration_Mapping_Id, @WeekDay_Settings_Id, 
         @Class_Timings_Id, @Employee_Id, 0, 
         @Day_Id, @Location_Id, @Department_Id, 0, 1);
END
');
END;

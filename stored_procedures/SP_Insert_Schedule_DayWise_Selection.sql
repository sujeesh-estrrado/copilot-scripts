IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Schedule_DayWise_Selection]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Insert_Schedule_DayWise_Selection]
    @ScheduleId bigint,
    @Date date,
    @StartTime varchar(50),
    @EndTime varchar(50),
    @IsDeleted bit
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Convert string times to TIME for proper comparison
    DECLARE @StartTimeValue TIME, @EndTimeValue TIME
    
    BEGIN TRY
        SET @StartTimeValue = CONVERT(TIME, @StartTime)
        SET @EndTimeValue = CONVERT(TIME, @EndTime)
    END TRY
    BEGIN CATCH
        RAISERROR(''Invalid time format. Please use format like "9:00 AM"'', 16, 1)
        RETURN
    END CATCH
    
    -- Check for duplicate day entries for the same schedule
    IF EXISTS (
        SELECT 1 FROM Tbl_Schedule_DayWise_Selection 
        WHERE ScheduleId = @ScheduleId 
        AND [Date] = @Date
        AND IsDeleted = 0
        AND StartTime = @StartTime
        AND EndTime = @EndTime
    )
    BEGIN
        RAISERROR(''This date and time slot is already scheduled for this course'', 16, 1);
        RETURN;
    END
    
    -- Check if end time is after start time (now using TIME comparison)
    IF @EndTimeValue <= @StartTimeValue
    BEGIN
        RAISERROR(''End time must be after start time'', 16, 1);
        RETURN;
    END
    
    INSERT INTO Tbl_Schedule_DayWise_Selection (
        ScheduleId, [Date], StartTime, EndTime, IsDeleted
    )
    VALUES (
        @ScheduleId, @Date, @StartTime, @EndTime, 0
    );
END
    ')
END;

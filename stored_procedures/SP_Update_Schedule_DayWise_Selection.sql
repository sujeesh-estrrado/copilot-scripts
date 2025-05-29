IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Schedule_DayWise_Selection]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Update_Schedule_DayWise_Selection]
    @ScheduleId bigint,
    @Date date,
    @StartTime varchar(50),
    @EndTime varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Check if this date already exists (and is marked as deleted)
        IF EXISTS (
            SELECT 1 FROM Tbl_Schedule_DayWise_Selection 
            WHERE ScheduleId = @ScheduleId 
            AND [Date] = @Date
            AND IsDeleted = 1
        )
        BEGIN
            -- Undelete and update the existing entry
            UPDATE Tbl_Schedule_DayWise_Selection
            SET 
                StartTime = @StartTime,
                EndTime = @EndTime,
                IsDeleted = 0
            WHERE 
                ScheduleId = @ScheduleId 
                AND [Date] = @Date;
        END
        ELSE IF NOT EXISTS (
            SELECT 1 FROM Tbl_Schedule_DayWise_Selection 
            WHERE ScheduleId = @ScheduleId 
            AND [Date] = @Date
            AND IsDeleted = 0
        )
        BEGIN
            -- Insert new entry
            INSERT INTO Tbl_Schedule_DayWise_Selection (
                ScheduleId, [Date], StartTime, EndTime, IsDeleted
            )
            VALUES (
                @ScheduleId, @Date, @StartTime, @EndTime, 0
            );
        END
        ELSE
        BEGIN
            -- Update existing active entry
            UPDATE Tbl_Schedule_DayWise_Selection
            SET 
                StartTime = @StartTime,
                EndTime = @EndTime
            WHERE 
                ScheduleId = @ScheduleId 
                AND [Date] = @Date
                AND IsDeleted = 0;
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
    ')
END;

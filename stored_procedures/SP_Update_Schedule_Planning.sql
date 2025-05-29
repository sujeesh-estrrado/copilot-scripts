IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Schedule_Planning]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Update_Schedule_Planning]
    @ScheduleId bigint,
    @CourseId bigint,
    @MaxAllocation int,
    @SelectionType int,
    @TimeLine_FromDate date = NULL,
    @TimeLine_EndDate date = NULL,
    @TimeLine_StartTime varchar(50) = NULL,
    @TimeLine_EndTime varchar(50) = NULL,
    @Result int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
         
        UPDATE Tbl_Schedule_Planning 
        SET 
            CourseId = @CourseId,
            MaxAllocation = @MaxAllocation,
            SelectionType = @SelectionType,
            TimeLine_FromDate = @TimeLine_FromDate,
            TimeLine_EndDate = @TimeLine_EndDate,
            TimeLine_StartTime = @TimeLine_StartTime,
            TimeLine_EndTime = @TimeLine_EndTime
        WHERE Id = @ScheduleId;
         
        IF @SelectionType = 0
        BEGIN

            UPDATE Tbl_Schedule_DayWise_Selection
            SET IsDeleted = 1
            WHERE ScheduleId = @ScheduleId;
        END
        ELSE IF @SelectionType = 1
        BEGIN 

            UPDATE Tbl_Schedule_DayWise_Selection
            SET IsDeleted = 1
            WHERE ScheduleId = @ScheduleId;
        END

        SET @Result = 1;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Result = 0;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
    ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Schedule_Planning]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Insert_Schedule_Planning]
    @CourseId bigint,
    @MaxAllocation int,
    @SelectionType int,
    @TimeLine_FromDate date = NULL,
    @TimeLine_EndDate date = NULL,
    @TimeLine_StartTime varchar(50),
    @TimeLine_EndTime varchar(50),
    @ScheduleId bigint OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check for duplicate entries (example: same course with same timeline)
    IF @SelectionType = 1 -- Timeline selection
    BEGIN
        IF EXISTS (
            SELECT 1 FROM Tbl_Schedule_Planning 
            WHERE CourseId = @CourseId 
            AND SelectionType = 1 
            AND TimeLine_FromDate = @TimeLine_FromDate 
            AND TimeLine_EndDate = @TimeLine_EndDate
            AND Isdeleted = 0
        )
        BEGIN
            RAISERROR(''A schedule with the same timeline already exists for this course'', 16, 1);
            RETURN -1; -- Return error code
        END
    END
     
    IF @SelectionType = 0  
    BEGIN 
        SET @TimeLine_StartTime = ''00:00:00''
        SET @TimeLine_EndTime = ''00:00:00''
    END
    
    INSERT INTO Tbl_Schedule_Planning (
        CourseId,
        MaxAllocation,
        SelectionType,
        TimeLine_FromDate,
        TimeLine_EndDate,
        TimeLine_StartTime,
        TimeLine_EndTime,
        Isdeleted
    )
    VALUES (
        @CourseId,
        @MaxAllocation,
        @SelectionType,
        @TimeLine_FromDate,
        @TimeLine_EndDate,
        @TimeLine_StartTime,
        @TimeLine_EndTime,
        0
    );
    
    
    SET @ScheduleId = SCOPE_IDENTITY();
     
    SELECT @ScheduleId AS ScheduleId, 1 AS Result;
END
    ')
END;

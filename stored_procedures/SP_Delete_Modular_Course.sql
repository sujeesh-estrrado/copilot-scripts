IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Modular_Course]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Delete_Modular_Course]
(
    @CourseId BIGINT,
    @ScheduleId BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Result INT;

    IF EXISTS (
        SELECT 1
        FROM Tbl_Modular_Candidate_Details
        WHERE Modular_Course_Id = @CourseId AND Delete_Status = 0
    )
    BEGIN 
        SET @Result = -1;
    END
    ELSE
    BEGIN
        UPDATE Tbl_Schedule_Planning
        SET isdeleted = 1
        WHERE Id = @ScheduleId;

        UPDATE Tbl_Schedule_DayWise_Selection
        SET isdeleted = 1
        WHERE ScheduleId = @ScheduleId;

        SET @Result = 1;
    END

    SELECT @Result AS Result;   
END
    ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Update_schedule_details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Update_schedule_details]
    @scheduleid BIGINT = 0,
    @venue BIGINT = 0,
    @chef BIGINT = 0,
    @totalstudent BIGINT = 0,
    @scheduledet BIGINT = 0
AS
BEGIN
    -- Only update if something is actually different
    IF EXISTS (
        SELECT 1
        FROM Tbl_Exam_Schedule_Details
        WHERE Exam_Schedule_Details_Id = @scheduledet
          AND (
                Exam_Schedule_Id <> @scheduleid OR 
                ChiefInvigilator <> @chef OR 
                Total_student_requested <> @totalstudent OR 
                Venue <> @venue
              )
    )
    BEGIN
        UPDATE Tbl_Exam_Schedule_Details
        SET 
            Exam_Schedule_Id = @scheduleid,
            ChiefInvigilator = @chef,
            Total_student_requested = @totalstudent,
            Venue = @venue
        WHERE Exam_Schedule_Details_Id = @scheduledet

        SELECT 1 AS Result  -- success, actual update happened
    END
    ELSE
    BEGIN
        SELECT 0 AS Result  -- no update was needed
    END
END
    ')
END;

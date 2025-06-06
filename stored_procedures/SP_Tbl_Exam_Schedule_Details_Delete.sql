IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Exam_Schedule_Details_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Exam_Schedule_Details_Delete]
        @Exam_Schedule_Details_Id bigint
        AS
        BEGIN
            -- Delete the record from Tbl_Exam_Schedule_Details table
            DELETE FROM Tbl_Exam_Schedule_Details
            WHERE Exam_Schedule_Details_Id = @Exam_Schedule_Details_Id
        END
    ')
END

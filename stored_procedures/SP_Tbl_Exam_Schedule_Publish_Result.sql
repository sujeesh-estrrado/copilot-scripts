IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Exam_Schedule_Publish_Result]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Exam_Schedule_Publish_Result]
        @Exam_Schedule_Id bigint,
        @Is_Result_Published bit
        AS
        BEGIN
            -- Update the Exam Schedule table to set the result publication status
            UPDATE Tbl_Exam_Schedule
            SET Is_Result_Published = @Is_Result_Published
            WHERE Exam_Schedule_Id = @Exam_Schedule_Id;
        END
    ')
END

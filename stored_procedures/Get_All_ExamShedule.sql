IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_ExamShedule]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_All_ExamShedule]
        AS
        BEGIN
            
            
            SELECT * FROM Tbl_Exam_Schedule WHERE Exam_Schedule_Status = 0;
        END
    ')
END

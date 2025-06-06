-- Check and create 'get_attendance_table' procedure dynamically
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[get_attendance_table]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[get_attendance_table]
    @Exam_Master_id INT,
    @Course_Id INT,
    @Invigilator NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT 
        NC.Course_Id,
        R.Room_Name,
        ES.Exam_Schedule_Id,
        ESD.Exam_Schedule_Details_Id,                               
        CONVERT(VARCHAR, ES.Exam_Date, 103) AS Exam_Date,                                             
        CONVERT(VARCHAR(15), CAST(ES.Exam_Time_From AS TIME), 100) AS Exam_Time_From,                                        
        CONVERT(VARCHAR(15), CAST(ES.Exam_Time_To AS TIME), 100) AS Exam_Time_To,                                
        CONCAT(CONVERT(VARCHAR(15), CAST(ES.Exam_Time_From AS TIME), 100), '' - '', 
               CONVERT(VARCHAR(15), CAST(ES.Exam_Time_To AS TIME), 100)) AS Examtime                                
    FROM Tbl_Exam_Master EM                                  
    INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_Id = EM.Exam_Master_id                                  
    INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id                                
    INNER JOIN Tbl_New_Course NC ON NC.Course_Id = ES.Course_id                                 
    INNER JOIN Invigilator_Mapping IM ON IM.Exam_Schedule_Details_Id = ESD.Exam_Schedule_Details_Id                                
    INNER JOIN Tbl_Room R ON R.Room_Id = ESD.Venue                                
    WHERE EM.Publish_status = 2  
      AND EM.delete_status = 0 
      AND EM.Exam_Master_id = @Exam_Master_id 
      AND NC.Course_Id = @Course_Id 
      AND (IM.Employee_id = @Invigilator)                                
      AND IM.delete_status = 0;
END;
    ')
END;

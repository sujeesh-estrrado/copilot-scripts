IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Exam_Attendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Insert_Exam_Attendance]  
    @Exam_Schedule_Id INT,  
    @Exam_Schedule_Details_Id INT,  
    @Marked_By NVARCHAR(100),  
    @Attendance_SheetNo NVARCHAR(50),  
    @Attendance_Slno NVARCHAR(50)  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Check if the record already exists  
    IF NOT EXISTS (  
        SELECT 1  
        FROM Tbl_Exam_Attendance_Master  
        WHERE Exam_Schedule_Id = @Exam_Schedule_Id  
          AND Exam_Schedule_Details_Id = @Exam_Schedule_Details_Id  
          AND Marked_By = @Marked_By  
          AND Delete_Status = 0  
    )  
    BEGIN  
        -- Insert new record  
        INSERT INTO [dbo].[Tbl_Exam_Attendance_Master]  
        (Exam_Schedule_Id,  
         Exam_Schedule_Details_Id,  
         Marked_By,  
         Attendance_SheetNo,  
         Attnce_SerialNumber,  
         Approval_Status,  
         Created_Date,  
         Delete_Status)  
        VALUES  
        (@Exam_Schedule_Id,  
         @Exam_Schedule_Details_Id,  
         @Marked_By,  
         @Attendance_SheetNo,  
         @Attendance_Slno,  
         0, GETDATE(), 0);  

        -- Return the inserted record ID  
        SELECT SCOPE_IDENTITY() AS InsertedID;  
    END  
    ELSE  
    BEGIN  
        PRINT ''Record already exists'';  
    END  
END;');
END;

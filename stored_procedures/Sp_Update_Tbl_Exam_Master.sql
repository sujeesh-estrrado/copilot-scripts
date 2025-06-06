IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Tbl_Exam_Master]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Update_Tbl_Exam_Master]  
    @Exam_Master_id INT 
AS    
BEGIN  
    -- Update the Del_Status column to 1 for the given Exam_Master_id  
    UPDATE Tbl_Exam_Master  
    SET delete_status = 1  
    WHERE Exam_Master_id = @Exam_Master_id  
END
    ')
END;

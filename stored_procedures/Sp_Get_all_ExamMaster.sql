IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_ExamMaster]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_all_ExamMaster]  
        (     
        @flag bigint = 0      
        )                
        AS             
        BEGIN           
            IF (@flag = 0)      
            BEGIN         
                SELECT Exam_Master_id, Exam_Name 
                FROM Tbl_Exam_Master 
                WHERE delete_status = 0    
            END
        END
    ')
END

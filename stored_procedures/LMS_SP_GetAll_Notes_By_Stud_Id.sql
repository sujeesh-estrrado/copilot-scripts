IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Notes_By_Stud_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Notes_By_Stud_Id]  
            @Stud_Id BIGINT    
        AS    
        BEGIN    
            SET NOCOUNT ON;    

            SELECT * FROM (  
                -- Sent Notes  
                SELECT   
                    N.Note_Id,  
                    N.Note_Description,  
                    N.Note_Date,  
                    N.Stud_Emp_Id,  
                    ''Send'' AS Status  
                FROM LMS_Tbl_Notes N  
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id   
                WHERE N.Stud_Emp_Id = @Stud_Id  
                AND N.Stud_Emp_Status = 1  
              
                UNION  
              
                -- Received Notes  
                SELECT   
                    N.Note_Id,  
                    N.Note_Description,  
                    N.Note_Date,  
                    N.Stud_Emp_Id,  
                    ''Receive'' AS Status  
                FROM LMS_Tbl_Notes N  
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id   
                WHERE SN.Stud_Emp_Class_Id = @Stud_Id  
                AND SN.Stud_Emp_Class_Status = 1  
            ) AS Post   
            ORDER BY Note_Date DESC;  
        END
    ')
END

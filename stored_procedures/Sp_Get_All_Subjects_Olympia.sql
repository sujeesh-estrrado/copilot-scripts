IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Subjects_Olympia]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_Subjects_Olympia]              
        AS                                 
        BEGIN
            -- Select distinct Subjects data
            SELECT DISTINCT                  
                B.Subject_Id,                         
                B.Subject_Name as Subject_Name,                     
                B.Subject_Code as Subject_Code,                   
                B.Subject_Status as Subject_Status,                
                C.Subject_Master_Code as Master_Code,                
                C.Subject_Master_Code_Id as Master_Code_Id,                
                ISNULL((SELECT Subject_Name FROM Tbl_Subject WHERE Subject_Id = B.Parent_Subject_Id), '''') AS Parent_Subject                           

            FROM Tbl_Subject B
                LEFT JOIN Tbl_Subject A on A.Subject_Id = B.Subject_Id                
                LEFT JOIN Tbl_Subject_Master C on B.Subject_Master_Code_Id = C.Subject_Master_Code_Id
            WHERE A.Subject_Status = 0
            ORDER BY B.Subject_Id DESC
        END
    ')
END

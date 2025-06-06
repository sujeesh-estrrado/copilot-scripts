-- Check if the stored procedure [dbo].[Proc_GetDepartment_Subjects_ByProgramID] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDepartment_Subjects_ByProgramID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetDepartment_Subjects_ByProgramID]  
        @Course_Department_Id INT  
        AS  
        BEGIN  
            SELECT *  
            FROM (
                SELECT  
                    ROW_NUMBER() OVER (PARTITION BY D.Department_Id ORDER BY DS.Course_Department_Id) AS RNO,     
                    DS.Department_Subject_Id,    
                    D.Department_Id AS Course_Department_Id,    
                    DS.Subject_Id,    
                    D.Department_Name AS [Department Name]    
                FROM Tbl_Department_Subjects DS    
                INNER JOIN Tbl_Department D ON DS.Course_Department_Id = D.Department_Id    
                WHERE D.Department_Id = @Course_Department_Id  
            ) Temp_tbl  
            ORDER BY Department_Subject_Id DESC  
        END
    ')
END

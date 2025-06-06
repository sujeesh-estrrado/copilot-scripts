-- Check if the stored procedure [dbo].[Proc_GetAllDepartment_Subjects] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllDepartment_Subjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAllDepartment_Subjects] 
        (
            @facultyid bigint = 0
        )
        AS
        BEGIN  
            IF(@facultyid = 0)
            BEGIN 
                SELECT * 
                FROM    
                (
                    SELECT
                        ROW_NUMBER() OVER (PARTITION BY D.Department_Id ORDER BY DS.Course_Department_Id) AS RNO,     
                        DS.Department_Subject_Id,    
                        D.Department_Id AS Course_Department_Id,    
                        DS.Subject_Id,
                        D.Department_Status,    
                        D.Department_Name AS [Department Name]    
                    FROM Tbl_Department_Subjects DS    
                    INNER JOIN Tbl_Department D 
                        ON DS.Course_Department_Id = D.Department_Id    
                ) Temp_tbl    
                WHERE Temp_tbl.RNO = 1  
                    AND Temp_tbl.Department_Status = 0  
                ORDER BY Department_Subject_Id DESC  
            END
            ELSE
            BEGIN
                SELECT * 
                FROM    
                (
                    SELECT
                        ROW_NUMBER() OVER (PARTITION BY D.Department_Id ORDER BY DS.Course_Department_Id) AS RNO,     
                        DS.Department_Subject_Id,    
                        D.Department_Id AS Course_Department_Id,    
                        DS.Subject_Id,
                        D.Department_Status,    
                        D.Department_Name AS [Department Name]    
                    FROM Tbl_Department_Subjects DS    
                    INNER JOIN Tbl_Department D 
                        ON DS.Course_Department_Id = D.Department_Id    
                    INNER JOIN Tbl_Emp_CourseDepartment_Allocation EC 
                        ON EC.Allocated_CourseDepartment_Id = D.GraduationTypeId  
                ) Temp_tbl    
                WHERE Temp_tbl.RNO = 1   
                    AND Temp_tbl.Department_Status = 0   
                ORDER BY Department_Subject_Id DESC  
            END    
        END
    ')
END

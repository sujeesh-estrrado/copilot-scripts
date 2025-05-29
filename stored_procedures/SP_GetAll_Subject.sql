IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Subject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Subject]      
        AS      
        BEGIN      
            SELECT 
                B.Subject_Id,    
                B.Subject_Name,    
                B.Parent_Subject_Id,      
                ISNULL(A.Subject_Name, '''') AS [Parent Subject],      
                B.Subject_Code,
                B.Subject_Descripition,
                B.Subject_Date,   
                DS.Department_Subject_Id,  
                SS.Semester_Subject_Id,  
                CC.Course_Category_Name + '' '' + D.Department_Name AS Department,    
                CBD.Batch_Code + ''-'' + CS.Semester_Code AS Semester    
                    
            FROM Tbl_Subject B      
            LEFT JOIN Tbl_Subject A 
                ON A.Subject_Id = B.Parent_Subject_Id    
            INNER JOIN Tbl_Department_Subjects DS 
                ON DS.Subject_Id = B.Subject_Id    
            INNER JOIN Tbl_Semester_Subjects SS 
                ON SS.Department_Subjects_Id = DS.Department_Subject_Id    
            INNER JOIN Tbl_Course_Department CD 
                ON CD.Course_Department_Id = DS.Course_Department_Id    
            INNER JOIN Tbl_Course_Category CC 
                ON CC.Course_Category_Id = CD.Course_Category_Id    
            INNER JOIN Tbl_Department D 
                ON D.Department_Id = CD.Department_Id    
            INNER JOIN Tbl_Course_Duration_Mapping CDM 
                ON CDM.Duration_Mapping_Id = SS.Duration_Mapping_Id    
            INNER JOIN Tbl_Course_Duration_PeriodDetails CDP 
                ON CDP.Duration_Period_Id = CDM.Duration_Period_Id    
            INNER JOIN Tbl_Course_Batch_Duration CBD 
                ON CBD.Batch_Id = CDP.Batch_Id    
            INNER JOIN Tbl_Course_Semester CS 
                ON CS.Semester_Id = CDP.Semester_Id    
      
            WHERE B.Subject_Status = 0;      
        END
    ')
END

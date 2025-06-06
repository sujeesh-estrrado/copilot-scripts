IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Elective_With_SemesterStudents]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Elective_With_SemesterStudents] 
        (@Duration_Mapping_Id BIGINT)
        AS
        BEGIN
            SELECT       
                SS.Semester_Subject_Id,      
                SS.Duration_Mapping_Id,      
                SS.Department_Subjects_Id,      
                CDP.Batch_Id,      
                CDP.Semester_Id,      
                CDM.Course_Department_Id,    
                S.Subject_Name AS SubjectName      
            FROM 
                Tbl_Semester_Subjects SS      
            INNER JOIN 
                Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id      
            INNER JOIN 
                Tbl_Course_Duration_PeriodDetails CDP ON CDM.Duration_Period_Id = CDP.Duration_Period_Id      
            INNER JOIN 
                Tbl_Department_Subjects DS ON SS.Department_Subjects_Id = DS.Department_Subject_Id    
            INNER JOIN 
                Tbl_Subject S ON DS.Subject_Id = S.Subject_Id    
            WHERE 
                SS.Semester_Subjects_Status = 0 
                AND SS.Duration_Mapping_Id = @Duration_Mapping_Id 
                AND Parent_Subject_Id <> 0     
            ORDER BY 
                SubjectName;
        END
    ')
END

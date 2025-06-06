IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_MainSubjects_By_Duration_MappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_MainSubjects_By_Duration_MappingId]
        @Duration_Mapping_Id BIGINT,
        @CourseDepartmentID BIGINT
        AS
        BEGIN
            SELECT 
                CN.Course_Id AS Semester_Subject_Id,
                CN.Course_code AS Subject_Code,
                CONCAT(CN.Course_Code, ''-'', CN.Course_Name) AS SubjectName,
                COUNT(SS.Semester_Subject_Id) AS ChildCount 
            FROM 
                Tbl_Semester_Subjects SS
            INNER JOIN 
                Tbl_New_Course CN ON SS.Department_Subjects_Id = CN.Course_Id
            INNER JOIN 
                Tbl_Course_Duration_PeriodDetails CDP ON SS.Duration_Mapping_Id = CDP.Duration_Period_Id
            INNER JOIN 
                Tbl_Department_Subjects DS ON CN.Course_Id = DS.Subject_Id
            WHERE 
                CDP.Duration_Period_Id = @Duration_Mapping_Id
                AND DS.Course_Department_Id = @CourseDepartmentID
                AND SS.Semester_Subjects_Status = 0
                AND CN.Delete_Status = 0
            GROUP BY 
                CN.Course_Id,
                CN.Course_Name,
                CN.Course_code
            ORDER BY 
                SubjectName
        END
    ')
END

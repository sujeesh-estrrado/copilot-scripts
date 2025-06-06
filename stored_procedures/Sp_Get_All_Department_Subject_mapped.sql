IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Department_Subject_mapped]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_Department_Subject_mapped] 
        (@facultyid BIGINT = 0)
        AS
        BEGIN
            IF (@facultyid = 0)
            BEGIN
                -- Departments not mapped to subjects
                SELECT 
                    Department_Id, 
                    Department_Name 
                FROM 
                    Tbl_Department 
                WHERE 
                    Department_Id NOT IN (SELECT Course_Department_Id FROM Tbl_Department_Subjects) 
                    and Department_Status=0
                ORDER BY 
                    Department_Name;
            END
            ELSE
            BEGIN
                -- Departments mapped to subjects for a specific faculty
                SELECT 
                    Department_Id, 
                    Department_Name 
                FROM 
                    Tbl_Department D 
                INNER JOIN 
                    Tbl_Emp_CourseDepartment_Allocation EA 
                ON 
                    D.GraduationTypeId = EA.Allocated_CourseDepartment_Id  
                WHERE 
                    Department_Id NOT IN (SELECT Course_Department_Id FROM Tbl_Department_Subjects) 
                    AND EA.Employee_Id = @facultyid 
                    and Department_Status=0
                ORDER BY 
                    Department_Name;
            END
        END
    ')
END

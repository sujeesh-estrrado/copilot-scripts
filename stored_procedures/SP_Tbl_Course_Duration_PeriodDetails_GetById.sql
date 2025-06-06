IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_PeriodDetails_GetById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Duration_PeriodDetails_GetById]   
            @Duration_Mapping_Id bigint           
        AS              
        BEGIN              
            --SELECT * From (      
            SELECT               
                ROW_NUMBER() OVER (PARTITION BY cd.Duration_Period_Id ORDER BY cd.Duration_Period_Id) AS num,
                cd.Duration_Period_Id,
                cd.Batch_Id,
                cd.Semester_Id,
                Duration_Period_From,
                CDM.Duration_Mapping_Id,
                Duration_Period_To,
                Duration_Period_Status,
                Semester_Name,
                Semester_Code,
                AcademicYear,
                Batch_Code,
                CC.Course_Category_Name + ''-'' + D.Department_Name AS DepartmentName,
                Duration_Period_Active_Status
            FROM Tbl_Course_Duration_PeriodDetails cd               
            INNER JOIN Tbl_Course_Batch_Duration bd ON cd.Batch_Id = bd.Batch_Id              
            INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cd.Semester_Id             
            INNER JOIN Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Period_Id = cd.Duration_Period_Id              
            INNER JOIN Tbl_Course_Department Cdep ON Cdep.Course_Department_Id = CDM.Course_Department_Id           
            INNER JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = Cdep.Course_Category_Id          
            INNER JOIN Tbl_Department D ON D.Department_Id = Cdep.Department_Id            
            WHERE Duration_Period_Status = 0   
            AND Duration_Mapping_Id = @Duration_Mapping_Id   
            --)tbl                                 
            --WHERE tbl.num = 1         
            ORDER BY Duration_Period_Id DESC              
        END
    ')
END

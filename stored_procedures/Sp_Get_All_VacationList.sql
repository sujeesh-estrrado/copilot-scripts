IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_VacationList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_VacationList]
        AS
        BEGIN
            SELECT 
                v.*, 
                d.Department_Name,
                cbd.Batch_Code + ''-'' + cs.Semester_Code AS Batch_Name
            FROM 
                dbo.LMS_Tbl_Vacation v
            INNER JOIN 
                dbo.Tbl_Course_Department cd ON cd.Course_Department_Id = v.Department_Id
            INNER JOIN 
                dbo.Tbl_Department d ON cd.Department_Id = d.Department_Id
            INNER JOIN 
                dbo.Tbl_Course_Duration_Mapping cdm ON cdm.Duration_Mapping_Id = v.Batch_Id
            INNER JOIN 
                dbo.Tbl_Course_Duration_PeriodDetails cdp ON cdp.Duration_Period_Id = cdm.Duration_Period_Id
            INNER JOIN 
                dbo.Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id
            INNER JOIN 
                Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdp.Batch_Id
            WHERE 
                v.Del_Status = 0
        END
    ')
END

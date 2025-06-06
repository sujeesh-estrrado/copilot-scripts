IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_ClassTimeTable_Batch_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_ClassTimeTable_Batch_New]
        (
            @WeekDay_Settings_Id bigint,
            @Employee_Id bigint
        )
        AS
        BEGIN
            SELECT DISTINCT 
                E.Employee_FName + '' '' + E.Employee_LName AS EmployeeName,            
                CASE 
                    WHEN R.Room_Name IS NULL THEN ''Not Allocated''            
                    ELSE R.Room_Name            
                END AS Room_Name,      
                S.Subject_Name,
                CT.WeekDay_Settings_Id,
                LTRIM(RIGHT(CONVERT(VARCHAR(20), Cti.Start_Time, 100), 7)) + ''-'' +
                LTRIM(RIGHT(CONVERT(VARCHAR(20), Cti.End_Time, 100), 7)) AS time
            FROM  
                Tbl_Class_TimeTable CT
            INNER JOIN 
                Tbl_Employee E ON E.Employee_Id = CT.Employee_Id
            INNER JOIN 
                Tbl_Semester_Subjects SS ON SS.Semester_Subject_Id = CT.Semster_Subject_Id
            INNER JOIN  
                Tbl_Department_Subjects D ON D.Department_Subject_Id = SS.Department_Subjects_Id
            INNER JOIN 
                Tbl_Subject S ON S.Subject_Id = D.Subject_Id
            INNER JOIN 
                Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = CT.Duration_Mapping_Id
            INNER JOIN 
                Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id
            INNER JOIN 
                Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id
            INNER JOIN 
                Tbl_Course_Department CD ON CD.Course_Department_Id = CDM.Course_Department_Id
            INNER JOIN 
                Tbl_Course_Category CC ON CC.Course_Category_Id = CD.Course_Category_Id
            INNER JOIN 
                Tbl_Department DE ON DE.Department_Id = CD.Department_Id
            INNER JOIN 
                Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = cdp.Batch_Id
            INNER JOIN 
                Tbl_ClassTimings Cti ON CT.Class_Timings_Id = Cti.Class_Timings_Id
            LEFT JOIN 
                dbo.Tbl_Room R ON R.Room_Id = CT.Room_Id
            WHERE 
                CT.WeekDay_Settings_Id = @WeekDay_Settings_Id 
                AND CT.Employee_Id = @Employee_Id
        END
    ')
END

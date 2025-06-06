IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_active_weekday_employee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_active_weekday_employee] 
        @employeeid BIGINT
        AS
        BEGIN
            SELECT DISTINCT 
                wbm.WeekDay_Batch_Mapping_Id,
                ws.WeekDay_Settings_Id,
                ws.WeekDay_Name,
                ws.WeekDay_Code,
                wbm.WeekDay_Status
            FROM   
                dbo.Tbl_WeekDay_Batch_Mapping AS wbm  
            LEFT JOIN 
                dbo.Tbl_WeekDay_Settings AS ws ON ws.WeekDay_Settings_Id = wbm.WeekDay_Settings_Id 
            LEFT JOIN 
                dbo.Tbl_Class_TimeTable CT ON CT.WeekDay_Settings_Id = wbm.WeekDay_Batch_Mapping_Id
            WHERE 
                CT.Employee_Id = @employeeid;
        END
    ');
END

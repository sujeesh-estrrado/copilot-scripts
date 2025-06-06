IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_active_get_week_day_details_by_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_active_get_week_day_details_by_id]
        @duration_mapping_id BIGINT
        AS
        BEGIN
            SELECT wbm.WeekDay_Batch_Mapping_Id, 
                   Duration_Mapping_Id, 
                   ws.WeekDay_Settings_Id, 
                   ws.WeekDay_Name, 
                   ws.WeekDay_Code, 
                   wbm.WeekDay_Status
            FROM dbo.Tbl_WeekDay_Batch_Mapping AS wbm
            LEFT JOIN dbo.Tbl_WeekDay_Settings AS ws 
                ON ws.WeekDay_Settings_Id = wbm.WeekDay_Settings_Id
            WHERE wbm.Duration_Mapping_Id = @duration_mapping_id 
              AND wbm.WeekDay_Status = 1;
        END
    ');
END

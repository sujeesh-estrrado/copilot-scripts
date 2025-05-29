IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_get_week_day_details_by_id]')
    AND type = N'P'
)
BEGIN
    EXEC('
        create procedure [dbo].[sp_get_week_day_details_by_id] --270,22544  
@dep_id bigint,  
@duration_mapping_id bigint  
AS  
BEGIN  
   
select wbm.WeekDay_Batch_Mapping_Id,ws.WeekDay_Settings_Id,ws.WeekDay_Name,ws.WeekDay_Code,wbm.WeekDay_Status from   
dbo.Tbl_WeekDay_Batch_Mapping as wbm  
left join dbo.Tbl_WeekDay_Settings as ws on ws.WeekDay_Settings_Id=wbm.WeekDay_Settings_Id  
where wbm.Duration_Mapping_Id=@duration_mapping_id and wbm.Course_Department_Id=@dep_id  
END

    ')
END
GO

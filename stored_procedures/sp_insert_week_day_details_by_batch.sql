IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_week_day_details_by_batch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_insert_week_day_details_by_batch]   
@depid bigint,  
@duration_mapping_id bigint,  
@week_setting_id bigint,  
@week_day_status bigint  
AS  
BEGIN  
insert into dbo.Tbl_WeekDay_Batch_Mapping (Course_Department_Id,Duration_Mapping_Id,WeekDay_Settings_Id,WeekDay_Status)  
 values (@depid,@duration_mapping_id,@week_setting_id,@week_day_status)  
END
    ');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Update_week_day_setting_by_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Update_week_day_setting_by_id] --8,1
@WeekDay_Batch_Mapping_Id bigint,
@Week_Day_Status bit
AS
BEGIN
    UPDATE [Tbl_WeekDay_Batch_Mapping]  
   SET WeekDay_Status = @Week_Day_Status  
 WHERE WeekDay_Batch_Mapping_Id=@WeekDay_Batch_Mapping_Id 


END
    ')
END;

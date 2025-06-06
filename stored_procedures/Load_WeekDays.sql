IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Load_WeekDays]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Load_WeekDays]  
@WeekDay_Settings_Id bigint  
as  
begin  
  
select WeekDay_Name,Duration_Mapping_Id from    
Tbl_WeekDay_Settings ws     
inner join dbo.Tbl_WeekDay_Batch_Mapping wb on wb.WeekDay_Settings_Id=ws.WeekDay_Settings_Id     
where   wb.WeekDay_Batch_Mapping_Id=@WeekDay_Settings_Id  and wb.WeekDay_Status=1     
end  
    
    ')
END;
 
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Time_Table_Details_by_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_Time_Table_Details_by_Id] --22544    
@Duration_Mapping_Id bigint    
AS    
BEGIN    
select distinct ctt.Class_TimeTable_Id, ts.Subject_Name,    
LTRIM(RIGHT(CONVERT(VARCHAR(20), ct.Start_Time, 100), 7)) AS Start_Time ,    
LTRIM(RIGHT(CONVERT(VARCHAR(20), ct.End_Time, 100), 7)) as End_Time,    
WDS.WeekDay_Code,ctt.Semster_Subject_Id,RSM.Mapping_FromDate,RSM.Mapping_FromDate,RSM.Room_Id    
    
from dbo.Tbl_Class_TimeTable as ctt    
left join dbo.Tbl_Semester_Subjects as ss on ss.Semester_Subject_Id=ctt.Semster_Subject_Id    
left join dbo.Tbl_Department_Subjects as ds on ds.Subject_Id=ctt.Semster_Subject_Id    
left join dbo.Tbl_Subject as ts on ts.Subject_Id=ctt.Semster_Subject_Id    
left join dbo.Tbl_ClassTimings as Ct on Ct.Class_Timings_Id=ctt.Class_Timings_Id    
left join dbo.Tbl_WeekDay_Batch_Mapping as wdbs on wdbs.WeekDay_Batch_Mapping_Id=ctt.WeekDay_Settings_Id    
left join dbo.Tbl_WeekDay_Settings as WDS on WDS.WeekDay_Settings_Id=wdbs.WeekDay_Settings_Id    
left join dbo.Tbl_Room_Subject_Mapping as RSM on RSM.Class_TimeTable_Id=ctt.Class_TimeTable_Id
where ctt.Duration_Mapping_Id=@Duration_Mapping_Id    
     
END
    ');
END;

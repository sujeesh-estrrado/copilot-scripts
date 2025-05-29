IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Announcement]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_All_Announcement]  
AS  
BEGIN  
 select a.*,cbd.Batch_Code+''-''+cs.Semester_Code as BatchSemester,e.Employee_FName+'' ''+e.Employee_LName as TeacherName from dbo.LMS_Tbl_Announcement a   
 inner join dbo.Tbl_Course_Duration_Mapping dm on a.Duration_Mapping_Id=dm.Duration_Mapping_Id  
 inner join Tbl_Course_Duration_PeriodDetails cdp ON dm.Duration_Period_Id=cdp.Duration_Period_Id            
    inner join Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id       
    inner join Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id  
    inner join dbo.Tbl_Employee e on e.Employee_Id=a.Employee_Id where a.DelStatus=0     
    order by Till_Date asc   
  
END
    ');
END;

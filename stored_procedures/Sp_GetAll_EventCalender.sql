IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_EventCalender]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetAll_EventCalender]  
AS  
BEGIN  
 select ec.*,d.Department_Name,cbd.Batch_Code+''-''+cs.Semester_Code as Batch,im.User_Img,e.Employee_FName+'' ''+e.Employee_LName as Employee_Name from dbo.LMS_Tbl_EventCalender ec  
 inner join dbo.Tbl_Course_Department cd on cd.Course_Department_Id=ec.Department_Id  
 inner join dbo.Tbl_Department d on d.Department_Id=cd.Department_Id  
 inner join dbo.Tbl_Course_Duration_Mapping dm on dm.Duration_Mapping_Id=ec.Batch_Id   
 inner join dbo.Tbl_Course_Duration_PeriodDetails cdp on cdp.Duration_Period_Id=dm.Duration_Period_Id  
 inner join dbo.Tbl_Course_Semester cs on cs.Semester_Id=cdp.Semester_Id  
 inner join dbo.Tbl_Course_Batch_Duration cbd on cbd.Batch_Id=cdp.Batch_Id  
 left join LMS_Tbl_User_Image im on im.User_Id=ec.Employee_Id  
 left join dbo.Tbl_Employee e on e.Employee_Id=ec.Employee_Id where ec.Del_Status=0  
END

');
END;
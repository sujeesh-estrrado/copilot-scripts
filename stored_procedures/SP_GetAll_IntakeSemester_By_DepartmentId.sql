IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_IntakeSemester_By_DepartmentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_IntakeSemester_By_DepartmentId] --17,5    
(       
@Flag bigint=0,           
@Programme_Id bigint  =0  ,    
@Intake_Id   bigint  =0  ,    
@Semester_Id bigint  =0      
)               
AS                      
BEGIN                      
if(@Flag=0)    
begin    
 select distinct CS.Semester_Id,CS.Semester_Code    
 from Tbl_Department D    
left join  Tbl_Course_Batch_Duration BD on BD.Duration_Id=D.Department_Id    
left join Tbl_Course_Duration_PeriodDetails cd on cd.Batch_Id=BD.Batch_Id    
left join Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id     
where BD.Batch_DelStatus=0 and cd.Delete_Status=0 and cs.Semester_DelStatus=0     
and Cd.Batch_Id=@Intake_Id and D.Department_Id=@Programme_Id    
    
--select  CS.Semester_Id,CS.Semester_Code from Tbl_Course_Semester CS    
order by Semester_Id    
end    
if(@Flag=1)    
begin    
 select distinct CS.Semester_Id,CS.Semester_Code    
 from Tbl_Department D    
left join  Tbl_Course_Batch_Duration BD on BD.Duration_Id=D.Department_Id    
left join Tbl_Course_Duration_PeriodDetails cd on cd.Batch_Id=BD.Batch_Id    
left join Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id     
where BD.Batch_DelStatus=0 and cd.Delete_Status=0 and cs.Semester_DelStatus=0     
and Cd.Batch_Id=@Intake_Id and D.Department_Id=@Programme_Id  and CS.Semester_Id>=@Semester_Id    
    
order by Semester_Id    
end    
 END     
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetSemester_byINtakeMasterAndDepartmentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetSemester_byINtakeMasterAndDepartmentId]
(@pgmId bigint=0,@intake bigint=0)
as
begin
 select distinct CD.Duration_Period_Id , cs.Semester_Name 
 from Tbl_Department D    
left join  Tbl_Course_Batch_Duration BD on BD.Duration_Id=D.Department_Id    
left join Tbl_Course_Duration_PeriodDetails cd on cd.Batch_Id=BD.Batch_Id    
left join Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id     
where BD.Batch_DelStatus=0 and cd.Delete_Status=0 and cs.Semester_DelStatus=0     
and Cd.Batch_Id=@intake and D.Department_Id=@pgmId 

 end
');
END;
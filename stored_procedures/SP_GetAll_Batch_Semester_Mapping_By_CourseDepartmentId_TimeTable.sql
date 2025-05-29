IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Batch_Semester_Mapping_By_CourseDepartmentId_Attendance]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GetAll_Batch_Semester_Mapping_By_CourseDepartmentId_Attendance]                   
@Course_Department_Id bigint           ,
@EmployeeID bigint=0
AS                        
BEGIN   


if(@EmployeeID=0)
begin
select DISTINCT
 --cd.Duration_Period_Id as Duration_Mapping_Id,

cd.Duration_Period_Id as Duration_Mapping_Id,
 bd.Batch_From, bd.Batch_To, concat(bd.Batch_Code , ''-'' , cs.Semester_Code) AS BatchSemester
 from 
Tbl_Course_Duration_PeriodDetails AS cd 
  INNER JOIN  dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id
  INNER JOIN  dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cd.Semester_Id 
  INNER JOIN Tbl_Class_TimeTable ct on ct.Duration_Mapping_Id=cd.Duration_Period_Id
  where ct.Department_Id=@Course_Department_Id
 -- and ct.Employee_Id=@EmployeeID
end
else
begin
select DISTINCT
 --cd.Duration_Period_Id as Duration_Mapping_Id,

cd.Duration_Period_Id as Duration_Mapping_Id,
 bd.Batch_From, bd.Batch_To, concat(bd.Batch_Code , ''-'' , cs.Semester_Code) AS BatchSemester
 from 
Tbl_Course_Duration_PeriodDetails AS cd 
  INNER JOIN  dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id
  INNER JOIN  dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cd.Semester_Id 
  INNER JOIN Tbl_Class_TimeTable ct on ct.Duration_Mapping_Id=cd.Duration_Period_Id
  where ct.Department_Id=@Course_Department_Id
  and ct.Employee_Id=@EmployeeID
end
 

 END

    ')
END
GO

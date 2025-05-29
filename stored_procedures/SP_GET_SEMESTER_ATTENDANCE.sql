IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_SEMESTER_ATTENDANCE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE Procedure [dbo].[SP_GET_SEMESTER_ATTENDANCE]
@Department_Id bigint=null,
@Batch_Id bigint = null
as
begin

 select DISTINCT
 --cd.Duration_Period_Id as Duration_Mapping_Id,

cs.Semester_Code AS BatchSemester,
cs.Semester_Id as Semester_Id
 from 
Tbl_Course_Duration_PeriodDetails AS cd 
  --INNER JOIN  dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id
  INNER JOIN  dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cd.Semester_Id 
  INNER JOIN Tbl_Class_TimeTable ct on ct.Duration_Mapping_Id=cd.Duration_Period_Id
  where ct.Department_Id=@Department_Id and cd.Batch_Id=@Batch_Id
  end
						 ');
END;

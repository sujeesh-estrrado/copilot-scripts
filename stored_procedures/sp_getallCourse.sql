IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_getallCourse]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE  procedure [dbo].[sp_getallCourse]
@Semester_Id bigint=0,
@Batch_Id bigint=0
AS
BEGIN
	select Department_Subjects_Id
from Tbl_Semester_Subjects 
where Duration_Mapping_Id in (select Duration_Mapping_Id 
								from Tbl_Course_Duration_Mapping 
								where Duration_Period_Id in(select Duration_Period_Id 
																from Tbl_Course_Duration_PeriodDetails 
																where Batch_Id = @Batch_Id and Semester_Id !=@Semester_Id))

END

    ')
END

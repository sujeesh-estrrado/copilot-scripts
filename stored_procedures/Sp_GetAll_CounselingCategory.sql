IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_CounselingCategory]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[Sp_GetAll_CounselingCategory]
AS
BEGIN
	
	SELECT cc.Category_Id,cc.CategoryName,cc.Course_Department_Id,cc.CreatedDate,cc.Duration_Mapping_Id,cbd.Batch_Code+''-''+cs.Semester_Code as BatchSemester from dbo.LMS_Tbl_CounselingCategory cc
	inner join Tbl_Course_Duration_Mapping cdm on cdm.Duration_Mapping_Id=cc.Duration_Mapping_Id
	inner join Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id        
    inner join Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id   
	inner join Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id   
	order by BatchSemester
END');
END;
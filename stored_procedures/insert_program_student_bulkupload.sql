IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[insert_program_student_bulkupload]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[insert_program_student_bulkupload]

 @Department_Name NVARCHAR(255), 
    @Batch_Code NVARCHAR(50) ,
     @faculty NVARCHAR(255) 

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

 SELECT D.Department_Id,CBD.Batch_Id,  concat(D.Department_Id,''#'',CBD.Batch_Id) Department_Id,D.Department_Name,D.Department_Id DeptId,im.Batch_Code
--,IM.intake_month

 FROM Tbl_IntakeMaster IM
 left join Tbl_Course_Batch_Duration CBD ON CBD.IntakeMasterID = IM.id
 left join Tbl_Department D on D.Department_Id=  CBD.Duration_Id 
  left join tbl_course_level cl on  cl.Course_Level_Id =d.GraduationTypeId
 WHERE D.Department_Name = @Department_Name AND IM.Batch_Code = @Batch_Code and Course_Level_Name =@faculty;
END
    ')
END

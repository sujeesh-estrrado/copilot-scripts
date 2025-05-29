IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_InsertCourseLeads]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[sp_InsertCourseLeads]
@CandidateId bigint,
@DepartmentId bigint,
@BatchId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @CourseCategory bigint;
	declare @CourseLevel bigint;
	declare @NewAdmissionId bigint;
	set @CourseLevel = (select GraduationTypeId from Tbl_Department where Department_Id=@DepartmentId)
	set @CourseCategory = (select Program_Type_Id from Tbl_Department where Department_Id=@DepartmentId)

    -- Insert statements for procedure here

	insert into tbl_New_Admission(Course_Level_Id,Course_Category_Id,Department_Id,Batch_Id,Admission_Status)
	values(@CourseLevel,@CourseCategory,@DepartmentId,@BatchId,1)

	set @NewAdmissionId = SCOPE_IDENTITY();

	update Tbl_Lead_Personal_Det set New_Admission_Id=@NewAdmissionId where Candidate_Id=@CandidateId
	 
END
    ');
END;

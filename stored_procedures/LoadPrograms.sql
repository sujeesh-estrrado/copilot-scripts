IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadPrograms]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LoadPrograms]
@Intakeyear varchar(10)=''0'',
@Intakemonth varchar(10)=''0'',
@Faculty bigint=0,
@CourseLevel bigint=0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT   concat(D.Department_Id,''#'',CBD.Batch_Id) Department_Id,D.Department_Name,D.Department_Id DeptId
--,IM.intake_month

 FROM Tbl_IntakeMaster IM
 left join Tbl_Course_Batch_Duration CBD ON CBD.IntakeMasterID = IM.id
 left join Tbl_Department D on D.Department_Id=  CBD.Duration_Id
 WHERE (IM.intake_year = @Intakeyear or @Intakeyear =''0'')
 and (IM.intake_month = @Intakemonth OR @Intakemonth = ''0'')
 and (D.GraduationTypeId = @Faculty or @Faculty = 0)
 and (D.Program_Type_Id = @CourseLevel OR @CourseLevel=0) and IM.DeleteStatus=0
END
    ')
END;

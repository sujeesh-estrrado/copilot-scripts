IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadIntakes_years_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create PROCEDURE [dbo].[LoadIntakes_years_New]
@StudyMode varchar(50)=''0'',
@LevelOfStudy bigint=0,
@Faculty bigint=0,
@ProgramId bigint=0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

  select distinct im.intake_year from Tbl_IntakeMaster im
left join tbl_course_batch_duration cbd on cbd.intakemasterid=im.id
left join tbl_department d on d.department_id = cbd.duration_id
where 
cbd.Duration_Id=@ProgramId and d.Program_Type_Id=@LevelOfStudy and d.GraduationTypeId=@Faculty
and year(getdate()) <= convert(int,IM.intake_year)
END

   ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadIntakes_months_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[LoadIntakes_months_New]
@StudyMode varchar(50)=''0'',
@LevelOfStudy bigint=0,
@Faculty bigint=0,
@ProgramId bigint=0,
@IntakeYear bigint=0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

 SELECT distinct convert(int,IM.intake_month) intake_month
,(Select DateName( month , DateAdd( month , convert(int,IM.intake_month) , -1 ) )) month_name
  
  from Tbl_IntakeMaster im
left join tbl_course_batch_duration cbd on cbd.intakemasterid=im.id
left join tbl_department d on d.department_id = cbd.duration_id
where 
cbd.Duration_Id=@ProgramId and d.Program_Type_Id=@LevelOfStudy and d.GraduationTypeId=@Faculty
and cbd.Study_Mode=@StudyMode and im.intake_year=@IntakeYear
and year(getdate()) <= convert(int,IM.intake_year)

and  IM.Intro_Date <=GETDATE() AND IM.Close_Date>=GETDATE() 

END

   ')
END;

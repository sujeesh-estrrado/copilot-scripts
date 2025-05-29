IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_programBy_intakeMasterwithfeegroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_programBy_intakeMasterwithfeegroup](@IntakeMaster bigint,@faculty bigint)
as
begin

select distinct d.Department_Name,d.Department_Id from  Tbl_Department d
inner join tbl_course_batch_duration cb on cb.Duration_Id =d.Department_Id
inner join fee_group fg on fg.programid=d.Department_Id and fg.programIntakeID=cb.Batch_Id 
inner join Tbl_IntakeMaster im on im.id=cb.IntakeMasterID where d.Delete_Status=0 and im.id=@IntakeMaster and d.GraduationTypeId=@faculty
end

');
END;

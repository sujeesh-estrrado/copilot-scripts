IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migration_update_student_registration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migration_update_student_registration](@intake bigint=0,@studentid bigint=0,@semester bigint=0,@courseid bigint=0)
as
begin
if(@semester>0)
begin
    if exists(select * from Tbl_Course_Duration_PeriodDetails where Batch_Id=(select Batch_Id from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and Semester_Id=@semester)
    begin
        if exists(select * from Tbl_Course_Duration_Mapping where Duration_Period_Id=(select min(Duration_Period_Id) from Tbl_Course_Duration_PeriodDetails where Batch_Id=(select Batch_Id from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and Semester_Id=@semester))
begin
update Tbl_Student_Semester set Duration_Mapping_Id=(select min(Duration_Mapping_Id) from  Tbl_Course_Duration_Mapping  M left join Tbl_Course_Duration_PeriodDetails P on P.Duration_Period_Id=M.Duration_Period_Id
         where p.Batch_Id=(select MIN(Batch_Id) from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and p.Semester_Id=@semester)
end
else
begin
insert into Tbl_Course_Duration_Mapping(Org_Id,Duration_Period_Id,Course_Department_Id,Course_Department_Status,Delete_Status) values(1,(select min(Duration_Period_Id) from Tbl_Course_Duration_PeriodDetails where Batch_Id=(select Batch_Id from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and Semester_Id=@semester),@courseid,0,0)
update Tbl_Student_Semester set Duration_Mapping_Id=(select min(Duration_Mapping_Id) from  Tbl_Course_Duration_Mapping  M left join Tbl_Course_Duration_PeriodDetails P on P.Duration_Period_Id=M.Duration_Period_Id
         where p.Batch_Id=(select min(Batch_Id) from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and p.Semester_Id=@semester)
end
    end
end
else
begin
insert Tbl_Course_Duration_PeriodDetails(Org_Id,Batch_Id,Semester_Id,Delete_Status) values (1,(select Batch_Id from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake),@semester,0)
if exists(select * from Tbl_Course_Duration_Mapping where Duration_Period_Id=(select min(Duration_Period_Id) from Tbl_Course_Duration_PeriodDetails where Batch_Id=(select MIN(Batch_Id )from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and Semester_Id=@semester))
begin
update Tbl_Student_Semester set Duration_Mapping_Id=(select min(Duration_Mapping_Id) from  Tbl_Course_Duration_Mapping  M left join Tbl_Course_Duration_PeriodDetails P on P.Duration_Period_Id=M.Duration_Period_Id
         where p.Batch_Id=(select MIN(Batch_Id) from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and p.Semester_Id=@semester)where Candidate_Id=@studentid
end
else
begin
insert into Tbl_Course_Duration_Mapping(Org_Id,Duration_Period_Id,Course_Department_Id,Course_Department_Status,Delete_Status) values(1,(select min(Duration_Period_Id) from Tbl_Course_Duration_PeriodDetails where Batch_Id=(select MIN(Batch_Id) from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and Semester_Id=@semester),@courseid,0,0)
update Tbl_Student_Semester set Duration_Mapping_Id=(select min(Duration_Mapping_Id) from  Tbl_Course_Duration_Mapping  M left join Tbl_Course_Duration_PeriodDetails P on P.Duration_Period_Id=M.Duration_Period_Id
         where p.Batch_Id=(select min(Batch_Id) from Tbl_Course_Batch_Duration where Duration_Id=@courseid and IntakeMasterID=@intake) and p.Semester_Id=@semester) where Candidate_Id=@studentid
end
end
end

');
END
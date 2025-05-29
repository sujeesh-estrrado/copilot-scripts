IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migration_intake_semester_mapping_test]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migration_intake_semester_mapping_test] (@intake bigint ,@semester bigint,@startdate datetime,@enddate datetime,@courseid bigint,@subjectid  bigint)
as
declare @intakeid bigint=0;
begin
	set @intakeid=(select min(Batch_Id) from Tbl_Course_Batch_Duration where IntakeMasterID=@intake and Duration_Id=@courseid)
	if  exists(select * from Tbl_Course_Duration_PeriodDetails where Batch_Id=@intakeid and Semester_Id=@semester)
	begin
	if not exists (select * from Tbl_Course_Duration_Mapping where Course_Department_Id=@courseid and Duration_Period_Id=(select duration_period_id 
			from Tbl_Course_Duration_PeriodDetails 
			where Batch_Id=@intakeid and Semester_Id=@semester))
			begin
		--insert into Tbl_Course_Duration_PeriodDetails(Batch_Id,Org_Id,Semester_Id,Delete_Status,Duration_Period_From,Duration_Period_To) values(@intakeid,1,@semester,0,@startdate,@enddate);
		insert into Tbl_Course_Duration_Mapping(Course_Department_Id,Delete_Status,Course_Department_Status,Duration_Period_Id,Org_Id) 
			values(@courseid,0,0,(select duration_period_id 
			from Tbl_Course_Duration_PeriodDetails 
			where Batch_Id=@intakeid and Semester_Id=@semester),1 );
			end

				insert into Tbl_Semester_Subjects(Duration_Mapping_Id,Department_Subjects_Id,Semester_Subjects_Status)
				values((select min(Duration_Mapping_Id) from Tbl_Course_Duration_Mapping 
				where Duration_Period_Id= 
				(select  min(duration_period_id) from Tbl_Course_Duration_PeriodDetails where Batch_Id=@intakeid and Semester_Id=@semester) 
				and Course_Department_Id=@courseid),@subjectid,0);

	end
	else
	begin
		insert into Tbl_Course_Duration_PeriodDetails(Batch_Id,Org_Id,Semester_Id,Delete_Status,Duration_Period_From,Duration_Period_To) values(@intakeid,1,@semester,0,@startdate,@enddate);
		if not  exists (select * from Tbl_Course_Duration_Mapping where Course_Department_Id=@courseid and Duration_Period_Id=(select duration_period_id 
			from Tbl_Course_Duration_PeriodDetails 
			where Batch_Id=@intakeid and Semester_Id=@semester))
			begin
		insert into Tbl_Course_Duration_Mapping(Course_Department_Id,Delete_Status,Course_Department_Status,Duration_Period_Id,Org_Id) values(@courseid,0,0,(select max(duration_period_id) from Tbl_Course_Duration_PeriodDetails ),1 );
		end
		insert into Tbl_Semester_Subjects(Duration_Mapping_Id,Department_Subjects_Id,Semester_Subjects_Status)values((select min(Duration_Mapping_Id) from Tbl_Course_Duration_Mapping where Duration_Period_Id= (select  min(duration_period_id) from Tbl_Course_Duration_PeriodDetails where Batch_Id=@intakeid and Semester_Id=@semester) and Course_Department_Id=@courseid),@subjectid,0);
	end
end

');
END
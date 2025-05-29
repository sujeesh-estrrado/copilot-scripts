IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migration_intake_semester_mapping_test_sampleadjust]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migration_intake_semester_mapping_test_sampleadjust] (@intakeid bigint ,@semester bigint,@startdate datetime,@enddate datetime,@courseid bigint,@subjectid  bigint)
as

begin
	
	if  exists(select * from Tbl_Course_Duration_PeriodDetails where Batch_Id=@intakeid and Semester_Id=@semester)
	begin
	if not exists (select * from Tbl_Course_Duration_Mapping where Course_Department_Id=@courseid and Duration_Period_Id=(select duration_period_id 
			from Tbl_Course_Duration_PeriodDetails 
			where Batch_Id=@intakeid and Semester_Id=@semester))
			begin
		--insert into Tbl_Course_Duration_PeriodDetails(Batch_Id,Org_Id,Semester_Id,Delete_Status,Duration_Period_From,Duration_Period_To) values(@intakeid,1,@semester,0,@startdate,@enddate);
		insert into Tbl_Course_Duration_Mapping(Course_Department_Id,Delete_Status,Course_Department_Status,Duration_Period_Id,Org_Id) 
			values(@courseid,0,0,(select min(duration_period_id )
			from Tbl_Course_Duration_PeriodDetails 
			where Batch_Id=@intakeid and Semester_Id=@semester),1 );
			end

			

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
	
	end
end



');
END
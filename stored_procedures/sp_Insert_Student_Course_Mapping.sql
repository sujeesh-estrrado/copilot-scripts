IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_Student_Course_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Insert_Student_Course_Mapping] --2,30073,6
(@flag bigint=0,
@Candidate_Id bigint=0,
@Semester_Duration_Mapping_Id bigint=0
)
as BEGIN
if(@flag=1)
	begin
	--if not exists(select * from Tbl_Student_CourseSubject_Mapping where Student_Id=@Candidate_Id and Semester_Duration_Mapping_Id=@Semester_Duration_Mapping_Id)
	--	begin
		insert into Tbl_Student_CourseSubject_Mapping(Student_Id,Semester_Duration_Mapping_Id,Selected_Status,Sitting_No,Created_Date,Delete_status)
		values(@Candidate_Id,@Semester_Duration_Mapping_Id,0,1,getdate(),0)
		--end
	end
if(@flag=2)
begin
select C.Course_code,C.Course_Name,C.Course_Id,C.Course_code+''-''+Semester_Code as Section,Sitting_No,
Case when Selected_Status=0 then ''Taking'' else ''Droped'' end as CurrentStatus,'' ''as Grade

 From Tbl_Student_CourseSubject_Mapping  M
inner join Tbl_Course_Duration_PeriodDetails  P on M.Semester_Duration_Mapping_Id=P.Duration_Period_Id
inner join Tbl_Semester_Subjects S on S.Duration_Mapping_Id=M.Semester_Duration_Mapping_Id
inner join Tbl_New_Course C on S.Department_Subjects_Id=C.Course_Id 
left join Tbl_Course_Semester CS on P.Semester_Id=CS.Semester_Id
where C.Delete_Status=0 and Student_Id=@Candidate_Id and Semester_Duration_Mapping_Id=@Semester_Duration_Mapping_Id
end
End
    ');
END;

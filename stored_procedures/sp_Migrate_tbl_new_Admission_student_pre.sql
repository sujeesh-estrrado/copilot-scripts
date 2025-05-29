IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migrate_tbl_new_Admission_student_pre]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migrate_tbl_new_Admission_student_pre](@icno varchar(max),@courseid  bigint,@intakeid bigint,@facultyid bigint,@programid  bigint,@studentid bigint)
as
begin
declare @candidate_id bigint=0,
@intakeidnew bigint=0
if exists (select * from tbl_student_candidate_id_pre where student_id=@studentid)
begin
set @candidate_id=(select candidate_id from tbl_student_candidate_id_pre where student_id=@studentid)
set @intakeidnew=(select Batch_Id from Tbl_Course_Batch_Duration where IntakeMasterID=@intakeid and Duration_Id=@courseid and Batch_DelStatus=0)
if(@intakeidnew>0)
begin
if not exists (select * from tbl_New_Admission where Department_Id=@courseid and  Batch_Id=@intakeidnew and Course_Level_Id=@facultyid and Course_Category_Id=@programid)
begin


insert into tbl_New_Admission(Department_Id,Batch_Id,Course_Level_Id,Course_Category_Id) values(
@courseid,@intakeidnew,@facultyid,@programid);
update Tbl_Candidate_Personal_Det set New_Admission_Id=(select min(New_Admission_Id) from tbl_New_Admission where Department_Id=@courseid and  Batch_Id=@intakeidnew and Course_Level_Id=@facultyid and Course_Category_Id=@programid )where Candidate_Id>62184 and candidate_id=@candidate_id


end
else
begin
update Tbl_Candidate_Personal_Det set New_Admission_Id=(select min(New_Admission_Id) from tbl_New_Admission where Department_Id=@courseid and  Batch_Id=@intakeidnew and Course_Level_Id=@facultyid and Course_Category_Id=@programid )where Candidate_Id>62184 and candidate_id=@candidate_id


end
end
end
end');
END
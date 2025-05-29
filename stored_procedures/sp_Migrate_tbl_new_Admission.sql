IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migrate_tbl_new_Admission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migrate_tbl_new_Admission](@studentid bigint,@courseid  bigint,@intakeid bigint,@facultyid bigint,@programid  bigint)
as
begin

if not exists (select * from tbl_New_Admission where Department_Id=@courseid and  Batch_Id=@intakeid and Course_Level_Id=@facultyid and Course_Category_Id=@programid)
begin
insert into tbl_New_Admission(Department_Id,Batch_Id,Course_Level_Id,Course_Category_Id) values(
@courseid,@intakeid,@facultyid,@programid);
update Tbl_Candidate_Personal_Det set New_Admission_Id=(select min(New_Admission_Id) from tbl_New_Admission where Department_Id=@courseid and  Batch_Id=@intakeid and Course_Level_Id=@facultyid and Course_Category_Id=@programid )where Candidate_Id=@studentid

end
else
begin
update Tbl_Candidate_Personal_Det set New_Admission_Id=(select min(New_Admission_Id) from tbl_New_Admission where Department_Id=@courseid and  Batch_Id=@intakeid and Course_Level_Id=@facultyid and Course_Category_Id=@programid )where Candidate_Id=@studentid

end
end
');
END
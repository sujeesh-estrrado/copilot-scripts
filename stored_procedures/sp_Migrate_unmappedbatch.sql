IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migrate_unmappedbatch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migrate_unmappedbatch](@studentid bigint,@courseid bigint,@intakeid bigint)
as
begin
declare @id bigint,@newadid bigint

if not exists (select * from Tbl_Course_Batch_Duration where IntakeMasterID=@intakeid and Duration_Id=@courseid)
begin

insert into Tbl_Course_Batch_Duration (IntakeMasterID,Duration_Id,Batch_DelStatus,Study_Mode,Batch_Code) values(@intakeid,@courseid,0,''FULL TIME'',(select I.intake_no+''-''+(select Course_Code from Tbl_Department where Department_Id=@courseid) from   Tbl_IntakeMaster I where I.id=@intakeid ))

set @id =(select SCOPE_IDENTITY());
insert into tbl_New_Admission(Course_Level_Id,Course_Category_Id,Department_Id,Batch_Id) values((select GraduationTypeId from Tbl_Department where Department_Id=@courseid),(select Program_Type_Id from Tbl_Department where Department_Id=@courseid),@courseid,@id)
set @newadid=(select SCOPE_IDENTITY());
update Tbl_Candidate_Personal_Det set New_Admission_Id=@newadid where Candidate_Id=@studentid
end

end
');
END
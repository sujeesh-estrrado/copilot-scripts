IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_CourseOptions]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_CourseOptions]
(@candidate_id BIGINT,@option2 BIGINT,@Flag bigint)

AS BEGIN
if(@Flag=1)
begin
UPDATE dbo.Tbl_Candidate_Personal_Det SET Option2=@option2 WHERE Candidate_Id=@candidate_id

SELECT @candidate_id
End
if(@Flag=2)
begin
UPDATE dbo.Tbl_Candidate_Personal_Det SET New_Admission_Id=@option2 WHERE Candidate_Id=@candidate_id

SELECT @candidate_id
End
if(@Flag=3)
begin
UPDATE dbo.Tbl_Candidate_Personal_Det SET Option3=@option2 WHERE Candidate_Id=@candidate_id

SELECT @candidate_id
End
if(@Flag=4)
begin
insert into tbl_student_intake_change(candidate_id,old_new_admission_id,New_new_admission_id,create_date) values(@candidate_id,(select New_Admission_Id from tbl_candidate_personal_det where candidate_id=@candidate_id),@option2,getdate());
UPDATE dbo.Tbl_Candidate_Personal_Det SET New_Admission_Id=@option2 WHERE Candidate_Id=@candidate_id
--update dbo.Tbl_Candidate_Document set Delete_Status=1 where Candidate_Id=@candidate_id

SELECT @candidate_id
End
END
    ')
END

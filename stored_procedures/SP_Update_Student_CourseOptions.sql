IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Student_CourseOptions]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Student_CourseOptions]
(@candidate_id BIGINT,@option2 BIGINT,@Flag bigint)

AS BEGIN
if(@Flag=1)
begin
UPDATE dbo.Tbl_Student_NewApplication SET Option2=@option2 WHERE Candidate_Id=@candidate_id

SELECT @candidate_id
End
if(@Flag=2)
begin
UPDATE dbo.Tbl_Student_NewApplication SET New_Admission_Id=@option2 WHERE Candidate_Id=@candidate_id

SELECT @candidate_id
End
if(@Flag=3)
begin
UPDATE dbo.Tbl_Student_NewApplication SET Option3=@option2 WHERE Candidate_Id=@candidate_id

SELECT @candidate_id
End
END
    ')
END

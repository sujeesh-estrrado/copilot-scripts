IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_semester_by_candidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        create procedure [dbo].[SP_Update_Candidate_semester_by_candidate_id](@candidate_id bigint,@semesterno varchar(50))
as
begin 
update tbl_student_semester set Old_SemesterName=SEMESTER_NO, SEMESTER_NO=@semesterno where Candidate_Id=@candidate_id

end
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Current_Duration_Mapping_Id_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Current_Duration_Mapping_Id_Student] 
(
@Candidate_Id bigint
)
as
begin

select * from dbo.Tbl_Student_Semester where Student_Semester_Id  in 
(select max(Student_Semester_Id) from dbo.Tbl_Student_Semester where Candidate_Id=@Candidate_Id) 

end
    ');
END;

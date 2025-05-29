IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_ListResultByExamMasterId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_ListResultByExamMasterId](@Exam_Id bigint=0,@flag bigint=0,@StudentId bigint=0)
as
begin
if(@flag=1)
begin
if exists(select * from Tbl_MarkEntryMaster where Exam_Id=@Exam_Id and EntryType=''R3'')
begin
select S.AdharNumber,S.IDMatrixNo,CONCAT(S.Candidate_Fname,'' '',S.Candidate_Lname) as StudentName 
,M.Exam_Id,S.Candidate_Id
from Tbl_Exam_Master E
inner join  Tbl_MarkEntryMaster M on M.Exam_Id =E.Exam_Master_id
inner join Tbl_Candidate_Personal_Det S  on S.Candidate_Id=M.Student_Id
where EntryType=''R3'' and M.Exam_Id=@Exam_Id
end
end
if exists(select * from Tbl_MarkEntryMaster where Exam_Id=@Exam_Id and EntryType=''R2'')
begin
select S.AdharNumber,S.IDMatrixNo,CONCAT(S.Candidate_Fname,'' '',S.Candidate_Lname) as StudentName 
,M.Exam_Id,S.Candidate_Id
from Tbl_Exam_Master E
inner join  Tbl_MarkEntryMaster M on M.Exam_Id =E.Exam_Master_id
inner join Tbl_Candidate_Personal_Det S  on S.Candidate_Id=M.Student_Id
where EntryType=''R2'' and M.Exam_Id=@Exam_Id
end
if(@flag=2)
begin
if exists(select * from Tbl_MarkEntryMaster where Exam_Id=@Exam_Id and EntryType=''R3''and Student_Id=@StudentId)
begin
select sum(GradePoint) from Tbl_MarkEntryMaster M inner join 
Tbl_Exam_Master E on E.Exam_Master_id=M.Exam_Id
inner join Tbl_New_Course C on M.Course_Id=C.Course_Id
inner join Tbl_GradingScheme G on G.Grade_Scheme_Id=C.Grade_Id 
inner join Tbl_GradeSchemeSetup Gs  on Gs.Grade_Scheme_Id=G.Grade_Scheme_Id and Gs.Grade=M.Result_status
where M.Exam_Id=@Exam_Id and M.Student_Id=@StudentId and EntryType=''R3'' Group by M.Student_Id
end
if exists(select * from Tbl_MarkEntryMaster where Exam_Id=@Exam_Id and EntryType=''R2'' and Student_Id=@StudentId)
begin
select sum(GradePoint) from Tbl_MarkEntryMaster M inner join 
Tbl_Exam_Master E on E.Exam_Master_id=M.Exam_Id
inner join Tbl_New_Course C on M.Course_Id=C.Course_Id
inner join Tbl_GradingScheme G on G.Grade_Scheme_Id=C.Grade_Id 
inner join Tbl_GradeSchemeSetup Gs  on Gs.Grade_Scheme_Id=G.Grade_Scheme_Id and Gs.Grade=M.Result_status
where M.Exam_Id=@Exam_Id and M.Student_Id=@StudentId and EntryType=''R3'' Group by M.Student_Id
end
end

if(@flag=3)
begin

select  sum(cast(cast(Course_credit AS float) as DECIMAL(28, 16))) from Tbl_New_Course Gs 
where Course_Id in (select Course_Id from Tbl_Exam_Schedule E where Exam_Master_Id=@Exam_Id )
end

end
    ');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Student_Parallel_Semester]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Student_Parallel_Semester] 
(
@Flag bigint=0,
@Candidate_Id  bigint = 0,
@Duration_Mapping_Id bigint=0,
@Student_Semester_Current_Status bit=1,
@SEMESTER_NO varchar(Max)='''',
@SemesterId bigint=0,
@Old_SemesterName  varchar(Max)='''',
@parallelprogrammeid bigint=0

)
as

begin
if(@Flag=0)
    begin
     select * from Tbl_Student_Parallel_Semester where Candidate_Id=@Candidate_Id
    end
if(@Flag=1)
    begin
     Insert into Tbl_Student_Parallel_Semester(Candidate_Id,Duration_Mapping_Id,Student_Semester_Current_Status,
     Parallel_Semester_Delete_Status,SEMESTER_NO,SemesterId,Created_Date,Delete_Status)
     values(@Candidate_Id,@Duration_Mapping_Id,@Student_Semester_Current_Status,0,@SEMESTER_NO,@SemesterId,getdate(),0)
    end

if(@Flag=2)
    begin
     Update Tbl_Student_Parallel_Semester set SEMESTER_NO=@SEMESTER_NO,SemesterId=@SemesterId,
     Old_SemesterName=@Old_SemesterName,Updated_Date=getdate() where Candidate_Id=@Candidate_Id and Delete_Status=0
     and Student_Semester_Current_Status=0 and Parallel_Semester_Delete_Status=0
    end
if(@Flag=3)
    begin
        update Tbl_Candidate_Personal_Det set parallelprogrammeid=@parallelprogrammeid 
        where Candidate_Id=@Candidate_Id and Candidate_Delstatus=0
    end
end
    ')
END;

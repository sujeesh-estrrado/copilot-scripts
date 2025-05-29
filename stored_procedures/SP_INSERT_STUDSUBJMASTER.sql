IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_STUDSUBJMASTER]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_INSERT_STUDSUBJMASTER] 
(@CourseDept bigint,  
@DurationMapping bigint,  
@CandidateId bigint)  
AS BEGIN  
declare @count bigint  
declare @master bigint  
  
set @count=(select count(Student_Subject_Map_Master) from dbo.Tbl_Student_Subject_Master   
where Department_Id=@CourseDept and Duration_Mapping_Id=@DurationMapping and Candidate_Id=@CandidateId)  
 print @count
if(@count>0)  
begin  
set @master=(select Student_Subject_Map_Master from dbo.Tbl_Student_Subject_Master where Department_Id=@CourseDept and Duration_Mapping_Id=@DurationMapping and Candidate_Id=@CandidateId)  
delete from dbo.Tbl_Student_Subject_Child where Student_Subject_Map_Master=@master  
delete from dbo.Tbl_Student_Subject_Master where Department_Id=@CourseDept and Duration_Mapping_Id=@DurationMapping and Candidate_Id=@CandidateId  
insert into dbo.Tbl_Student_Subject_Master(Department_Id,Duration_Mapping_Id,  
Candidate_Id) values(@CourseDept,@DurationMapping,@CandidateId)  
  
select scope_identity()  
end  
else  
begin   
insert into dbo.Tbl_Student_Subject_Master(Department_Id,Duration_Mapping_Id,  
Candidate_Id) values(@CourseDept,@DurationMapping,@CandidateId)  
  
select scope_identity()  
end  
end
    ');
END;

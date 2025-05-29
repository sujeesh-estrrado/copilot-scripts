IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_STUDEXAMSUBJMASTER]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_INSERT_STUDEXAMSUBJMASTER]                
(@CourseDept bigint,                
@DurationMapping bigint,                
@CandidateId bigint)                
AS             
BEGIN                
declare @count bigint                
declare @master bigint                
                
set @count=(select count(StudentExamSubjectMasterId) from dbo.Tbl_StudentExamSubjectMaster                 
where Department_Id=@CourseDept and Duration_Mapping_Id=@DurationMapping and Candidate_Id=@CandidateId)                
                
if(@count>0)             
--if exists(select count(StudentExamSubjectMasterId) from dbo.Tbl_StudentExamSubjectMaster                 
--where Department_Id=1 and Duration_Mapping_Id=15 and Candidate_Id=15)        
           
begin                
set @master=(select StudentExamSubjectMasterId from dbo.Tbl_StudentExamSubjectMaster where Department_Id=@CourseDept and Duration_Mapping_Id=@DurationMapping and Candidate_Id=@CandidateId)                 
select @master            
end            
else            
begin            
insert into dbo.Tbl_StudentExamSubjectMaster(Department_Id,Duration_Mapping_Id,                
Candidate_Id) values(@CourseDept,@DurationMapping,@CandidateId)             
select scope_identity()               
end            
    end 
    ')
END;

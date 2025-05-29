IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_Candidate_WorkExperience_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_Insert_Candidate_WorkExperience_Details]
(
    @Candidate_Id bigint=0,
    @Employer varchar(MAX)='''',
    @Position varchar(MAX)='''',
    @StartDate Datetime='''',
    @EndDate Datetime='''',
    @ExperienceCertificate varchar(MAX)='''',
    @DelStatus bigint=0
)  
as  
begin   
if not exists(select * from  Tbl_Candidate_WorkExperience where Candidate_Id=@Candidate_Id and Employer=@Employer  and Delete_Status=0)
begin
        insert into Tbl_Candidate_WorkExperience(Candidate_Id,Employer,Position,StartDate,EndDate,ExperienceCertificate,created_Date,Delete_Status)
        values(@Candidate_Id,@Employer,@Position,@StartDate,@EndDate,@ExperienceCertificate,getdate(),0) 
        end
end');
END;

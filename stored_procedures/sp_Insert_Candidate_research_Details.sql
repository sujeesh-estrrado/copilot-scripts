IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_Candidate_research_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Insert_Candidate_research_Details]
(
@Candidate_Id bigint,
@Employer varchar(MAX),
@Position varchar(MAX),
@StartDate Datetime,
@EndDate Datetime

)  
as  
begin   
if not exists(select * from Tbl_Candidate_research  where  Delete_Status=0 and Candidate_Id=@Candidate_Id and Employer=@Employer and StartDate=@StartDate and EndDate=@EndDate)
begin

insert into Tbl_Candidate_research(Candidate_Id,Employer,Position,StartDate,EndDate,created_Date,Delete_Status)
 values(@Candidate_Id,@Employer,@Position,@StartDate,@EndDate,getdate(),0) 
end
else
begin
update Tbl_Candidate_research set StartDate=@StartDate,Position=@Position ,EndDate=@EndDate where Employer=@Employer and Candidate_Id=@Candidate_Id 
end
end');
END;

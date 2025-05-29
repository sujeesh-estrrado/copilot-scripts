IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_research_Details_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Candidate_research_Details_ByID]  --30108
(@Candidate_Id bigint)  
AS  
BEGIN  
select Candidate_Id,Employer,Position, convert(varchar,StartDate,103) as StartDate,convert(varchar,EndDate,103) as EndDate
 from Tbl_Candidate_research 
  WHERE Candidate_Id=@Candidate_Id  and delete_status=0
  
END
');
END;
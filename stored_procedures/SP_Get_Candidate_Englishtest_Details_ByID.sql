IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_Englishtest_Details_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_Candidate_Englishtest_Details_ByID]  --4
(@Candidate_Id bigint)  
AS  
BEGIN  
select T.English_Text_Id,T.Grade,T.Type,T.TestYear,T.Cand_Id,M.English_Test from Tbl_Candidate_Englishtest T
 left join Tbl_EnglishTestMaster M on t.English_Text_Id=M.English_Text_Id
  WHERE Cand_Id=@Candidate_Id  and T.delete_status=0
  
END	');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_SubjectgradeDetails_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Candidate_SubjectgradeDetails_ByID]  
(@Candidate_Id bigint)  
AS  
BEGIN  
SELECT *  
  FROM Tbl_Candidate_Education_Grade  
  
  WHERE Cand_Id=@Candidate_Id  and Delete_status=0

END

');
END;
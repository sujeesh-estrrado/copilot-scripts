IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_AnnualPracticingCertification_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Candidate_AnnualPracticingCertification_ByID]  --30108
(@Candidate_Id bigint)  
AS  
BEGIN  
SELECT AnnualCertId,Filename,CONVERT(VARCHAR(10), Documentdate, 103) as Documentdate FROM Tbl_AnnualPracticingCertificate Where Candidate_Id=@Candidate_Id  and Delete_Status=0
  
END
    ')
END;

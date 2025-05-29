IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetCandidate_Id_By_Basicdetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetCandidate_Id_By_Basicdetails]
(@AdharNum varchar(MAX)) 
AS  
BEGIN  
 select Candidate_Id from Tbl_Candidate_Personal_Det where AdharNumber=@AdharNum and Candidate_DelStatus = 0
END
    ')
END;

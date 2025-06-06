IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Candidate_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[Sp_Candidate_Status] 
    @Candidate_Id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

--  select 
--CD.AdharNumber as ICPassport,
--CASE WHEN V.Visa_Status IS NOT NULL THEN V.Visa_Status ELSE ''Pending'' END AS ApplicationStatus
                
--from Tbl_Candidate_Personal_Det CD
--Left Join Tbl_Visa_ISSO V on CD.Candidate_Id=V.Candidate_Id
--where CD.Candidate_Id=@Candidate_Id
SELECT 
    CD.AdharNumber AS ICPassport,
    COALESCE(V.Visa_Status, ''Pending'') AS ApplicationStatus
FROM Tbl_Candidate_Personal_Det CD
LEFT JOIN 
    (SELECT TOP 1 Candidate_Id, Visa_Status
     FROM Tbl_Visa_ISSO
     WHERE Candidate_Id = @Candidate_Id
     ORDER BY Visa_Id DESC) V  -- Assuming Visa_Id is the Primary Key
ON CD.Candidate_Id = V.Candidate_Id
WHERE CD.Candidate_Id = @Candidate_Id;

END
    ')
END

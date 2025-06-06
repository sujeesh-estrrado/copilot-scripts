IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Candidate_Visa_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[Sp_Candidate_Visa_Details] 
    @Candidate_Id BIGINT
AS
BEGIN
    SET NOCOUNT ON;
     
--  SELECT 
--   CONVERT(VARCHAR(10), Applied_Date, 101) AS Applied_Date,

--    Visa_Type,
--    CONVERT(VARCHAR(10), Visa_Expiry, 101) AS Visa_Expiry,
--    CONVERT(VARCHAR(10), Passport_visa_ExpiryDate, 101) AS Passport_visa_ExpiryDate,
--    Visa_Status,
--    Duration
--FROM 
--    Tbl_Visa_ISSO  
--WHERE 
--    Candidate_Id = @Candidate_Id
--  order by Visa_Id ,Applied_Date desc

--SELECT TOP 1 
--    Visa_Id,
--    FORMAT(Applied_Date, ''dd/MM/yyyy'') AS Applied_Date,
--    Visa_Type,
--    FORMAT(Visa_Expiry, ''dd/MM/yyyy'') AS Visa_Expiry,
--    CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103) AS Passport_visa_ExpiryDate,
--    Visa_Status,
--    Duration
--FROM Tbl_Candidate_Personal_Det CPD LEFT JOIN Tbl_Visa_ISSO  VI on CPD.Candidate_Id=VI.Candidate_Id
--WHERE VI.Candidate_Id = 397
--ORDER BY Visa_Id DESC;

SELECT 
    COALESCE(CAST(VI.Visa_Id AS NVARCHAR), ''N/A'') AS Visa_Id, 
    COALESCE(FORMAT(VI.Applied_Date, ''dd/MM/yyyy''), ''N/A'') AS Applied_Date,
    COALESCE(VI.Visa_Type, ''N/A'') AS Visa_Type,
    COALESCE(FORMAT(VI.Visa_Expiry, ''dd/MM/yyyy''), ''N/A'') AS Visa_Expiry,
CASE 
    WHEN CPD.PassportDate IS NULL OR LTRIM(RTRIM(CPD.PassportDate)) = '''' 
    THEN ''N/A'' 
    ELSE CONVERT(VARCHAR, TRY_CAST(CPD.PassportDate AS DATE), 103) 
END AS Passport_visa_ExpiryDate,
COALESCE(VI.Visa_Status, ''Pending'') AS Visa_Status,
    COALESCE(CAST(VI.Duration AS NVARCHAR), ''N/A'') AS Duration  
FROM Tbl_Candidate_Personal_Det CPD  
OUTER APPLY (
    SELECT TOP 1 
        Visa_Id,
        Applied_Date,
        Visa_Type,
        Visa_Expiry,
        Visa_Status,
        Duration
    FROM Tbl_Visa_ISSO  
    WHERE Tbl_Visa_ISSO.Candidate_Id = CPD.Candidate_Id
    ORDER BY Visa_Id DESC
) VI
WHERE CPD.Candidate_Id = @Candidate_Id;



END
    ')
END

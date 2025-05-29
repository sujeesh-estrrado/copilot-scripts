IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetAllCandidate_Contactdetails]') 
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
    CREATE PROCEDURE [dbo].[sp_GetAllCandidate_Contactdetails] 
    (@candidate_id BIGINT)
    AS
    BEGIN
        SELECT 
            Cand_Contact_Mapping_Id,
            Cand_ContactDet_Id,
            Parent_Icpassport_No,
            C.Country,
            Contact_person_Name,
            Contact_Relationship,
            Contact_Mob,
            Contact_Mail,
            (Contact_Address1 + '' '' + Contact_Address2 + '' '' + Contact_PostCode) AS Contactaddress,
            Contact_Residing_Country,
            Contact_state,
            Contact_City
        FROM Tbl_Candidate_ContactDetails_Mapping M
        INNER JOIN [Tbl_Country] C ON C.Country_Id = M.Contact_Residing_Country 
        WHERE Candidate_Id = @candidate_id 
        AND Delete_Status = 0;
    END';
END
GO

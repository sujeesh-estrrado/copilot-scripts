IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_all_Guadian_details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_all_Guadian_details] --30108
(@candidateid bigint)
AS
BEGIN
SELECT        Cand_Contact_Mapping_Id, Cand_ContactDet_Id, Parent_Icpassport_No, Contact_person_Name AS Name, Contact_Relationship AS Relation, Contact_Mob AS Mobile, Contact_Telephone AS Phone, Contact_Mail AS Email, 
                         Contact_Address1 AS Address1, Contact_Address2 AS address2, Contact_PostCode AS PostCode, Contact_Residing_Country AS Country, Contact_state AS State, Contact_City AS City, Candidate_Id, Created_Date, Updated_Date, 
                         Delete_Status
FROM            dbo.Tbl_Candidate_ContactDetails_Mapping
WHERE        (Candidate_Id = @candidateid) and Delete_Status=0
END
    ')
END;

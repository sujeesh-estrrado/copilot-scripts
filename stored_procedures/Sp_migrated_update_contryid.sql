IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_migrated_update_contryid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_migrated_update_contryid](@countryid1 BIGINT,@mailingcountryid BIGINT,@studentid BIGINT)
AS
BEGIN
update Tbl_Candidate_Personal_Det set Residing_Country=(select Country_Id from Tbl_Country  where Country like (select cntry from tbl_Country_barracuda where id= @countryid1)) where candidate_id=@studentid
UPDATE Tbl_Candidate_contactdetails SET Candidate_PermAddress_Country=(select Country_Id from Tbl_Country  where Country like (select cntry from tbl_Country_barracuda where id= @countryid1)),Candidate_ContAddress_Country=
(select Country_Id from Tbl_Country  where Country like (select cntry from tbl_Country_barracuda where id= @mailingcountryid)) where candidate_id=@studentid;
end
');
END
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Guadian_details_bymappingid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Delete_Guadian_details_bymappingid] --1
(@Cand_Contact_Mapping_Id bigint)
AS
BEGIN
update        dbo.Tbl_Candidate_ContactDetails_Mapping set  Delete_Status=1

WHERE     Cand_Contact_Mapping_Id=@Cand_Contact_Mapping_Id
end

    ')
END;

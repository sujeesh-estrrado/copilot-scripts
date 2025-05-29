IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_ContactDet_Mapping_ById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Candidate_ContactDet_Mapping_ById]
(
@Cand_Contact_Mapping_Id bigint,
@Parent_Icpassport_No  varchar(MAX),
@FatherName varchar(MAX),
@Relationship varchar(MAX),
@GuardianMobile varchar(MAX),
@GuardianTelephone varchar(MAX),
@GuardianEmail  varchar(MAX),
@GuardianAddress varchar(MAX),
@CandidateContAddress_Line2 varchar(MAX),
@CandidateContAddress_postCode varchar(MAX),
@CandidateContAddress_Country bigint,
@CandidateContAddress_State varchar(MAX),
@CandidateContAddress_City varchar(MAX),
@ID bigint                  
)                      
                 
                     
AS                    
BEGIN                 
 if exists(select * from Tbl_Candidate_ContactDetails_Mapping where Candidate_Id=@ID and Contact_Relationship=@Relationship)
 begin
 Update Tbl_Candidate_ContactDetails_Mapping set 
    [Parent_Icpassport_No]=@Parent_Icpassport_No,
    [Contact_person_Name]=@FatherName,
    [Contact_Relationship]=@Relationship ,
    [Contact_Mob]=@GuardianMobile,
    [Contact_Telephone]=@GuardianTelephone,
    [Contact_Mail]=@GuardianEmail,
    [Contact_Address1]=@GuardianAddress,
    [Contact_Address2]=@CandidateContAddress_Line2,
    [Contact_PostCode]=@CandidateContAddress_postCode,
    [Contact_Residing_Country]=@CandidateContAddress_Country,
    [Contact_state]=@CandidateContAddress_State,
    [Contact_City]=@CandidateContAddress_City,
    Updated_Date=getdate()
    where Cand_Contact_Mapping_Id=@Cand_Contact_Mapping_Id
 end
                    
END 
    ')
END;

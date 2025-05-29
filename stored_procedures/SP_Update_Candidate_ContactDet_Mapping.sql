IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_ContactDet_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Candidate_ContactDet_Mapping]
(
@Cand_ContactDet_Id bigint,
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
 if not exists(select * from Tbl_Candidate_ContactDetails_Mapping where Candidate_Id=@ID and Contact_Relationship=@Relationship)
 begin
 insert into Tbl_Candidate_ContactDetails_Mapping([Cand_ContactDet_Id],
    [Parent_Icpassport_No],
    [Contact_person_Name],
    [Contact_Relationship] ,
    [Contact_Mob],
    [Contact_Telephone],
    [Contact_Mail],
    [Contact_Address1],
    [Contact_Address2],
    [Contact_PostCode],
    [Contact_Residing_Country],
    [Contact_state],
    [Contact_City],
    [Candidate_Id],Created_Date,Delete_Status) values(@Cand_ContactDet_Id ,@Parent_Icpassport_No,@FatherName,@Relationship,
@GuardianMobile,@GuardianTelephone,@GuardianEmail,@GuardianAddress,@CandidateContAddress_Line2,
@CandidateContAddress_postCode,@CandidateContAddress_Country,@CandidateContAddress_State,@CandidateContAddress_City,@ID,getdate(),0 )
    end
    else
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
    where [Cand_ContactDet_Id]=@Cand_ContactDet_Id and Candidate_Id=@ID and Contact_Relationship=@Relationship
    end                 
END 
    ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_migrated_Student_pre]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_migrated_Student_pre]
(@status varchar(max),@studentname varchar(max),@surname varchar(max),@ictype varchar(max),@icno varchar(max),@billoutstanding varchar(max),@gender varchar(max),@dob varchar(max),@placeofbirth varchar(max),@bankid1 varchar(max),@bankaccountno1 varchar(max),@bankid2 varchar(max),@bankaccountno2 varchar(max),@sponsor bigint,@maritalstatus varchar(max),@religion varchar(max),@nationality bigint,@marketingsource varchar(max),@datecreated datetime,@dateactive datetime,@recruitedby_agent bigint,@recruitedby bigint,@matrixno varchar(max),@campusid BIGINT,@createdby BIGINT,@address1line1 varchar(max),@address1line2 varchar(max),@postcode1 varchar(max),@countryid1 bigint,@phonemobile varchar(max),@phonehouse varchar(max),@email varchar(max),@mailingaddressline1 varchar(max),@mailingaddressline2 varchar(max),
@mailingpostcode varchar(max),@mailingcountryid bigint,@parentname varchar(max),@parentrelationship varchar(max)
,@studentid bigint,@barracuda_state varchar(max),@barracuda_city varchar(max)
)
AS
BEGIN
BEGIN TRAN
declare @id bigint
if not exists(select * from Tbl_Candidate_Personal_Det where AdharNumber=@icno )
BEGIN
INSERT INTO dbo.Tbl_Candidate_Personal_Det( active ,
                      Candidate_Fname ,
                        surname  ,
                        TypeOfStudent ,
                      AdharNumber,
                       Candidate_Gender ,
                        Candidate_Dob ,
                        Candidate_PlaceOfBirth ,
                        bankid1 ,
                      bankaccountno1 ,
                        bankid2 ,
                       bankaccountno2 ,
                         Sponsorship ,
                       Candidate_Marital_Status,
                      
                       Religion ,
                       Candidate_Nationality ,
                       SourceofInformation ,
                        
                      create_date ,
                       RegDate ,
                       Agent_ID  ,
                      CounselorEmployee_id  ,
                        IdentificationNo ,
                       IDMatrixNo ,
                        Campus ,
                       enrollby ,barracuda_state,barracuda_city )
VALUES
((  select ss.id from Tbl_Student_status ss inner join ref_marketing_status ms on  ms.name=ss.name where ms.id=@status),@studentname,@surname,@ictype,@icno,@gender,@dob,@placeofbirth,@bankid1,@bankaccountno1,@bankid2,@bankaccountno2,@sponsor,@maritalstatus,@religion,@nationality,@marketingsource,@datecreated,@datecreated,@recruitedby_agent,@recruitedby
,@matrixno,@matrixno,@campusid,@createdby, @barracuda_state,@barracuda_city)
set @id=(select Scope_identity())
insert Tbl_Candidate_ContactDetails (  Candidate_Id ,
                      Candidate_PermAddress ,
 Candidate_PermAddress_Line2  ,
                       Candidate_PermAddress_postCode  ,
                       Candidate_PermAddress_Country,
                        Candidate_Mob1 ,
                       Candidate_Telephone,
                       Candidate_Email ,
                        Candidate_ContAddress ,
                        Candidate_ContAddress_Line2 ,
                        Candidate_ContAddress_postCode ,
                        Candidate_ContAddress_Country ,
                        Candidate_FatherName ,
                        Candidate_Relationship )values(@id,@address1line1,@address1line2,@postcode1,@countryid1,@phonemobile,@phonehouse,@email,@mailingaddressline1,@mailingaddressline2,@mailingpostcode,@mailingcountryid,@parentname,@parentrelationship)
insert into tbl_student_candidate_id_pre(student_id,candidate_id) values(@studentid,@id)
End
else
Begin
update Tbl_Candidate_Personal_Det set SourceofInformation=@marketingsource where AdharNumber=@icno;
end
COMMIT TRAN
END
');
END
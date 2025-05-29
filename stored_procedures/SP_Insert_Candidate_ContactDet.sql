IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Candidate_ContactDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Insert_Candidate_ContactDet](@Candidate_Id bigint,@Candidate_PermAddress varchar(max),            
@Candidate_ContAddress varchar(max),@Candidate_Telephone varchar(50),@Candidate_Mob1 varchar(50),@Candidate_Mob2 varchar(50),@Candidate_Email varchar(50),@Candidate_FatherName varchar(100),            
@Candidate_FatherOcc varchar(200),@Candidate_MotherName varchar(100),@Candidate_MotherOcc varchar(200),@Candidate_GuardianName varchar(100),@Candidate_Relationship varchar(100),            
@Candidate_Guardian_Address varchar(max),@Candidate_Guardian_Telephone varchar(50),@Candidate_Guardian_Mob varchar(50),@Candidate_Guardian_Email varchar(100),          
@Candidate_FatherEmail varchar(50),@Candidate_idNo varchar (50),        
@PostCode varchar(50),        
@FatherAddress  varchar(max),        
@FatherIcNo varchar(50),        
@FatherMobileNo varchar(50),        
@MotherAddress varchar(max),        
@MotherIcNo varchar(50),        
@MotherMobileNo varchar(50),        
@MotherEmail varchar(max),      
 @Emergency_Name varchar(max),      
 @Emergency_mobile varchar(max),      
 @Emergency_relation varchar(50),    
 @ParentCTC  varchar(50),  
 @Candidate_MotherQualification varchar(max),  
  @Candidate_FatherQualification varchar(max),
  @Candidate_PermAddress_Line2	varchar(MAX),
@Candidate_PermAddress_postCode	varchar(MAX),
@Candidate_PermAddress_Country	bigint,
@Candidate_PermAddress_State	varchar(MAX),
@Candidate_PermAddress_City	varchar(MAX),
@Candidate_ContAddress_Line2	varchar(MAX),
@Candidate_ContAddress_postCode	varchar(MAX),
@Candidate_ContAddress_Country	bigint,
@Candidate_ContAddress_State	varchar(MAX),
@Candidate_ContAddress_City	varchar(MAX),
@emr_ICpassport varchar(MAX),
                    @emrname varchar(MAX),
                    @emrRelationship varchar(MAX),
                    @emr_residance  varchar(MAX),
                    @emrmob  varchar(MAX),
                    @emremail varchar(MAX),
                    @emraddr1 varchar(MAX),
                    @emraddr2 varchar(MAX),
                    @emrpostcode varchar(MAX),
                    @emrcountry bigint,
                    @emrstate  varchar(MAX),
                    @emrcity varchar(MAX),
                    @emrcheckstatus bit,
					--@AddressLine2_Parent varchar(max),
					--@Address_City_Parent varchar(max),
					--@Address_state_Parent varchar(max),
					--@Address_res_country_Parent bigint,
					--@Addresspostcode_Parent varchar(max),

@Candidate_parentAddress2	varchar(MAX),
@Candidate_Post	varchar(MAX),
@Candidate_Country	varchar(MAX),
@Candidate_Sate	varchar(MAX),
@Candidate_City	varchar(MAX)
)          
            
             
AS            
BEGIN            
BEGIN TRAN 
if not exists(select * from Tbl_Candidate_ContactDetails where Candidate_Id=@Candidate_Id)
Begin           
INSERT INTO dbo.Tbl_Candidate_ContactDetails(Candidate_Id,Candidate_PermAddress,Candidate_ContAddress,Candidate_Telephone,Candidate_Mob1,            
Candidate_Mob2,Candidate_Email,Candidate_FatherName,Candidate_FatherOcc,Candidate_MotherName,Candidate_MotherOcc,Candidate_GuardianName,Candidate_Relationship,Candidate_Guardian_Address,Candidate_Guardian_Telephone,Candidate_Guardian_Mob,          
Candidate_Guardian_Email,Candidate_FatherEmail,Candidate_idNo,PostCode,FatherAddress,FatherIcNo,FatherMobileNo,        
MotherAddress,MotherIcNo,MotherMobileNo,MotherEmail,Emergency_Name,Emergency_mobile,Emergency_relation,ParentCTC,  
Candidate_MotherQualification,Candidate_FatherQualification,Candidate_PermAddress_Line2,
Candidate_PermAddress_postCode,
Candidate_PermAddress_Country,
Candidate_PermAddress_State,
Candidate_PermAddress_City,
Candidate_ContAddress_Line2,
Candidate_ContAddress_postCode,
Candidate_ContAddress_Country,
Candidate_ContAddress_State,
Candidate_ContAddress_City,
Emergency_Parent_IcpassportNo,
Emergency_Name1,
Emergency_Relationship,
Emergency_Mob,
Emergency_Telephone,
Emergency_Mail,
Emergency_Address1,
Emergency_Address2,
Emergency_Postcode,
Emergency_Country,
Emergency_State,
Emergency_City,
Emergency_Check_Status,

Candidate_parentAddress2,
					Candidate_Post,
					Candidate_Country,
					Candidate_Sate,
					Candidate_City
)            
VALUES            
(@Candidate_Id,@Candidate_PermAddress,@Candidate_ContAddress,@Candidate_Telephone,@Candidate_Mob1,@Candidate_Mob2,@Candidate_Email,            
@Candidate_FatherName,@Candidate_FatherOcc,@Candidate_MotherName,@Candidate_MotherOcc,            
@Candidate_GuardianName,@Candidate_Relationship,@Candidate_Guardian_Address,@Candidate_Guardian_Telephone,@Candidate_Guardian_Mob,
@Candidate_Guardian_Email          
,@Candidate_FatherEmail,@Candidate_idNo,        
@PostCode,@FatherAddress,@FatherIcNo,@FatherMobileNo,        
@MotherAddress,@MotherIcNo,@MotherMobileNo,@MotherEmail,@Emergency_Name,      
 @Emergency_mobile,      
 @Emergency_relation,@ParentCTC,@Candidate_MotherQualification,@Candidate_FatherQualification ,          
   @Candidate_PermAddress_Line2,
@Candidate_PermAddress_postCode,
@Candidate_PermAddress_Country,
@Candidate_PermAddress_State,
@Candidate_PermAddress_City,
@Candidate_ContAddress_Line2,
@Candidate_ContAddress_postCode,
@Candidate_ContAddress_Country,
@Candidate_ContAddress_State,
@Candidate_ContAddress_City,
@emr_ICpassport,
                    @emrname,
                    @emrRelationship,
                    @emr_residance,
                    @emrmob,
                    @emremail,
                    @emraddr1,
                    @emraddr2,
                    @emrpostcode,
                    @emrcountry,
                    @emrstate,
                    @emrcity,
                    @emrcheckstatus , 
					
@Candidate_parentAddress2,
@Candidate_Post,
@Candidate_Country,
@Candidate_Sate,
@Candidate_City
					)
select Scope_identity()    
End        
COMMIT TRAN             
            
END 


    ')
END

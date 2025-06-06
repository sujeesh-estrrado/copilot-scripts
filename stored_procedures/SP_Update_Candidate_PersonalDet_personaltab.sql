IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_PersonalDet_personaltab]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Update_Candidate_PersonalDet_personaltab]                            
(@Candidate_Id bigint,        
@IdentificationNo varchar(50),        
@Candidate_Fname varchar(100),        
@Candidate_Mname varchar(50),        
@Candidate_Lname varchar(50),                            
@Candidate_Gender varchar(10),        
@Candidate_Dob datetime,                            
 @Candidate_PlaceOfBirth varchar(100)        
 ,@Candidate_Nationality varchar(100),                            
@Candidate_State varchar(100),        
@Religion varchar(100),        
@Caste varchar(100),        
@Diocese varchar(100),                            
@Parish varchar(100),        
@ApplicationCategory varchar(100),                            
@Candidate_Category varchar(100),        
@Candidate_FamilyIncome decimal,        
@Candidate_Img varchar(max),         
@AdharNum varchar(30),        
@RegDate datetime,                    
@oldicpassport varchar(50),        
@salutation varchar(50),        
@campus varchar(100),        
@typeofstudent varchar(50),                    
@status varchar(50),        
@counselorempid bigint,        
@agentname varchar(50),        
@salesorgname varchar(50),                  
@salesHRname varchar(50),        
@enrollby varchar(50),        
@counselorname varchar(50),        
@salesleadname varchar(50)                  
,@salesstudIC varchar(50),                  
@salesstudname varchar(50),        
@candidate_city varchar(50),        
@Race varchar(50),        
@IDMatrixNo varchar(50),            
@Visa varchar(200),        
@VisaFrom varchar(50),        
@VisaTo varchar(50),        
@Passport varchar(200),        
@PassportFrom varchar(200),          
@PassportDate varchar(200),        
@Insurance_detail varchar(max),        
@Residing_Country varchar(50),        
@br1m_doc varchar(200)        
,@disable_doc varchar(200),        
@Candidate_Marital_Status varchar(MAX),        
@room_required int,        
@Address_Chkbox_Status bit,        
@Disability_Chkbox_Status bit        
,@Disability_Type varchar(MAX),        
@BR1M_Status bit,        
@Display_Status varchar(MAX),        
@SourceofInformation varchar(MAX),        
@Event_Id varchar(Max) , --,@Agent_ID bigint    
@Candidate_Signature_Img varchar(max),
@Bumiputra_Status bit=0,@CitizenshipStatus varchar(max)='''',@CountryOfCitizenship varchar(100)='''',@AgentID bigint=0,@AgentEmail varchar(100)='''',
@Agentcode varchar(15)='''',@MMUStudName varchar(Max)='''',@MMUStudIC varchar(50)='''',@RegType varchar(15)=''''
,@MMUOldStudent varchar(15)='''',@OldStudentId varchar(15)='''',@Supervisor varchar(15)='''',@CoSupervisor varchar(15)='''',@ResearchTitle varchar(15)=''''
,@MedicalInfo varchar(50)='''', @MedicalComment varchar(max)='''',@CandidateAge int,@MethodofCommunication varchar(100),@CurrentGrade varchar(100),@PresentSchoolName varchar(100),
@PastSurgeries varchar(100),@PastMedicalHistory varchar(100),@FamilyDoctorName varchar(100),@FamilyDoctorAddress varchar(100),@Allergy varchar(100),@RefBy varchar(100),@MajDiff varchar(MAX),
@Height varchar(25),
        @weight varchar(25),
        @colorblind varchar(10),
        @BMI varchar(25),
        @knownByAlam varchar(500),
        @swmmier varchar(10),
        @spec varchar(10),
        @specAid varchar(10),
        @sourceOfFunding varchar(50),
        @Stream varchar(50)
        
        
)                              
                         
                             
AS                            
BEGIN                            
UPDATE Tbl_Candidate_Personal_Det                            
SET                             
--IdentificationNo=@IdentificationNo  ,                          
Candidate_Fname=@Candidate_Fname,                            
Candidate_Mname=@Candidate_Mname,                            
Candidate_Lname=@Candidate_Lname,                            
Candidate_Gender=@Candidate_Gender,                            
Candidate_Dob=@Candidate_Dob,                            
Candidate_PlaceOfBirth=@Candidate_PlaceOfBirth,                            
Candidate_Nationality=@Candidate_Nationality,                            
Candidate_State=@Candidate_State,                            
Religion=@Religion,                            
Caste=@Caste,                            
Diocese=@Diocese,                            
Parish=@Parish,                            
ApplicationCategory=@ApplicationCategory,                            
Candidate_Category=@Candidate_Category,                            
Candidate_FamilyIncome=@Candidate_FamilyIncome,                            
Candidate_Img=@Candidate_Img,                      
                    
AdharNumber=@AdharNum,                    
RegDate=@RegDate,                    
OldICPassport=@oldicpassport,Salutation=@salutation,               
TypeOfStudent=
case when @Candidate_Nationality =63
then 
''LOCAL''
ELSE
''INTERNATIONAL'' end,

Status=@status,                  
CounselorEmployee_id=@counselorempid,    
AgentName=@agentname,SalesOrganizationName=@salesorgname,                  
SalesHRName=@salesHRname,                
CounselorName=@counselorname,SalesLeadName=@salesleadname,                  
SalesStudentICNo=@salesstudIC,SalesStudentName=@salesstudname,                
candidate_city=@candidate_city,Race=@Race,           
Visa=@Visa,             
Passport =@Passport,              
PassportFrom =@PassportFrom,              
PassportDate=@PassportDate,          
Insurance_detail=@Insurance_detail,        
--Agent_ID=@Agent_ID,        
Residing_Country = @Residing_Country,          
        
        
        
         
  Bh1M_Doc_Name=@br1m_doc,        
  Disability_Doc_name=@disable_doc,        
  Candidate_Marital_Status=@Candidate_Marital_Status,          
        
         
Address_Chkbox_Status=@Address_Chkbox_Status,        
Disability_Chkbox_Status=@Disability_Chkbox_Status,        
Disability_Type=@Disability_Type,        
BR1M_Status=@BR1M_Status,        
        
--Display_Status=@Display_Status,        
SourceofInformation=@SourceofInformation,        
Event_Id=@Event_Id  ,  
Candidate_Signature_Img=@Candidate_Signature_Img  ,
Medical_Closure=@MedicalInfo, Type_ofcomment = @MedicalComment,
Candidate_Age=@CandidateAge,

MethodOfCommunication=@MethodofCommunication,
CurrentGrade=@CurrentGrade,
PresentSchoolName=@PresentSchoolName,
PastSurgeries=@PastSurgeries,PastMedicalHistory=@PastMedicalHistory,
FamilyDoctorName=@FamilyDoctorName,FamilyDoctorAddress=@FamilyDoctorAddress,
Allergy=@Allergy,
Candidate_ReferredBy=@RefBy,
Candidate_Major_Difficulties=@MajDiff,
Candidate_Height=@Height,Candidate_Weight=@weight,Candidate_ColorBlind=@colorblind,Candidate_BMI=@BMI,Candidate_Swimmer=@swmmier,Candidate_WithSpecs=@spec,Candidate_EyeSightAids=@specAid,
SourceOfFunding=@sourceOfFunding,
KnownByAlam=@knownByAlam,
Candidate_Stream=@Stream

WHERE Candidate_Id=@Candidate_Id      
--and Candidate_DelStatus=0                            
            
                  
END  
    ')
END

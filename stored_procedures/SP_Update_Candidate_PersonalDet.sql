IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_PersonalDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Candidate_PersonalDet]                    
(@Candidate_Id bigint,@IdentificationNo varchar(50),@Candidate_Fname varchar(100),@Candidate_Mname varchar(50),@Candidate_Lname varchar(50),                    
@Candidate_Gender varchar(10),@Candidate_Dob varchar(10),                    
 @Candidate_PlaceOfBirth varchar(100),@Candidate_Nationality varchar(100),                    
@Candidate_State varchar(100),@Religion varchar(100),@Caste varchar(100),@Diocese varchar(100),                    
@Parish varchar(100),@ApplicationCategory varchar(100),                    
@Candidate_Category varchar(100),@Candidate_FamilyIncome decimal,@Candidate_Img varchar(max),@Initial_Application_Id bigint,@AdharNum varchar(30),@RegDate datetime,            
@oldicpassport varchar(50),@salutation varchar(50),@campus varchar(100),@typeofstudent varchar(50),            
@status varchar(50),@counselorcampus varchar(50),@counselorempid bigint,@agentname varchar(50),@salesorgname varchar(50),          
@salesHRname varchar(50),@enrollby varchar(50),@counselorname varchar(50),@salesleadname varchar(50)          
,@salesstudIC varchar(50),          
@salesstudname varchar(50),@candidate_city varchar(50),@Race varchar(50),@IDMatrixNo varchar(50),@Sponsorship varchar(50),      
@Visa varchar(200),@VisaFrom varchar(50),@VisaTo varchar(50),@Passport varchar(200),@PassportFrom varchar(200),  
@PassportDate varchar(200),@Insurance_detail varchar(max),@Residing_Country varchar(50),@Room_Type varchar(100),@sponser varchar(50),
@remark varchar(200),@br1m_doc varchar(200),@disable_doc varchar(200),@Candidate_Marital_Status varchar(MAX),@room_required int,
@Option2 int ,@Option3 int,@Address_Chkbox_Status bit,@Disability_Chkbox_Status bit,@Disability_Type varchar(MAX),@BR1M_Status bit,@Mode_Of_Study varchar(Max),
@Display_Status varchar(MAX),@ApplicationStatus varchar(MAX),@SourceofInformation varchar(MAX)  --,@Agent_ID bigint
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
Initial_Application_Id=@Initial_Application_Id,                
AdharNumber=@AdharNum,            
RegDate=@RegDate,            
OldICPassport=@oldicpassport,Salutation=@salutation,            
Campus=@campus,TypeOfStudent=@typeofstudent,Status=@status,          
CounselorCampus=@counselorcampus,CounselorEmployee_id=@counselorempid,          
AgentName=@agentname,SalesOrganizationName=@salesorgname,          
SalesHRName=@salesHRname,EnrollBy=@enrollby,          
CounselorName=@counselorname,SalesLeadName=@salesleadname,          
SalesStudentICNo=@salesstudIC,SalesStudentName=@salesstudname,        
candidate_city=@candidate_city,Race=@Race,IDMatrixNo=@IDMatrixNo,Sponsorship =@Sponsorship,      
Visa=@Visa,      
Passport =@Passport,      
PassportFrom =@PassportFrom,      
PassportDate=@PassportDate,  
Insurance_detail=@Insurance_detail,
--Agent_ID=@Agent_ID,
Residing_Country = @Residing_Country,  
Hostel_Required=@room_required,  
Room_Type=@Room_Type,
Scolorship_Name=@sponser,
Scolorship_Remark=@remark ,  
        
  Bh1M_Doc_Name=@br1m_doc,
  Disability_Doc_name=@disable_doc,
  Candidate_Marital_Status=@Candidate_Marital_Status,  
 Option2=@Option2,Option3=@Option3,
 
Address_Chkbox_Status=@Address_Chkbox_Status,
Disability_Chkbox_Status=@Disability_Chkbox_Status,
Disability_Type=@Disability_Type,
BR1M_Status=@BR1M_Status,
Mode_Of_Study=@Mode_Of_Study,
--Display_Status=@Display_Status,
SourceofInformation=@SourceofInformation
WHERE Candidate_Id=@Candidate_Id and Candidate_DelStatus=0                    
    
          
END 




--select Bh1M_Doc_Name,Disability_Doc_name from Tbl_Candidate_Personal_Det  
    ')
END;

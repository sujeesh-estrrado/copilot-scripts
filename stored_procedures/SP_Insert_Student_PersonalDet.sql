IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Student_PersonalDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Student_PersonalDet]                          
(@IdentificationNo varchar(50),@Candidate_Fname varchar(100),@Candidate_Mname varchar(50),@Candidate_Lname varchar(50),                          
@Candidate_Gender varchar(10),@Candidate_Dob datetime,                          
 @Candidate_PlaceOfBirth varchar(100),@Candidate_Nationality varchar(100),@Candidate_Residing_Country varchar(100),                         
@Candidate_State varchar(100),@Religion varchar(100),@Caste varchar(100),@Diocese varchar(100),                          
@Parish varchar(100),@ApplicationCategory varchar(100),                          
@Candidate_Category varchar(100),@Candidate_FamilyIncome decimal,@Candidate_Img varchar(max),                          
@Candidate_DelStatus bit,@Initial_Application_Id bigint,@New_Admission_Id bigint,@AdharNum varchar(30),                    
@onlineofflinestatus bit,@RegDate datetime,                  
@oldicpassport varchar(50),@salutation varchar(50),@campus varchar(100),@typeofstudent varchar(50),                  
@status varchar(50),@counselorcampus varchar(50),@counselorempid bigint,@agentname varchar(50),@salesorgname varchar(50),                
@salesHRname varchar(50),@enrollby varchar(50),@counselorname varchar(50),@salesleadname varchar(50),@salesstudIC varchar(50),                
@salesstudname varchar(50),@ActiveStatus varchar(50),@candidate_city varchar(50),@Race varchar(50),@IDMatrixNo varchar(50),@Sponsorship varchar(50),          
@Visa varchar(200),@VisaFrom varchar(50),@VisaTo varchar(50),@Passport varchar(200),@PassportFrom varchar(200),@PassportDate varchar(200),@Insurance_detail varchar(max),@Agent_ID bigint,@Room_Type varchar(100),    
@sponser varchar(50),@remark varchar(200),@br1m_doc varchar(200),@disable_doc varchar(200),@room_required int,@Option2 int,@Option3 int,@ApplicationStatus varchar(max),@Enquiry_From varchar(max),@Candidate_Hereaboutus varchar(max)='''',    
@Candidate_MaritalStatus varchar(max),@disabilitystatus Bit,@BR1M_Status bit,@SourceofInformation varchar(MAX),@Mode_Of_Study varchar(MAX),@Disability_Type varchar(MAX)='''',@Event_Id bigint =0,@Candidate_Relation varchar(500)='''',@Preferred_Method_of_Communication varchar(500)='''',
@How_did_you_findout_about_SevenSkiesInternationalSchool varchar(500)='''',@Candidate_ReferredBy varchar(500)='''',@CurrentGrade varchar(500)='''',@PresentSchoolName varchar(500)='''',@PrevProgramme varchar(500)='''',@Age varchar(5)='''' )                      
                           
AS                          
BEGIN                          
BEGIN TRAN       
    
if not exists(select * from Tbl_Candidate_Personal_Det where AdharNumber=@AdharNum and Candidate_Fname=@Candidate_Fname     
and Candidate_Mname=@Candidate_Mname and Candidate_Lname=@Candidate_Lname)    
    
BEGIN    
                       
INSERT INTO dbo.Tbl_Candidate_Personal_Det(Candidate_Fname,Candidate_Mname,Candidate_Lname,Candidate_Gender,Candidate_Dob,                          
Candidate_PlaceOfBirth,Candidate_Nationality,Candidate_State,Religion,Caste,Diocese,Parish,ApplicationCategory,Candidate_Category,                          
Candidate_FamilyIncome,Candidate_Img,Candidate_DelStatus,Initial_Application_Id,New_Admission_Id,AdharNumber,Online_OfflineStatus,RegDate,                  
OldICPassport,Salutation,Campus,TypeOfStudent,Status,CounselorCampus,CounselorEmployee_id,AgentName,                
SalesOrganizationName,SalesHRName,EnrollBy,CounselorName,SalesLeadName,SalesStudentICNo,SalesStudentName,Active_Status,            
candidate_city,Race,IDMatrixNo,Sponsorship,Visa,passport,PassportFrom,PassportDate,Insurance_detail,Agent_ID,Residing_Country,Room_Type,Scolorship_Name,Scolorship_Remark,Bh1M_Doc_Name,Disability_Doc_name,Hostel_Required,    
ApplicationStatus,Option2,Option3,Display_Status,Enquiry_From,Candidate_Hereaboutus,Candidate_Marital_Status,active,Disability_Chkbox_Status,BR1M_Status,SourceofInformation,Mode_Of_Study,Disability_Type,Event_Id,Candidate_Relation,Preferred_Method_of_Communication
,How_did_you_findout_about_SevenSkiesInternationalSchool,Candidate_ReferredBy,CurrentGrade,PresentSchoolName,Candidate_Stream,ApplicationStage,Candidate_Age)                          
VALUES                          
(@Candidate_Fname,@Candidate_Mname,@Candidate_Lname,@Candidate_Gender,@Candidate_Dob,@Candidate_PlaceOfBirth,                          
@Candidate_Nationality,@Candidate_State,@Religion,@Caste,@Diocese,@Parish,@ApplicationCategory,@Candidate_Category,                  
@Candidate_FamilyIncome,@Candidate_Img,@Candidate_DelStatus,@Initial_Application_Id,@New_Admission_Id,@AdharNum,@onlineofflinestatus,@RegDate,                  
@oldicpassport,@salutation,@campus,@typeofstudent,@status,@counselorcampus,@counselorempid,@agentname,                
@salesorgname,@salesHRname,@enrollby,@counselorname,@salesleadname,@salesstudIC,@salesstudname,@ActiveStatus,            
@candidate_city,@Race,@IDMatrixNo,@Sponsorship,@Visa,@Passport,@PassportFrom,@PassportDate,@Insurance_detail,@Agent_ID,@Candidate_Residing_Country,@Room_Type,@sponser,@remark,@br1m_doc,    
@disable_doc,@room_required,@ApplicationStatus,@Option2,@Option3,''Candidatefirst'',@Enquiry_From,@Candidate_Hereaboutus,@Candidate_MaritalStatus,3,@disabilitystatus,@BR1M_Status,@SourceofInformation,@Mode_Of_Study,@Disability_Type,
@Event_Id,@Candidate_Relation,@Preferred_Method_of_Communication,@How_did_you_findout_about_SevenSkiesInternationalSchool,@Candidate_ReferredBy,@CurrentGrade,@PresentSchoolName,@PrevProgramme,''Initial Application'',@Age)               
           
                   
       
select Scope_identity()       
End    
    
else    
    
Begin    
    
select -1    
    
end    
                
COMMIT TRAN                           
                          
END

');
END;

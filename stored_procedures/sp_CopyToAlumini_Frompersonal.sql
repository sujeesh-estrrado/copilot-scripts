IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_CopyToAlumini_Frompersonal]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_CopyToAlumini_Frompersonal] --0,0,0,''all'',''2018-09-01 00:00:00.000'',null,1,100000  
(  
@Candidate_Id bigint=0  
)  
as   
begin  
 INSERT INTO tbl_alumini (Candidate_Id,IdentificationNo,Candidate_Fname,Candidate_Mname,Candidate_Lname,Candidate_Gender,  
 Candidate_Dob,Candidate_PlaceOfBirth,Candidate_Nationality,Candidate_State,  
  candidate_city,  
  Religion,Caste,  
  Diocese,Parish,ApplicationCategory,Candidate_Category,Candidate_FamilyIncome,Candidate_Img ,Candidate_DelStatus,Initial_Application_Id,  
  New_Admission_Id,AdharNumber,Online_OfflineStatus,AdmissionType,RegDate,OldICPassport,Salutation,Campus,TypeOfStudent,  
  Status,CounselorCampus,CounselorEmployee_id,AgentName,SalesStudentICNo,SalesStudentName,SalesOrganizationName,SalesHRName,  
  EnrollBy,CounselorName,SalesLeadName,Active_Status,Race,IDMatrixNo,Sponsorship,Visa,VisaFrom,VisaTo,Passport,PassportFrom,PassportDate,  
  Insurance_detail,Agent_ID,Residing_Country,Hostel_Required,Room_Type,Scolorship_Name,Scolorship_Remark,Bh1M_Doc_Name ,Disability_Doc_name,ApplicationStatus,  
  Option2,Option3,FeeStatus,Candidate_Marital_Status,Address_Chkbox_Status,Disability_Chkbox_Status,Disability_Type,BR1M_Status,Mode_Of_Study,Edit_status,  
  Edit_request,Display_Status,Enquiry_From,Candidate_Hereaboutus,bankid1,bankaccountno1,bankid2,bankaccountno2,billoutstanding,  
  sponsor,Editable,Invoice_Status,Payment_Request_Status,surname,create_date,active,LastUpdate,SourceofInformation,ApplicationStage,Edit_request_remark,  
  CouncelloAttendedLastDate,recruitedby_other,sourceplace,barracuda_state,barracuda_city,documentcomplete)  
 SELECT Candidate_Id,IdentificationNo,Candidate_Fname,Candidate_Mname,Candidate_Lname,Candidate_Gender,  
 Candidate_Dob,Candidate_PlaceOfBirth,Candidate_Nationality,Candidate_State,  
  candidate_city,  
  Religion,Caste,  
  Diocese,Parish,ApplicationCategory,Candidate_Category,Candidate_FamilyIncome,Candidate_Img ,Candidate_DelStatus,Initial_Application_Id,  
  New_Admission_Id,AdharNumber,Online_OfflineStatus,AdmissionType,RegDate,OldICPassport,Salutation,Campus,TypeOfStudent,  
  Status,CounselorCampus,CounselorEmployee_id,AgentName,SalesStudentICNo,SalesStudentName,SalesOrganizationName,SalesHRName,  
  EnrollBy,CounselorName,SalesLeadName,Active_Status,Race,IDMatrixNo,Sponsorship,Visa,VisaFrom,VisaTo,Passport,PassportFrom,PassportDate,  
  Insurance_detail,Agent_ID,Residing_Country,Hostel_Required,Room_Type,Scolorship_Name,Scolorship_Remark,Bh1M_Doc_Name ,Disability_Doc_name,ApplicationStatus,  
  Option2,Option3,FeeStatus,Candidate_Marital_Status,Address_Chkbox_Status,Disability_Chkbox_Status,Disability_Type,BR1M_Status,Mode_Of_Study,Edit_status,  
  Edit_request,Display_Status,Enquiry_From,Candidate_Hereaboutus,bankid1,bankaccountno1,bankid2,bankaccountno2,billoutstanding,  
  sponsor,Editable,Invoice_Status,Payment_Request_Status,surname,create_date,active,LastUpdate,SourceofInformation,ApplicationStage,Edit_request_remark,  
  CouncelloAttendedLastDate,recruitedby_other,sourceplace,barracuda_state,barracuda_city,documentcomplete  
 FROM tbl_Candidate_personal_Det  
 where Candidate_Id=@Candidate_Id and Candidate_DelStatus=0;  
  
end 
    ')
END

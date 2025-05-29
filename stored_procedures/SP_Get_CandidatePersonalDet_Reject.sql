IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CandidatePersonalDet_Reject]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_CandidatePersonalDet_Reject] --30285
(@Candidate_Id bigint)                      
as                      
begin                      
select IdentificationNo,Candidate_Fname,Candidate_Mname,Candidate_Lname,
concat (Candidate_Fname,'' '',Candidate_Lname) as CandidateName ,Candidate_Gender,  SourceofInformation ,
Candidate_Dob,
--convert(varchar(15),Candidate_Dob,103) as Candidate_Dob,  
--convert(datetime, Candidate_Dob, 100) as Candidate_Dob,
                    
Candidate_PlaceOfBirth,Candidate_Nationality,Candidate_State,Religion,Caste,Diocese,Parish,ApplicationCategory,Candidate_Category,Race,Tbl_Nationality.Nationality,                     
Candidate_FamilyIncome,Candidate_Img,Initial_Application_Id,New_Admission_Id,AdharNumber,RegDate,Address_Chkbox_Status,[Tbl_Organzations ].Organization_Name as campus,             
 OldICPassport,Salutation,TypeOfStudent,Tbl_Student_status.name as Status,CounselorCampus,CounselorEmployee_id,AgentName,Candidate_Marital_Status,            
SalesOrganizationName,SalesHRName,EnrollBy,CounselorName,SalesLeadName,SalesStudentICNo,SalesStudentName,CounselorEmployee_id,Mode_Of_Study,        
candidate_city,Race,IDMatrixNo,Sponsorship,Visa,VisaFrom,VisaTo,Passport,PassportFrom,PassportDate,Insurance_detail,Agent_Name,Residing_Country,Room_Type,Scolorship_Name,
Scolorship_Remark,Option2,Option3 ,ApplicationStatus, Hostel_Required,BR1M_Status,Bh1M_Doc_Name,Disability_Chkbox_Status,Disability_Type,Disability_Doc_name,SourceofInformation

						
from Tbl_Candidate_Personal_Det  inner join Tbl_Nationality on Tbl_Candidate_Personal_Det.Candidate_Nationality=Tbl_Nationality.Nationality_Id  left join Tbl_Student_status on Tbl_Student_status.id=Tbl_Candidate_Personal_Det.active  
left join [dbo].[Tbl_Agent]  on  Tbl_Candidate_Personal_Det.Agent_ID=[Tbl_Agent].Agent_ID   
left join [Tbl_Organzations ] on [Tbl_Organzations ].Organization_Id=  Tbl_Candidate_Personal_Det.Campus     
 where  Candidate_Id=@Candidate_Id                       
                      
end    ');
END;

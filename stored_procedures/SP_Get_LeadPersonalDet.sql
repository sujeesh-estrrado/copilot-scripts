IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_LeadPersonalDet]')
    AND type = N'P'
)
BEGIN
    EXEC('
         
CREATE procedure [dbo].[SP_Get_LeadPersonalDet] --42376      
@Candidate_Id bigint                            
as                            
begin                            
select IdentificationNo,Candidate_Fname,Candidate_Mname,Candidate_Lname,Tbl_Student_status.name as CurrentStatus,Tbl_Student_status.id as currentsttatusid,      
concat(Tbl_Student_status.name,'' - '',      
Case When ApplicationStatus=''pending''Then ''Enquiry List''      
When ApplicationStatus=''Pending''Then ''Enquiry List''      
When ApplicationStatus=''submited''Then ''Enquiry List''      
When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''      
When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''      
When ApplicationStatus=''Completed''Then ''Student List(Admissions)''     
When ApplicationStatus=''Lead''Then ''Enquiry List''   
Else ''Rejected'' end) as Status,      
concat (Candidate_Fname,'' '',Candidate_Lname) as CandidateName ,Candidate_Gender,  Source_name ,      
Candidate_Dob,Candidate_PlaceOfBirth,Candidate_Nationality,Candidate_State,Religion,Caste,Diocese,ApplicationCategory,Candidate_Category,Race,Tbl_Nationality.Nationality,                           
Candidate_FamilyIncome,Candidate_Img,Initial_Application_Id,Tbl_Lead_Personal_Det.New_Admission_Id,AdharNumber,RegDate,Address_Chkbox_Status,concat([Tbl_Organzations ].Organization_Code,''-'',[Tbl_Organzations ].Organization_Name)as campus,              
    
      
      
      
OldICPassport,Salutation,TypeOfStudent,      
CounselorCampus,(case When CounselorEmployee_id='''' then ''-NA-'' when CounselorEmployee_id is null then ''-NA-'' else CONCAT(Employee_FName,'' '',Employee_LName)end) as CounselorName,CounselorEmployee_id,Candidate_Marital_Status,                  
SalesOrganizationName,SalesHRName,EnrollBy,SalesLeadName,SalesStudentICNo,SalesStudentName,CounselorEmployee_id,Mode_Of_Study,              
candidate_city,Race,IDMatrixNo,Sponsorship,Visa,VisaFrom,VisaTo,Passport,PassportFrom,PassportDate,Insurance_detail,Agent_Name,Residing_Country,Room_Type,Scolorship_Name,      
Scolorship_Remark,Option2,Option3 ,ApplicationStatus, Hostel_Required,BR1M_Status,Bh1M_Doc_Name,Disability_Chkbox_Status,Disability_Type,Disability_Doc_name,Source_name,Candidate_DelStatus,      
recruitedby_other,COALESCE(tbl_New_Admission.Department_Id, 0 ) as DepartmentID,cbd.Batch_Code  ,
case when  tbl_New_Admission.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=tbl_New_Admission.Department_Id)  end  as Department 
      
      
            
from Tbl_Lead_Personal_Det  left join Tbl_Nationality on Cast(Tbl_Lead_Personal_Det.Candidate_Nationality as bigint)=Tbl_Nationality.Nationality_Id        
left join Tbl_Student_status on Tbl_Student_status.id=Tbl_Lead_Personal_Det.active        
left join [dbo].[Tbl_Agent]  on  Tbl_Lead_Personal_Det.Agent_ID=[Tbl_Agent].Agent_ID         
left join [Tbl_Organzations ] on [Tbl_Organzations ].Organization_Id=  Tbl_Lead_Personal_Det.Campus      
left join Tbl_Employee on  Tbl_Lead_Personal_Det.CounselorEmployee_id=Tbl_Employee.Employee_Id        
left join tbl_New_Admission ON Tbl_Lead_Personal_Det.New_Admission_Id = tbl_New_Admission.New_Admission_Id      
left join Tbl_Course_Batch_Duration cbd on cbd.Batch_Id=tbl_New_Admission.Batch_Id      
 where  Candidate_Id=@Candidate_Id                           
                            
end
    ')
END

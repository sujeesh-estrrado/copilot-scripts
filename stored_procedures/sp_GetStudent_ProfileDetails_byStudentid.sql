IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetStudent_ProfileDetails_byStudentid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_GetStudent_ProfileDetails_byStudentid] --2
@Student_Id bigint,
@flag BIGINT
as
Begin
if(@flag=0)
BEGIN
    SELECT DISTINCT 
    P.Candidate_Id,CPD.Candidate_Fname,P.Mode_Of_Study,P.Scolorship_Remark,Tbl_Student_status.name as CurrentStatus,
    concat(Tbl_Student_status.name,'' - '',
    Case When P.ApplicationStatus=''pending''Then ''Enquiry List''
When P.ApplicationStatus=''Pending''Then ''Enquiry List''
When P.ApplicationStatus=''submited''Then ''Enquiry List''
When P.ApplicationStatus=''approved''Then ''Candidate List(Admissions)''
When P.ApplicationStatus=''Verified''Then ''Verified List(Admissions)''
When P.ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''
When P.ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''
When P.ApplicationStatus=''Completed''Then ''Student List(Admissions)''
Else ''Student List(Admissions)'' end )as Status,

    concat (CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as CandidateName ,CPD.Candidate_Gender,  
    CPD.SourceofInformation ,CPD.Candidate_Dob,ApplicationCategory,Candidate_Category,Tbl_Nationality.Nationality,                     
    Candidate_Img,P.Initial_Application_Id,P.New_Admission_Id,CPD.AdharNumber,P.CounselorEmployee_id,CPD.Agent_ID,
    P.RegDate,concat([Tbl_Organzations ].Organization_Code,''-'',[Tbl_Organzations ].Organization_Name)as campus,             
    CPD.TypeOfStudent,P.CounselorCampus,CONCAT(Employee_FName,'' '',Employee_LName) as CounselorName,P.CounselorEmployee_id,
            
    P.EnrollBy,CounselorName,P.CounselorEmployee_id,P.Mode_Of_Study, P.Campus as organization,       
    P.IDMatrixNo,Sponsorship,Visa,VisaFrom,VisaTo,Passport,PassportFrom,PassportDate,Insurance_detail,
    Agent_Name,Residing_Country,Room_Type,P.Scolorship_Name,
    P.Option2,P.Option3 ,P.ApplicationStatus, Hostel_Required,BR1M_Status,Bh1M_Doc_Name,Disability_Chkbox_Status,Disability_Type,Disability_Doc_name,SourceofInformation,
    P.Candidate_DelStatus,CPD.recruitedby_other



    FROM dbo.Tbl_Student_NewApplication AS P
    left Join Tbl_Candidate_Personal_Det CPD  on CPD.Candidate_Id=P.Candidate_Id
    left join Tbl_Nationality on CPD.Candidate_Nationality=Tbl_Nationality.Nationality_Id  
    left join Tbl_Student_status on Tbl_Student_status.id=P.active  
    left join [dbo].[Tbl_Agent]  on  CPD.Agent_ID=[Tbl_Agent].Agent_ID   
    left join [Tbl_Organzations ] on [Tbl_Organzations ].Organization_Id=  P.Campus
    left join Tbl_Employee on  P.CounselorEmployee_id=Tbl_Employee.Employee_Id  
    WHERE (P.Candidate_Id = @Student_Id) and P.Candidate_DelStatus=0

    END
     
 
end
');
END;
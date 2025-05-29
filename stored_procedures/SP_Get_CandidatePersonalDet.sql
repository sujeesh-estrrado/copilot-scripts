IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CandidatePersonalDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_CandidatePersonalDet] --42376            
 @Candidate_Id  bigint    ,
@flag BIGINT=0
as                                  
begin     
     

--select IdentificationNo,Candidate_Fname,Candidate_Mname,Concat(Tbl_Employee.Employee_FName,'''' ,Tbl_Employee.Employee_LName) as CounselorName,Candidate_Lname,Tbl_Student_status.name as CurrentStatus,Tbl_Student_status.id as currentsttatusid,            
----concat(
--Tbl_Student_status.name as Status, 
----,'' - '',            
----Case When ApplicationStatus=''pending''Then ''Enquiry List''            
----When ApplicationStatus=''Pending''Then ''Enquiry List''            
----When ApplicationStatus=''submited''Then ''Enquiry List''            
----When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''            
----When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''            
----When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''            
----When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''            
----When ApplicationStatus=''Completed''Then ''Student List(Admissions)''            
----Else ''Student List(Admissions)'' end) 
           
--concat (Candidate_Fname,'' '',Candidate_Lname) as CandidateName ,Candidate_Gender,  SourceofInformation ,            
--Candidate_Dob,Candidate_PlaceOfBirth,Candidate_Nationality,Candidate_State,Religion,Caste,Diocese,Parish,ApplicationCategory,Candidate_Category,Race,
--Tbl_Nationality.Nationality,   
                        
--Candidate_FamilyIncome,Candidate_Img,Initial_Application_Id,Tbl_Candidate_Personal_Det.New_Admission_Id,AdharNumber,RegDate,Address_Chkbox_Status,concat([Tbl_Organzations ].Organization_Code,''-'',[Tbl_Organzations ].Organization_Name)as campus,            
  
    
      
        
          
            
            
            
--OldICPassport,Salutation,TypeOfStudent,            
--CounselorCampus,(case When CounselorEmployee_id='''' then ''-NA-'' when CounselorEmployee_id is null then ''-NA-'' else CONCAT(Employee_FName,'' '',Employee_LName)end) as CounselorName,CounselorEmployee_id,Candidate_Marital_Status,                        
--SalesOrganizationName,SalesHRName,EnrollBy,SalesLeadName,SalesStudentICNo,SalesStudentName,CounselorEmployee_id,Mode_Of_Study,                    
--candidate_city,Race,IDMatrixNo,Sponsorship,Visa,VisaFrom,VisaTo,Passport,PassportFrom,PassportDate,Insurance_detail,Agent_Name,Residing_Country,Room_Type,Scolorship_Name,            
--Scolorship_Remark,Option2,Option3 ,ApplicationStatus, Hostel_Required,BR1M_Status,Bh1M_Doc_Name,Disability_Chkbox_Status,Disability_Type,Disability_Doc_name,SourceofInformation,SourceOfFunding,MethodOfCommunication,Preferred_Method_of_Communication,CurrentGrade,PresentSchoolName,PastSurgeries,PastMedicalHistory,FamilyDoctorName,FamilyDoctorAddress,Allergy,PrevProgrammeName,Candidate_Stream,Candidate_Major_Difficulties,Candidate_Swimmer,Candidate_BMI,Candidate_ColorBlind,Candidate_Height,Candidate_Weight,Candidate_WithSpecs,Candidate_EyeSightAids,Candidate_DelStatus,KnownByAlam,         
--recruitedby_other,COALESCE(tbl_New_Admission.Department_Id, 0 ) as DepartmentID,cbd.Batch_Code  
--,PreactivateFlag,Candidate_Signature_Img    ,'''' as  CampusName,   '''' as Agent_ID    ,'''' as Reg_Type, '''' as Bumiputra   
--                ,'''' as CitizenshipStatus,
--              '''' as CitizenshipCountry,'''' as FamilyIncome,''''as Agent_Email,'''' as Disability,'''' as AgentEmail,'''' as MMUStudName,'''' as MMUStudIC,Disability_Doc_name,'''' as DisabilityCode,'''' as Employee_Mobile,Medical_Closure,Type_ofcomment,Employee_FName,Employee_LName,Employee_Mail,Employee_Mobile
                
            
            
                  
--from Tbl_Candidate_Personal_Det 
--left join Tbl_Nationality on Tbl_Candidate_Personal_Det.Candidate_Nationality=convert(varchar(5),Tbl_Nationality.Nationality_Id )             
--left join Tbl_Student_status on Tbl_Student_status.id=Tbl_Candidate_Personal_Det.active              
--left join [dbo].[Tbl_Agent]  on  Tbl_Candidate_Personal_Det.Agent_ID=[Tbl_Agent].Agent_ID               
--left join [Tbl_Organzations ] on [Tbl_Organzations ].Organization_Id=  Tbl_Candidate_Personal_Det.Campus            
--left join Tbl_Employee on  Tbl_Candidate_Personal_Det.CounselorEmployee_id=Tbl_Employee.Employee_Id              
--left join tbl_New_Admission ON Tbl_Candidate_Personal_Det.New_Admission_Id = tbl_New_Admission.New_Admission_Id            
--left join Tbl_Course_Batch_Duration cbd on cbd.Batch_Id=tbl_New_Admission.Batch_Id            
-- where  Candidate_Id=@Candidate_Id                                 
           
           
     if(@flag=0)          
begin 
 
-- select 
--    IdentificationNo,
--    Candidate_Fname,
--    Candidate_Mname,
--    Concat(Tbl_Employee.Employee_FName, '' '', Tbl_Employee.Employee_LName) as CounselorName,
--    Candidate_Lname,
--    Tbl_Student_status.name as CurrentStatus,
--    Tbl_Student_status.id as currentsttatusid,
--    Tbl_Student_status.name as Status,
--    concat(Candidate_Fname, '' '', Candidate_Lname) as CandidateName,
--    Candidate_Gender,
--    SourceofInformation,
--    Candidate_Dob,
--    Candidate_PlaceOfBirth,
--    Candidate_Nationality,
--    Candidate_State,
--    Religion,
--    Caste,
--    Diocese,
--    Parish,
--    ApplicationCategory,
--    Candidate_Category,
--    Race,
--    Tbl_Nationality.Nationality,
--    Candidate_FamilyIncome,
--    Candidate_Img,
--    Initial_Application_Id,
--    Tbl_Candidate_Personal_Det.New_Admission_Id,
--    AdharNumber,
--    RegDate,
--    Address_Chkbox_Status,
--    concat([Tbl_Organzations].Organization_Code, ''-'', [Tbl_Organzations].Organization_Name) as campus,
--    OldICPassport,
--    Salutation,
--    TypeOfStudent,
--    CounselorCampus,
--    (case 
--        When CounselorEmployee_id = '''' then ''-NA-'' 
--        when CounselorEmployee_id is null then ''-NA-'' 
--        else CONCAT(Employee_FName, '' '', Employee_LName)
--    end) as CounselorName,
--    CounselorEmployee_id,
--    Candidate_Marital_Status,
--    SalesOrganizationName,
--    SalesHRName,
--    EnrollBy,
--    SalesLeadName,
--    SalesStudentICNo,
--    SalesStudentName,
--    CounselorEmployee_id,
--    Mode_Of_Study,
--    candidate_city,
--    Race,
--    IDMatrixNo,
--    Sponsorship,
--    Visa,
--    VisaFrom,
--    VisaTo,
--    Passport,
--    PassportFrom,
--    PassportDate,
--    Insurance_detail,
--    Agent_Name,
--    Residing_Country,
--    Room_Type,
--    Scolorship_Name,
--    Scolorship_Remark,
--    Option2,
--    Option3,
--    ApplicationStatus,
--    Hostel_Required,
--    BR1M_Status,
--    Bh1M_Doc_Name,
--    Disability_Chkbox_Status,
--    Disability_Type,
--    Disability_Doc_name,
--    SourceofInformation,
--    SourceOfFunding,
--    MethodOfCommunication,
--    Preferred_Method_of_Communication,
--    CurrentGrade,
--    PresentSchoolName,
--    PastSurgeries,
--    PastMedicalHistory,
--    FamilyDoctorName,
--    FamilyDoctorAddress,
--    Allergy,
--    PrevProgrammeName,
--    Candidate_Stream,
--    Candidate_Major_Difficulties,
--    Candidate_Swimmer,
--    Candidate_BMI,
--    Candidate_ColorBlind,
--    Candidate_Height,
--    Candidate_Weight,
--    Candidate_WithSpecs,
--    Candidate_EyeSightAids,
--    Candidate_DelStatus,
--    KnownByAlam,
--    recruitedby_other,
--    COALESCE(tbl_New_Admission.Department_Id, 0) as DepartmentID,
--    cbd.Batch_Code,
--    PreactivateFlag,
--    Candidate_Signature_Img,
--    '''' as CampusName,
--    '''' as Agent_ID,
--    '''' as Reg_Type,
--    '''' as Bumiputra,
--    '''' as CitizenshipStatus,
--    '''' as CitizenshipCountry,
--    '''' as FamilyIncome,
--    '''' as Agent_Email,
--    '''' as Disability,
--    '''' as AgentEmail,
--    '''' as MMUStudName,
--    '''' as MMUStudIC,
--    Disability_Doc_name,
--    '''' as DisabilityCode,
--    '''' as Employee_Mobile,
--    Medical_Closure,
--    Type_ofcomment,
--    Employee_FName,
--    Employee_LName,
--    Employee_Mail,
--    Employee_Mobile
--from 
--    Tbl_Candidate_Personal_Det 
--    left join Tbl_Nationality on Tbl_Candidate_Personal_Det.Candidate_Nationality = convert(varchar(5), Tbl_Nationality.Nationality_Id)
--    left join Tbl_Student_status on Tbl_Student_status.id = Tbl_Candidate_Personal_Det.active
--    left join [dbo].[Tbl_Agent] on Tbl_Candidate_Personal_Det.Agent_ID = [Tbl_Agent].Agent_ID
--    left join [Tbl_Organzations] on [Tbl_Organzations].Organization_Id = Tbl_Candidate_Personal_Det.Campus
--    left join Tbl_Employee on Tbl_Candidate_Personal_Det.CounselorEmployee_id = Tbl_Employee.Employee_Id
--    left join tbl_New_Admission ON Tbl_Candidate_Personal_Det.New_Admission_Id = tbl_New_Admission.New_Admission_Id
--    left join Tbl_Course_Batch_Duration cbd on cbd.Batch_Id = tbl_New_Admission.Batch_Id
--where 
--    Candidate_Id = @Candidate_Id
SELECT 
    cpd.IdentificationNo,
    cpd.Candidate_Fname,
    cpd.Candidate_Mname,
    CONCAT(emp.Employee_FName, '' '', emp.Employee_LName) AS CounselorName,
     CONCAT(emp.Employee_FName, '' '', emp.Employee_LName) AS CounselorName1,
    cpd.Candidate_Lname,
    sts.name AS CurrentStatus,
    sts.id AS currentsttatusid,
    sts.name AS Status,
    CONCAT(cpd.Candidate_Fname, '' '', cpd.Candidate_Lname) AS CandidateName,
    cpd.Candidate_Gender,
    cpd.SourceofInformation,
    cpd.Candidate_Dob,
    cpd.Candidate_PlaceOfBirth,
    cpd.Candidate_Nationality,
    cpd.Candidate_State,
    cpd.Religion,
    cpd.Caste,
    cpd.Candidate_Id AS CandidateId,
    cpd.Diocese,
    cpd.Parish,
    cpd.ApplicationCategory,
    cpd.Candidate_Category,
    cpd.Race,
    nat.Nationality,
    cpd.Candidate_FamilyIncome,
    cpd.Candidate_Img,
    cpd.Initial_Application_Id,
    cpd.New_Admission_Id,
    cpd.AdharNumber,
    cpd.RegDate,
    cpd.Address_Chkbox_Status,
    CONCAT(org.Organization_Code, ''-'', org.Organization_Name) AS campus,
    cpd.OldICPassport,
    cpd.Salutation,
    cpd.TypeOfStudent,
    cpd.CounselorCampus,
    CASE 
        WHEN cpd.CounselorEmployee_id = '''' OR cpd.CounselorEmployee_id IS NULL THEN ''-NA-'' 
        ELSE CONCAT(emp.Employee_FName, '' '', emp.Employee_LName)
    END AS CounselorNameFinal,
    cpd.CounselorEmployee_id,
    cpd.Candidate_Marital_Status,
    cpd.SalesOrganizationName,
    cpd.SalesHRName,
    cpd.EnrollBy,
    cpd.SalesLeadName,
    cpd.SalesStudentICNo,
    cpd.SalesStudentName,
    cpd.Mode_Of_Study,
    cpd.candidate_city,
    cpd.Race,
    cpd.IDMatrixNo,
    cpd.Sponsorship,
    cpd.Visa,
    cpd.VisaFrom,
    cpd.VisaTo,
    cpd.Passport,
    cpd.PassportFrom,
    cpd.PassportDate,
    cpd.Insurance_detail,
    ag.Agent_Name,
    cpd.Residing_Country,
    cpd.Room_Type,
    cpd.Scolorship_Name,
    cpd.Scolorship_Remark,
    cpd.Option2,
    cpd.Option3,
    cpd.ApplicationStatus,
    cpd.Hostel_Required,
    cpd.BR1M_Status,
    cpd.Bh1M_Doc_Name,
    cpd.Disability_Chkbox_Status,
    cpd.Disability_Type,
    cpd.Disability_Doc_name,
    cpd.SourceOfFunding,
    cpd.MethodOfCommunication,
    cpd.Preferred_Method_of_Communication,
    cpd.CurrentGrade,
    cpd.PresentSchoolName,
    cpd.PastSurgeries,
    cpd.PastMedicalHistory,
    cpd.FamilyDoctorName,
    cpd.FamilyDoctorAddress,
    cpd.Allergy,
    cpd.PrevProgrammeName,
    cpd.Candidate_Stream,
    cpd.Candidate_Major_Difficulties,
    cpd.Candidate_Swimmer,
    cpd.Candidate_BMI,
    cpd.Candidate_ColorBlind,
    cpd.Candidate_Height,
    cpd.Candidate_Weight,
    cpd.Candidate_WithSpecs,
    cpd.Candidate_EyeSightAids,
    cpd.Candidate_DelStatus,
    cpd.KnownByAlam,
    cpd.recruitedby_other,
    COALESCE(na.Department_Id, 0) AS DepartmentID,
    cbd.Batch_Code,
    cpd.PreactivateFlag,
    cpd.Candidate_Signature_Img,
    '''' AS CampusName,
    '''' AS Agent_ID,
    '''' AS Reg_Type,
    '''' AS Bumiputra,
    '''' AS CitizenshipStatus,
    '''' AS CitizenshipCountry,
    '''' AS FamilyIncome,
    '''' AS Agent_Email,
    '''' AS Disability,
    '''' AS AgentEmail,
    '''' AS MMUStudName,
    '''' AS MMUStudIC,
    cpd.Disability_Doc_name,
    '''' AS DisabilityCode,
    '''' AS Employee_Mobile,
    cpd.Medical_Closure,
    cpd.Type_ofcomment,
    emp.Employee_FName,
    emp.Employee_LName,
    emp.Employee_Mail,
    emp.Employee_Mobile,
    mcd.Modular_Candidate_Id,
    mcd.Modular_Course_Id,
    mcd.Modular_Slot_Id,
    mcd.Application_Status AS status,
    mcd.Application_Status AS ModularCourseStatus,
    mcd.Status AS CourseStatus
FROM 
    Tbl_Candidate_Personal_Det cpd
LEFT JOIN Tbl_Nationality nat ON cpd.Candidate_Nationality = CONVERT(VARCHAR(5), nat.Nationality_Id)
LEFT JOIN Tbl_Student_status sts ON sts.id = cpd.active
LEFT JOIN Tbl_Agent ag ON cpd.Agent_ID = ag.Agent_ID
LEFT JOIN Tbl_Organzations org ON org.Organization_Id = cpd.Campus
LEFT JOIN Tbl_Employee emp ON cpd.CounselorEmployee_id = emp.Employee_Id
LEFT JOIN tbl_New_Admission na ON cpd.New_Admission_Id = na.New_Admission_Id
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = na.Batch_Id
LEFT JOIN Tbl_Modular_Candidate_Details mcd ON mcd.Candidate_Id = cpd.Candidate_Id and mcd.Delete_Status=0
WHERE 
    cpd.Candidate_Id = @Candidate_Id;

    END

    if(@flag=10)          
BEGIN
 SELECT 
    MC.Candidate_Fname AS CandidateName,
    MC.Ic_Passport AS AdharNumber,
    MC.Ic_Passport AS ICPassport,
    MC.Gender,
    MC.Type,
    MC.Email,
    C.Nationality AS Nationality,
    MC.Contact,
 --'' ('' + CAST(MC.Country_Code AS VARCHAR(10)) + '')''+ CAST(MC.Contact AS VARCHAR(50))   AS Contact,
    MC.Application_Status AS ModularCourseStatus,
    MC.Modular_Slot_Id,
    MC.Status
FROM 
    Tbl_Modular_Candidate_Details MC
    Inner Join Tbl_Nationality C on MC.Country=C.Nationality_Id
    WHERE 
        MC.Modular_Candidate_Id = @Candidate_Id
END
end
    ');
END;

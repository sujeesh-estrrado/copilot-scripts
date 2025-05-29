IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_candidatedetails_by_UserID_NEW]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE Procedure [dbo].[sp_Get_candidatedetails_by_UserID_NEW]
@User_Id bigint=0
as
begin
SELECT Top 1   
FORMAT(DATEADD(MONTH, 0, TRY_CAST(SUBSTRING(batch_code, 1, 4) + ''-'' + SUBSTRING(batch_code, 6, 2) + ''-01'' AS DATE)), ''MMMM-yyyy'') AS Intake,cbd.batch_id,
P.Candidate_Id,TSU.User_Id, P.Candidate_Fname, P.Candidate_Lname,concat(P.Candidate_Fname,'' '',P.Candidate_Lname) as candidatename, P.AdharNumber, C.Candidate_Mob1, C.Candidate_Mob2, C.Candidate_Email, P.Candidate_Nationality ,P.IDMatrixNo,          
P.TypeOfStudent, CONVERT(VARCHAR(10),  P.Candidate_Dob, 21)  AS Candidate_Dob,P.PassRefNo    ,P.Candidate_Age as Age,  
P.Candidate_Nationality AS Expr1, P.Religion,P.SourceofInformation,p.EnrollBy,ApplicationStage,P.Candidate_Gender, P.Race,          
 P.Candidate_Marital_Status,P.PassportDate, C.Candidate_Telephone, C.Candidate_PermAddress, C.Candidate_PermAddress_Line2, C.Candidate_PermAddress_postCode, C.Candidate_PermAddress_Country,           
C.Candidate_PermAddress_State, C.Candidate_PermAddress_City, C.Candidate_ContAddress, C.Candidate_ContAddress_Line2, C.Candidate_ContAddress_postCode, C.Candidate_ContAddress_Country,           
C.Candidate_ContAddress_State, C.Candidate_ContAddress_City, P.New_Admission_Id, P.Option2, P.Option3, P.Address_Chkbox_Status, P.Disability_Chkbox_Status, P.Disability_Type, P.BR1M_Status,           
P.CounselorEmployee_id, P.Residing_Country, P.Hostel_Required, P.Room_Type, P.Scolorship_Name, P.Mode_Of_Study, P.ApplicationStatus, P.Candidate_Img,P.CurrentGrade,P.PresentSchoolName,P.MethodOfCommunication,P.PastSurgeries,P.PastMedicalHistory,P.Allergy,P.FamilyDoctorName,p.FamilyDoctorAddress,
P.Candidate_ReferredBy,P.Candidate_Major_Difficulties,P.How_did_you_findout_about_SevenSkiesInternationalSchool,P.Preferred_Method_of_Communication,
P.Candidate_Height,P.Candidate_Weight,P.Candidate_ColorBlind,P.Candidate_BMI,P.Candidate_Swimmer,P.Candidate_WithSpecs,P.Candidate_EyeSightAids,P.SourceOfFunding,P.Candidate_Height,P.Candidate_BMI,P.Candidate_Weight,
C.Emergency_Check_Status,P.Candidate_Stream,P.KnownByAlam,           
P.Bh1M_Doc_Name, P.Disability_Doc_name, C.Emergency_Parent_IcpassportNo,C.ParentCTC as ParentCTC,C.NoOfDependents,  C.Emergency_Name1, C.Emergency_Relation, C.Emergency_Mob, C.Emergency_Telephone, C.Emergency_Mail, C.Emergency_Address1,           
C.Emergency_Address2, C.Emergency_Postcode, C.Emergency_Country, C.Emergency_State, C.Emergency_City,C.ParentCompanyName,C.Candidate_FatherOcc,C.ParentSalaryRange,C.GuardianOccupation,C.GuardianCompanyName,C.GuardSalaryRange,C.NoOfDependents,
C.DependentVisa,C.sibilings,C.brothers,C.age,C.sister,C.sister_age,C.tongue,C.hobby,C.language,C.ParentTelegramUsername,C.OtherMemberName,D.Department_Name,D.Department_Id, D1.Department_Name,P.Display_Status, P.Edit_status, P.Edit_request,P.Editable          
,FatherMobileNo,candidate_FatherEmail,Candidate_Parent_Landline,FatherICNo,     
          
Candidate_idNo,Candidate_FatherName,Candidate_Relationship,Candidate_parentAddress2,C.FatherAddress,c.FatherIcNo,c.Candidate_Parent_Landline,c.Candidate_FatherEmail,c.fatherMobileNo,Candidate_Post,Candidate_Country,Candidate_Sate,          
C.Candidate_City as parentcity,P.Candidate_City, Guardian_Icpassport,Candidate_GuardianName,Candidate_Guardian_Mob,Candidate_Guardian_Telephone,          
Candidate_Guardian_Email,Candidate_Guardian_Address,Candidate_Guardian_Relationship,Candidate_Guardian_Address2,Candidate_Guardian_PostCode,Candidate_Guardian_Country,          
Candidate_Guardian_State,Candidate_Guardian_City,          
c1.Country as Candidate_Country_Name,c2.Country as Candidate_Guardian_Country_Name,c3.Country as Emergency_Country_Name,          
s1.State_Name as Candidate_Sate_Name,s2.State_Name as Candidate_Guardian_State_Name,s3.State_Name as Emergency_State_Name,          
ct1.City_Name as Candidate_City_Name,ct2.City_Name as Candidate_Guardian_City_Name,ct3.City_Name as Emergency_City_Name,          
(case when AirportPickup_Status=''1'' then ''Yes'' when AirportPickup_Status=''0'' then ''No'' else ''-NA-''end) as airportpickup,          
(case when P.Scolorship_Remark='''' then ''-NA-'' when P.Scolorship_Remark is null then ''-NA-'' else P.Scolorship_Remark end ) as Scolorship_Remark          
,P.Agent_Id,recruitedby_other,P.Event_Id,P.active  ,P.PreactivateFlag  ,P.Candidate_Signature_Img ,P.EditDisable,P.VisaAvailable,P.VisaType,P.SocialVisaType,P.VisaExpDate,P.IsCountryRefused,P.IsConvicted,P.IsProhibited,P.IsEnterWithDiffPass,P.KnownBy,P.KnownByAdName,P.KnownByOthersName,P.PrevProgrammeName,P.Medical_Closure,P.PrevInstitution,P.PrevCourseDuration,
'''' as RegType,P.Agent_Id As Agt_Id, ''''as AgentID ,'''' as Agent_Email,'''' as MMUStudName,'''' as MMUStudIC,
'''' as Candidate_Mob2,'''' as FamilyIncome, ISNULL(P.Medical_Closure,'''') Medical_Closure, ISNULL(P.Type_ofcomment,'''') Type_ofcomment
,AP.AirportPickup_Status          
          
FROM dbo.Tbl_Candidate_Personal_Det AS P           
left JOIN dbo.Tbl_Candidate_ContactDetails AS C ON C.Candidate_Id = P.Candidate_Id           
LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails_Mapping AS M ON M.Cand_ContactDet_Id = C.Cand_ContactDet_Id           
LEFT OUTER JOIN dbo.tbl_New_Admission AS A ON P.New_Admission_Id = A.New_Admission_Id          
LEFT OUTER JOIN dbo.Tbl_Department AS D ON A.Department_Id = D.Department_Id   
LEFT OUTER JOIN dbo.Tbl_Department AS D1 ON A.Department_Id = D1.Department_Id   

Left join Tbl_Candidate_AirportPickup AP on P.Candidate_Id=Ap.Candidate_Id          
left join Tbl_Country c1 on C.Candidate_Country=c1.Country_Id          
left join Tbl_Country c2 on C.Candidate_Guardian_Country=c2.Country_Id          
left join Tbl_Country c3 on C.Emergency_Country=c3.Country_Id          
left join [[Tbl_State]]] s1 on C.Candidate_Sate=s1.State_Id          
left join [[Tbl_State]]] s2 on C.Candidate_Guardian_State=s2.State_Id          
left join [[Tbl_State]]] s3 on C.Emergency_State=s3.State_Id          
left join Tbl_City ct1 on C.Candidate_City=ct1.City_Id          
left join Tbl_City ct2 on C.Candidate_Guardian_City=ct2.City_Id          
left join Tbl_City ct3 on C.Emergency_City=ct3.City_Id  
left join Tbl_Student_User TSU on TSU.Candidate_Id=P.Candidate_Id  

left join tbl_course_batch_duration cbd on cbd.batch_id=a.batch_id  
          
WHERE        (TSU.user_id = @User_Id)
end


   ')
END;

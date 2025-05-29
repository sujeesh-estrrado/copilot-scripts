IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Leaddetails_by_ID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create  procedure [dbo].[sp_Get_Leaddetails_by_ID] --2  
--[dbo].[sp_Get_candidatedetails_by_UserID] 10084  
(@User_Id bigint)  
as  
Begin  
SELECT DISTINCT   
P.Candidate_Id, P.Candidate_Fname, P.Candidate_Lname, P.AdharNumber, C.Candidate_Mob1, C.Candidate_Email, P.Candidate_Nationality ,  
P.TypeOfStudent, CONVERT(VARCHAR(10),  P.Candidate_Dob, 21)  AS Candidate_Dob,   
P.Candidate_Nationality AS Expr1, P.Religion,SourceofInformation,p.EnrollBy,ApplicationStage,P.Candidate_Gender, P.Race,  
 P.Candidate_Marital_Status, C.Candidate_Telephone, C.Candidate_PermAddress, C.Candidate_PermAddress_Line2, C.Candidate_PermAddress_postCode, C.Candidate_PermAddress_Country,   
C.Candidate_PermAddress_State, C.Candidate_PermAddress_City, C.Candidate_ContAddress, C.Candidate_ContAddress_Line2, C.Candidate_ContAddress_postCode, C.Candidate_ContAddress_Country,   
C.Candidate_ContAddress_State, C.Candidate_ContAddress_City, P.New_Admission_Id, P.Option2, P.Option3, P.Address_Chkbox_Status, P.Disability_Chkbox_Status, P.Disability_Type, P.BR1M_Status,   
P.CounselorEmployee_id, P.Residing_Country, P.Hostel_Required, P.Room_Type, P.Scolorship_Name, P.Mode_Of_Study, P.ApplicationStatus, P.Candidate_Img, C.Emergency_Check_Status,   
P.Bh1M_Doc_Name, P.Disability_Doc_name, C.Emergency_Parent_IcpassportNo, C.Emergency_Name1, C.Emergency_Relation, C.Emergency_Mob, C.Emergency_Telephone, C.Emergency_Mail, C.Emergency_Address1,   
C.Emergency_Address2, C.Emergency_Postcode, C.Emergency_Country, C.Emergency_State, C.Emergency_City, P.Display_Status, P.Edit_status, P.Edit_request,P.Editable  
,FatherMobileNo,candidate_FatherEmail,Candidate_Parent_Landline,FatherICNo,  
  
Candidate_idNo,Candidate_FatherName,Candidate_Relationship,Candidate_parentAddress2,C.FatherAddress,c.FatherIcNo,c.Candidate_Parent_Landline,c.Candidate_FatherEmail,c.fatherMobileNo,Candidate_Post,Candidate_Country,Candidate_Sate,  
C.Candidate_City as parentcity,Guardian_Icpassport,Candidate_GuardianName,Candidate_Guardian_Mob,Candidate_Guardian_Telephone,  
Candidate_Guardian_Email,Candidate_Guardian_Address,Candidate_Guardian_Relationship,Candidate_Guardian_Address2,Candidate_Guardian_PostCode,Candidate_Guardian_Country,  
Candidate_Guardian_State,Candidate_Guardian_City,  
c1.Country as Candidate_Country_Name,c2.Country as Candidate_Guardian_Country_Name,c3.Country as Emergency_Country_Name,  
s1.State_Name as Candidate_Sate_Name,s2.State_Name as Candidate_Guardian_State_Name,s3.State_Name as Emergency_State_Name,  
ct1.City_Name as Candidate_City_Name,ct2.City_Name as Candidate_Guardian_City_Name,ct3.City_Name as Emergency_City_Name,  
P.Agent_Id,recruitedby_other,P.Event_Id,P.active,P.LeadStatus_Id,A.Department_Id
  
  
  
FROM dbo.Tbl_Lead_Personal_Det AS P   
left JOIN dbo.Tbl_Lead_ContactDetails AS C ON C.Candidate_Id = P.Candidate_Id   
left join Tbl_Country c1 on C.Candidate_Country=c1.Country_Id  
left join Tbl_Country c2 on C.Candidate_Guardian_Country=c2.Country_Id  
left join Tbl_Country c3 on C.Emergency_Country=c3.Country_Id  
left join [[Tbl_State]]] s1 on C.Candidate_Sate=s1.State_Id  
left join [[Tbl_State]]] s2 on C.Candidate_Guardian_State=s2.State_Id  
left join [[Tbl_State]]] s3 on C.Emergency_State=s3.State_Id  
left join Tbl_City ct1 on C.Candidate_City=ct1.City_Id  
left join Tbl_City ct2 on C.Candidate_Guardian_City=ct2.City_Id  
left join Tbl_City ct3 on C.Emergency_City=ct3.City_Id  
left join Tbl_New_Admission A on A.New_Admission_Id=P.New_Admission_Id  
--left join Tbl_Course_Batch_Duration D1 on D1.Duration_Id=A.Department_Id 
  
  
WHERE        (P.Candidate_Id = @User_Id)   
end  
  
  
    ')
END

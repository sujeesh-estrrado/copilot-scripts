IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_candidatedetails_by_NRIC]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_candidatedetails_by_NRIC] 
(@NRIC varchar(50)='''')
as
Begin
SELECT DISTINCT 
                         P.Candidate_Id, P.Candidate_Fname, P.Candidate_Lname, P.AdharNumber, C.Candidate_Mob1, C.Candidate_Email, P.Candidate_Nationality, P.TypeOfStudent, 
                         P.Candidate_Dob, P.Candidate_Nationality AS Expr1, P.Religion, P.Candidate_Gender, P.Race, P.Candidate_Marital_Status, C.Candidate_Telephone, 
                         C.Candidate_PermAddress, C.Candidate_PermAddress_Line2, C.Candidate_PermAddress_postCode, C.Candidate_PermAddress_Country, 
                         C.Candidate_PermAddress_State, C.Candidate_PermAddress_City, C.Candidate_ContAddress, C.Candidate_ContAddress_Line2, 
                         C.Candidate_ContAddress_postCode, C.Candidate_ContAddress_Country, C.Candidate_ContAddress_State, C.Candidate_ContAddress_City, P.New_Admission_Id, 
                         P.Option2, P.Option3, P.Address_Chkbox_Status, P.Disability_Chkbox_Status, P.Disability_Type, P.BR1M_Status, P.CounselorEmployee_id, P.Residing_Country, 
                         P.Scolorship_Remark, P.Hostel_Required, P.Room_Type, P.Scolorship_Name, P.Mode_Of_Study, P.ApplicationStatus, P.Candidate_Img, 
                         C.Emergency_Check_Status, P.Bh1M_Doc_Name, P.Disability_Doc_name, C.Emergency_Parent_IcpassportNo, C.Emergency_Name1, C.Emergency_Relationship, 
                         C.Emergency_Mob, C.Emergency_Telephone, C.Emergency_Mail, C.Emergency_Address1, C.Emergency_Address2, C.Emergency_Postcode, C.Emergency_Country, 
                         C.Emergency_State, C.Emergency_City, D.Department_Name, P.Display_Status, P.Edit_status, P.Edit_request, P.Editable, C.Candidate_GuardianName, 
                         C.FatherMobileNo, C.Candidate_FatherEmail, C.Candidate_idNo, C.Candidate_FatherName, C.Candidate_Relationship, C.Candidate_Guardian_Mob, 
                         C.Candidate_Guardian_Telephone, C.Candidate_Guardian_Email, C.Candidate_Guardian_Address, C.Candidate_parentAddress2, C.Candidate_Post, 
                         C.Candidate_Country, C.Candidate_Sate, C.Candidate_City AS parentcity, P.bankaccountno1 AS BnkAccNo, P.bankid1 as BankID, B.code as BankCode, B.name as BankName
FROM            dbo.Tbl_Candidate_Personal_Det AS P INNER JOIN
                         dbo.Tbl_Candidate_ContactDetails AS C ON C.Candidate_Id = P.Candidate_Id  LEFT OUTER JOIN
                         dbo.ref_bank AS B ON P.bankid1 = B.id LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails_Mapping AS M ON M.Cand_ContactDet_Id = C.Cand_ContactDet_Id LEFT OUTER JOIN
                         dbo.tbl_New_Admission AS A ON P.New_Admission_Id = A.New_Admission_Id LEFT OUTER JOIN
                         dbo.Tbl_Department AS D ON A.Department_Id = D.Department_Id
WHERE        (P.AdharNumber = @NRIC)
end
');
END;
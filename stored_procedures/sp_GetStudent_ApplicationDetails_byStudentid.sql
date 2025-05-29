IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetStudent_ApplicationDetails_byStudentid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_GetStudent_ApplicationDetails_byStudentid] --43460
(@Student_Id bigint)
as
Begin
SELECT DISTINCT 
P.Candidate_Id,P.Candidate_DelStatus,P.New_Admission_Id,P.Option2,P.Option3,P.RegDate,
P.Campus,P.CounselorEmployee_id,CPD.Candidate_Fname,
P.EnrollBy,P.Active_Status,P.IDMatrixNo,P.ApplicationStatus,P.FeeStatus,P.Mode_Of_Study,
P.Edit_status,P.Edit_request,
P.billoutstanding,P.Invoice_Status,P.Payment_Request_Status,P.create_date,P.active,
P.LastUpdate,P.Edit_request_remark,P.Scolorship_Name,P.Scolorship_Remark,P.Editable,
P.documentcomplete,P.ButtonStatus,TypeOfStudent,AdharNumber


FROM Tbl_Candidate_Personal_Det CPD 
left Join dbo.Tbl_Student_NewApplication AS P on CPD.Candidate_Id=P.Candidate_Id
left JOIN dbo.Tbl_Candidate_ContactDetails AS C ON C.Candidate_Id = P.Candidate_Id 
LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails_Mapping AS M ON M.Cand_ContactDet_Id = C.Cand_ContactDet_Id 
LEFT OUTER JOIN dbo.tbl_New_Admission AS A ON P.New_Admission_Id = A.New_Admission_Id
LEFT OUTER JOIN dbo.Tbl_Department AS D ON A.Department_Id = D.Department_Id
 

WHERE (CPD.Candidate_Id = @Student_Id)-- and P.Candidate_DelStatus=0
end
');
END;
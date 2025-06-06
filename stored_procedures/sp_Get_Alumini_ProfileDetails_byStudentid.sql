IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Alumini_ProfileDetails_byStudentid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE  procedure [dbo].[sp_Get_Alumini_ProfileDetails_byStudentid] --151802
(@Student_Id bigint)
as
Begin
    SELECT DISTINCT 
    P.Candidate_Id,P.Candidate_DelStatus,P.New_Admission_Id,P.Option2,P.Option3,
    P.RegDate,--convert(varchar, P.RegDate, 103) as RegDate,
    P.Campus,P.CounselorEmployee_id,concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as Candidatename,
    P.EnrollBy,P.Active_Status,P.IDMatrixNo,P.ApplicationStatus,P.FeeStatus,P.Mode_Of_Study,
    P.Edit_status,P.Edit_request,SS.name as Changedstatus,P.sourceofInformation,
    P.billoutstanding,P.Invoice_Status,P.Payment_Request_Status,P.create_date,P.active,
    P.LastUpdate,P.Edit_request_remark,P.Scolorship_Name,P.Scolorship_Remark,P.Editable,
    CPD.documentcomplete,CPD.TypeOfStudent,CPD.AdharNumber,
    concat(D.Course_Code,''-'',D.Department_Name) as Programme,IM.intake_no,
    concat(E.Employee_fname,'' '',E.Employee_Lname) as Counsellor,
    AG.Agent_name,P.recruitedby_other,CL.Course_Level_Name as Faculty


    FROM dbo.Tbl_Alumini AS P
    left Join Tbl_Candidate_Personal_Det CPD  on CPD.Candidate_Id=P.Candidate_Id
    left JOIN dbo.Tbl_Candidate_ContactDetails AS C ON C.Candidate_Id = P.Candidate_Id 
    LEFT  JOIN dbo.Tbl_Candidate_ContactDetails_Mapping AS M ON M.Cand_ContactDet_Id = C.Cand_ContactDet_Id 
    LEFT  JOIN dbo.tbl_New_Admission AS A ON P.New_Admission_Id = A.New_Admission_Id
    LEFT  JOIN dbo.Tbl_Department AS D ON A.Department_Id = D.Department_Id
    left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=A.Batch_Id
    left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId
    left join Tbl_Student_Status SS on SS.id=P.active
    left join Tbl_Employee E on E.Employee_Id=P.CounselorEmployee_Id
    left join Tbl_Agent AG on AG.Agent_Id=P.Agent_Id
    left join Tbl_Course_Level CL on CL.Course_Level_Id=A.Course_Level_Id
    WHERE (P.Candidate_Id = @Student_Id) 
end
    ');
END

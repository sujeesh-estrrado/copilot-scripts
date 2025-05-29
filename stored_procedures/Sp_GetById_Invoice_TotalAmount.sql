IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetById_Invoice_TotalAmount]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_GetById_Invoice_TotalAmount]  --1,''INV409''
    (@id bigint=0
    ,@DocumentNo varchar(500))
AS
BEGIN
    SELECT DISTINCT 
                         TOP (100) PERCENT CPD.Candidate_Id AS ID,  CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName,
                          CPD.Candidate_Fname, CPD.AdharNumber, 
                      CPD.ApplicationStatus,   CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        cbd.Batch_Code
                               FROM            Tbl_Course_Batch_Duration cbd
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS InTake, 
                         CL.Course_Level_Name AS LevelName, 
                         CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        D .Department_Name
                               FROM            Tbl_Department D
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department, CPD.IDMatrixNo as StudentId
                               ,docno,totalamount,CONVERT(varchar, dateissued, 1) as dateissued,CONVERT(varchar, datedue, 1) as datedue,
                                CASE WHEN bg.createdby = 1 THEN ''Admin'' ELSE(
                               E.Employee_FName + '' '' + E.Employee_LName )end  AS createdby
                               ,O.Organization_Name,O.Organization_Address,O.Organization_City,O.Organization_Pin,
                               O.Organization_Phone,O.Organization_Fax,O.Organization_GST_No
FROM            dbo.Tbl_Course_Level AS CL INNER JOIN
                         dbo.Tbl_Department AS D ON CL.Course_Level_Id = D.GraduationTypeId RIGHT OUTER JOIN
                         dbo.Tbl_Candidate_Personal_Det AS CPD LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id ON D.Department_Id = NA.Department_Id LEFT OUTER JOIN
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN
                         --dbo.Tbl_Employee AS E ON E.Employee_Id =
                         --    (SELECT        Employee_Id
                         --      FROM            dbo.Tbl_Employee_User
                         --      WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id

                         left join student_bill_group bg on bg.studentid= CPD.Candidate_Id
                         left join Tbl_Employee_User EU on EU.[User_Id]=bg.createdby
                         left join [dbo].[Tbl_Employee] E on E.Employee_Id=EU.Employee_Id
                         left join [dbo].[Tbl_Organzations ] O on O.Organization_Id=CPD.Campus

                         where cpd.Candidate_Id=@id
                          and docno =@DocumentNo

END');
END;

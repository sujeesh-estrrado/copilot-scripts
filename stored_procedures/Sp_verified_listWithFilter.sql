IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_verified_listWithFilter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_verified_listWithFilter](@status varchar(100),@active varchar(100))
as
begin
SELECT DISTINCT 
                         CPD.Candidate_Id AS ID, SG.BloodGroup, CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName, 
                         CPD.Candidate_Fname, CPD.AdharNumber, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, 
                         CC.Candidate_idNo AS IdentificationNumber, CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email AS EmailID, 
                         CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id, CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        cbd.Batch_Code
                               FROM            Tbl_Course_Batch_Duration cbd
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END) 
                         AS UserName, NA.Course_Level_Id AS LevelID, CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID, 
                         CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID, CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        D .Department_Name
                               FROM            Tbl_Department D
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department, CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        D .Course_Code
                               FROM            Tbl_Department D
                               WHERE        D .Department_Id = NA.Department_Id) END AS course_code, cbd.Batch_From
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND 
                         SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT OUTER JOIN
                         dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT OUTER JOIN
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Employee AS E ON E.Employee_Id =
                             (SELECT        Employee_Id
                               FROM            dbo.Tbl_Employee_User
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id       
           
                                        
                                          
where CPD.Candidate_DelStatus=0 and CPD.ApplicationStatus=@status and CPD.Active_Status=@active order by ID desc  
end
    ')
END

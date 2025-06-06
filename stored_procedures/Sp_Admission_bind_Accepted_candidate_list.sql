IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Admission_bind_Accepted_candidate_list]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Admission_bind_Accepted_candidate_list] --''Rejected''
--[dbo].[Sp_Marketing_bind_Accepted_candidate_list] ''rejected''
(@application_status varchar(500))
as
begin
if(@application_status=''Rejected'')
begin

SELECT DISTINCT 
                       (  CPD.Candidate_Id) AS ID, SG.BloodGroup, CPD.IDMatrixNo, CPD.Candidate_Gender, CPD.IdentificationNo,concat( CPD.Candidate_Fname,'' '' ,CPD.Candidate_Lname )AS CandidateName, 
                         CPD.Candidate_Fname, CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CC.Candidate_idNo AS IdentificationNumber, 
                         CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email, CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id,
                         (case when DR.Delete_status=0 then ''Pending'' when DR.Delete_status=1 then ''Rejected'' else''Pending'' end) as RejectStatus,
                         CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        cbd.Batch_Code
                               FROM            Tbl_Course_Batch_Duration cbd
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END) AS UserName, NA.Course_Level_Id AS LevelID, 
                         CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID, CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID, 
                         CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        D .Department_Name
                               FROM            Tbl_Department D
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department_Name, dbo.tbl_approval_log.Offerletter_status as offerletter
                               
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD LEFT JOIN
                         dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id LEFT JOIN
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT JOIN
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT JOIN
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT JOIN
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT JOIN
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT JOIN
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT JOIN
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT JOIN
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT JOIN
                         dbo.Tbl_Delete_Request as DR on CPD.Candidate_Id=DR.Candidate_id left join
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT JOIN
                         dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT JOIN
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT JOIN
                         dbo.Tbl_Employee AS E ON E.Employee_Id =
                             (SELECT        Employee_Id
                               FROM            dbo.Tbl_Employee_User
                               WHERE        (User_Id = SR.UserId)) LEFT JOIN
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id
                                        
                           
where  ( CPD.ApplicationStatus=''Rejected'')  order by ID desc              
                        end

                        
                        else
                        begin

                        SELECT DISTINCT 
 CPD.Candidate_Id AS ID, CPD.IDMatrixNo, CPD.Candidate_Gender, CPD.IdentificationNo, CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName, 
                         CPD.Candidate_Fname, CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CC.Candidate_idNo AS IdentificationNumber, 
                         (case when DR.Delete_status=0 then ''Pending'' when DR.Delete_status=1 then ''Rejected'' else''Pending'' end) as RejectStatus,
                         CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email, CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id,
                         CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        cbd.Batch_Code
                               FROM            Tbl_Course_Batch_Duration cbd
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END) AS UserName, NA.Course_Level_Id AS LevelID, 
                         CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID, CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID, 
                         CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        D .Department_Name
                               FROM            Tbl_Department D
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department_Name, dbo.tbl_approval_log.Offerletter_status as offerletter
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD LEFT JOIN
                         dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id LEFT JOIN
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT JOIN
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT JOIN
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT JOIN
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT JOIN
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT JOIN
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT JOIN
                          dbo.Tbl_Delete_Request as DR on CPD.Candidate_Id=DR.Candidate_id left join
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT JOIN
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT JOIN
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT JOIN
                         dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT JOIN
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT JOIN
                         dbo.Tbl_Employee AS E ON E.Employee_Id =
                             (SELECT        Employee_Id
                               FROM            dbo.Tbl_Employee_User
                               WHERE        (User_Id = SR.UserId)) 
           
                                        
                                                
where  (CPD.ApplicationStatus=@application_status or @application_status is null) and CPD.ApplicationStatus is not null order by ID desc    
                        end
end
    ')
END

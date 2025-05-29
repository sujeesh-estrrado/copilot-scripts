IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Candidate_Renewal_Visa]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_Candidate_Renewal_Visa]
            @CurrentPage INT = NULL,
            @pagesize BIGINT = NULL,
            @organization_id BIGINT = 0,
            @intake_id BIGINT = 0,
            @Department_id BIGINT = 0,
            @Flag BIGINT = 0,
            @SearchTerm VARCHAR(500) = '''',
            @fromdate VARCHAR(50) = '''',
            @todate VARCHAR(50) = '''',
            @facultyid BIGINT = 0,
            @passportcollect VARCHAR(50) = ''''
        AS
        BEGIN
            IF (@Flag = 0)
            BEGIN
                SELECT DISTINCT 
                    CPD.Candidate_Id AS ID,
                    SG.BloodGroup,
                    CPD.IDMatrixNo,
                    CPD.Candidate_Gender,
                    CPD.IdentificationNo,
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,
                    CPD.Candidate_Fname,
                    CPD.AdharNumber,
                    CPD.TypeOfStudent,
                    CPD.Status,
                    CPD.Candidate_Dob AS DOB,
                    CPD.New_Admission_Id AS AdmnID,
                    CPD.ApplicationStatus,
                    CC.Candidate_idNo AS IdentificationNumber,
                    CC.Candidate_ContAddress AS Address,
                    CC.Candidate_Mob1 AS MobileNumber,
                    CC.Candidate_Email,
                    CCat.Course_Category_Id,
                    cbd.Batch_Id AS BatchID,
                    cbd.Batch_Code AS Batch,
                    NA.Batch_Id,
                    CPD.Visato,
                    CPD.Visafrom,
                    CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' 
                         ELSE (SELECT cbd.Batch_Code
                               FROM Tbl_Course_Batch_Duration cbd
                               WHERE cbd.Batch_Id = NA.Batch_Id) 
                    END AS Batch_Code,
                    CASE WHEN SR.UserId IS NULL THEN '''' 
                         ELSE ISNULL(E.Employee_FName, ''Admin'') 
                    END AS UserName,
                    NA.Course_Level_Id AS LevelID,
                    CL.Course_Level_Name AS LevelName,
                    NA.Course_Category_Id AS CategoryID,
                    CCat.Course_Category_Name AS Category,
                    NA.Department_Id AS DepartmentID,
                    CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
                         ELSE (SELECT D.Department_Name
                               FROM Tbl_Department D
                               WHERE D.Department_Id = NA.Department_Id) 
                    END AS Department_Name,
                    dbo.tbl_approval_log.Offerletter_status AS offerletter,
                    CASE WHEN dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL 
                         THEN CONVERT(VARCHAR(8), dbo.tbl_approval_log.offer_letter_accept_date, 3) 
                         ELSE ''-NA-'' 
                    END AS offerletter_acceptdate,
                    CASE WHEN cn.PassportNo <> '''' THEN ''Yes'' ELSE ''No'' END AS passportsts,
                    tn.nationality,
                    CASE WHEN vs.Visa_RejectStatus = 1 THEN ''Rejected''
                         WHEN vs.Visa_RejectStatus = 0 THEN ''Approve''
                         ELSE ''Pending'' 
                    END AS Visastatus,
                    vs.visa_remark,
                    CONVERT(VARCHAR, CPD.VisaTo, 103) AS VisaExpiry,
                    vs.travel_doc_type AS doctype
                FROM dbo.Tbl_Candidate_Personal_Det AS CPD
                INNER JOIN tbl_visa_details vs ON vs.Candidate_id = CPD.Candidate_id
                LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id
                LEFT JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id
                LEFT JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
                                                         AND SS.Student_Semester_Delete_Status = 0 
                                                         AND SS.Student_Semester_Current_Status = 1
                LEFT JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id
                LEFT JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id
                LEFT JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id
                LEFT JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id
                LEFT JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id
                LEFT JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id
                LEFT JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id
                LEFT JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id
                LEFT JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id
                LEFT JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = 
                                                  (SELECT Employee_Id
                                                   FROM dbo.Tbl_Employee_User
                                                   WHERE User_Id = SR.UserId)
                LEFT JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id
                LEFT JOIN Tbl_Candidate_NopassportList cn ON cn.candidate_id = CPD.candidate_id
                LEFT JOIN tbl_nationality tn ON CPD.candidate_nationality = tn.nationality_id
                WHERE CPD.Candidate_DelStatus = 0 
                  AND dbo.tbl_approval_log.delete_status = 0 
                  AND dbo.tbl_approval_log.Offerletter_status = 1 
                  AND (CPD.Campus = @organization_id OR @organization_id = ''0'')
                  AND (NA.Department_Id = @Department_id OR @Department_id = ''0'')
                  AND (D.graduationtypeid = @facultyid OR @facultyid = ''0'')
                  AND (NA.Batch_Id = @intake_id OR @intake_id = ''0'')
                  AND ((CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'') 
                       OR (CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%'')
                       OR (CPD.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%'')  
                       OR @SearchTerm = '''' 
                       OR (CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%'')) 
                  AND (CPD.ApplicationStatus IN (''verified'', ''Verified'', ''Conditional_Admission'', ''Preactivated'', ''Completed'')) 
                  AND CPD.TypeOfStudent = ''INTERNATIONAL''
                  AND vs.delete_status = 0
                  AND (CPD.visafrom >= CONVERT(DATETIME, @fromdate, 103) OR @fromdate = '''')
                  AND (CPD.visato <= CONVERT(DATETIME, @todate, 103) OR @todate = '''')
                  AND (vs.passportcollectsts = @passportcollect OR @passportcollect = '''')
                ORDER BY CPD.Visato ASC
                OFFSET @pagesize * (@CurrentPage - 1) ROWS
                FETCH NEXT @pagesize ROWS ONLY
            END

            IF (@Flag = 1)
            BEGIN
                SELECT COUNT(*) AS counts
                FROM (
                    SELECT DISTINCT CPD.Candidate_Id
                    FROM dbo.Tbl_Candidate_Personal_Det AS CPD
                    INNER JOIN tbl_visa_details vs ON vs.Candidate_id = CPD.Candidate_id
                    LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id
                    LEFT JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id
                    LEFT JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id 
                                                             AND SS.Student_Semester_Delete_Status = 0 
                                                             AND SS.Student_Semester_Current_Status = 1
                    LEFT JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id
                    LEFT JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id
                    LEFT JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id
                    LEFT JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id
                    LEFT JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id
                    LEFT JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id
                    LEFT JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id
                    LEFT JOIN dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id
                    LEFT JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id
                    LEFT JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = 
                                                      (SELECT Employee_Id
                                                       FROM dbo.Tbl_Employee_User
                                                       WHERE User_Id = SR.UserId)
                    LEFT JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id
                    LEFT JOIN Tbl_Candidate_NopassportList cn ON cn.candidate_id = CPD.candidate_id
                    WHERE CPD.Candidate_DelStatus = 0 
                      AND dbo.tbl_approval_log.delete_status = 0 
                      AND dbo.tbl_approval_log.Offerletter_status = 1 
                      AND (CPD.Campus = @organization_id OR @organization_id = ''0'')
                      AND (NA.Department_Id = @Department_id OR @Department_id = ''0'')
                      AND (D.graduationtypeid = @facultyid OR @facultyid = ''0'')
                      AND (NA.Batch_Id = @intake_id OR @intake_id = ''0'')
                      AND ((CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'') 
                           OR (CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%'')
                           OR (CPD.IDMatrixNo LIKE ''%'' + @SearchTerm + ''%'')  
                           OR @SearchTerm = ''''
                           OR (CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%'')) 
                      AND (CPD.ApplicationStatus IN (''verified'', ''Verified'', ''Conditional_Admission'', ''Preactivated'', ''Completed'')) 
                      AND CPD.TypeOfStudent = ''INTERNATIONAL''
                      AND vs.delete_status = 0
                      AND (CPD.visafrom >= CONVERT(DATETIME, @fromdate, 103) OR @fromdate = '''')
                      AND (CPD.visato <= CONVERT(DATETIME, @todate, 103) OR @todate = '''')
                      AND (vs.passportcollectsts = @passportcollect OR @passportcollect = '''')
                ) AS t
            END
        END
    ')
END

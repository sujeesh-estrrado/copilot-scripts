IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Bind_Student_NewProfile]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Bind_Student_NewProfile]
        (
            @id BIGINT
        )
        AS
        BEGIN
            SELECT DISTINCT TOP (100) PERCENT 
                CPD.Candidate_Id AS ID,
                CONCAT(PD.Candidate_Fname, '' '', PD.Candidate_Lname) AS CandidateName,
                n.nationality,
                CPD.CounselorEmployee_id,
                CPD.New_Admission_Id AS AdmnID,
                CPD.ApplicationStatus,
                PD.AdharNumber AS icno,
                PD.TypeOfStudent,
                CC.Candidate_idNo AS IdentificationNumber,
                CC.Candidate_ContAddress AS Address,
                CC.Candidate_Mob1 AS MobileNumber,
                CC.Candidate_Email AS EmailID,
                CCat.Course_Category_Id,
                cbd.Batch_Id AS BatchID,
                cbd.Batch_Code AS Batch,
                NA.Batch_Id,
                CASE 
                    WHEN NA.Batch_Id = 0 THEN ''Unspecified'' 
                    ELSE (SELECT cbd.Batch_Code FROM Tbl_Course_Batch_Duration cbd WHERE cbd.Batch_Id = NA.Batch_Id) 
                END AS Batch_Code,
                (SELECT cbd.dateregsatart FROM Tbl_Course_Batch_Duration cbd WHERE cbd.Batch_Id = NA.Batch_Id) AS Registration_Date,
                (CASE WHEN SR.UserId IS NULL THEN '''' ELSE ISNULL(E.Employee_FName, ''Admin'') END) AS UserName,
                NA.Course_Level_Id AS LevelID,
                CL.Course_Level_Name AS LevelName,
                NA.Course_Category_Id AS CategoryID,
                CCat.Course_Category_Name AS Category,
                NA.Department_Id AS DepartmentID,
                CASE 
                    WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
                    ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id) 
                END AS Department,
                SS.SEMESTER_NO,
                (SELECT cbd.Batch_From FROM Tbl_Course_Batch_Duration cbd WHERE cbd.Batch_Id = NA.Batch_Id) AS Intake_StartDate
            FROM dbo.Tbl_Course_Level AS CL
            INNER JOIN dbo.Tbl_Department AS D ON CL.Course_Level_Id = D.GraduationTypeId
            RIGHT OUTER JOIN dbo.Tbl_Student_NewApplication AS CPD 
                INNER JOIN Tbl_candidate_Personal_Det PD ON PD.Candidate_Id = CPD.Candidate_Id
            LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id
            LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Current_Status = 1
            LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id
            LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id
            ON D.Department_Id = NA.Department_Id
            LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id
            LEFT OUTER JOIN dbo.Tbl_Employee AS E ON E.Employee_Id = (
                SELECT Employee_Id
                FROM dbo.Tbl_Employee_User
                WHERE User_Id = SR.UserId
            )
            LEFT OUTER JOIN dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id
            LEFT JOIN Tbl_Nationality n ON n.Nationality_Id = PD.Candidate_Nationality
            WHERE CPD.Candidate_Id = @id
            ORDER BY ID DESC
        END
    ')
END

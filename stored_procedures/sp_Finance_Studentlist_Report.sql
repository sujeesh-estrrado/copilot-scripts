IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_Studentlist_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_Studentlist_Report]
        -- 0,'' ,1,'''',0,0,'' ,'''',1,10      
        (
        @flag BIGINT = 0,
        @Intake VARCHAR(MAX) = '''',
        @studentstatus VARCHAR(MAX) = '''',
        @academicstatus VARCHAR(MAX) = '''',
        @studenttype VARCHAR(MAX) = '''',
        @Organization BIGINT = 0,
        @Faculty BIGINT = 0,
        @Program VARCHAR(MAX) = '''',
        @semester VARCHAR(MAX) = '''',
        @Offerletter_status VARCHAR(MAX) = '''',
        @SourceofInformation VARCHAR(MAX) = '''',
        @Sponsor BIGINT = 0,
        @Gender VARCHAR(MAX) = '''',
        @CurrentPage INT = 1,
        @PageSize INT = 10
        )
        AS
        BEGIN
        -- ============================
        -- Main Data Retrieval
        -- ============================
        IF (@flag = 0)
        BEGIN
            SELECT DISTINCT
                CPD.Candidate_Id,
                CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS studentname,
                IDMatrixNo, AdharNumber, Candidate_Gender, Race, CC.Candidate_Email,
                CC.Candidate_Mob1, CC.Candidate_Telephone,
                CONCAT(CC.Candidate_PermAddress, '', '', CC.Candidate_PermAddress_Line2, '', '', CS.Country, '', '',
                       CCS.State_Name, '', '', CCC.City_Name, '' '', CC.Candidate_PermAddress_postCode) AS Permenent_Address,
                CONCAT(CC.Candidate_ContAddress, '', '', CC.Candidate_ContAddress_Line2, '', '', CS.Country, '', '',
                       CCS.State_Name, '', '', CCC.City_Name, '' '', CC.Candidate_ContAddress_postCode) AS Mailing_Address,
                ISNULL(CCS.State_Name, barracuda_state) AS Statename,
                ISNULL(CCS.State_Name, barracuda_state) AS Residantial,
                NY.Nationality,
                CASE WHEN CPD.Candidate_Nationality = ''63'' THEN ''Yes'' ELSE ''No'' END AS citizenship,
                CSEM.Semester_Name, SS.SEMESTER_NO,
                IM.batch_code AS Intake, NA.Batch_Id,
                CONVERT(VARCHAR(10), CPD.RegDate, 105) AS RegDate,
                CONVERT(VARCHAR(10), BD.Close_Date, 105) AS Close_Date,
                CONCAT(DE.Course_Code, ''-'', DE.Department_Name) AS ProgrammeName,
                DE.Course_Code AS ProgrammeCode,
                ISNULL(SourceofInformation, ''N/A'') AS SourceofInformation,
                refs.sponsorname,
                CASE WHEN documentcomplete = ''1'' THEN ''Yes'' ELSE ''No'' END AS CompleteDocuments,
                ''0.00'' AS totalGP, ''0'' AS totalCH, ''0.00'' AS GPA, ''0.00'' AS CGPA,
                '''' AS AcademicStatus,
                CONCAT(Employee_Fname, '' '', Employee_Lname) AS Counsellor,
                Agt.Agent_Name,
                CONVERT(VARCHAR(10), GETDATE(), 105) AS datetimeissued,
                recruitedby_other,
                active AS studentstatus,
                TypeOfStudent,
                CPD.Campus AS organization,
                NA.Course_Level_Id AS facultyId,
                NA.Department_Id,
                ApplicationStatus,
                Offerletter_status,
                Offerletter_Path
            FROM Tbl_Candidate_Personal_Det CPD
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
            LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
            LEFT JOIN tbl_Department DE ON DE.Department_Id = NA.Department_Id
            LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
            LEFT JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
            LEFT JOIN Tbl_Offerlettre OL ON OL.candidate_id = CPD.Candidate_Id
            LEFT JOIN tbl_approval_log AL ON AL.candidate_id = CPD.Candidate_Id AND AL.delete_status = 0
            LEFT JOIN student_sponsor SPO ON SPO.studentid = CPD.Candidate_Id
            LEFT JOIN Tbl_Nationality NY ON CPD.Candidate_Nationality = CAST(NY.Nationality_Id AS VARCHAR(50))
            LEFT JOIN Tbl_Course_Semester CSEM ON CSEM.Semester_Id = SS.SEMESTER_NO
            LEFT JOIN ref_sponsor refs ON refs.sponsorid = SPO.sponsorid
            LEFT JOIN dbo.Tbl_Country CS ON CC.Candidate_ContAddress_Country = CS.Country_Id
            LEFT JOIN dbo.Tbl_State CCS ON CCS.State_Id = CC.Candidate_ContAddress_State
            LEFT JOIN dbo.Tbl_City CCC ON CCC.City_Id = CC.Candidate_ContAddress_City
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = CPD.CounselorEmployee_id
            LEFT JOIN Tbl_Agent AS Agt ON agt.Agent_ID = CPD.Agent_ID
            WHERE
                (IM.id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@Intake, '','')) OR @Intake = '''')
                AND (NA.Department_Id IN (SELECT CAST(Item AS BIGINT) FROM dbo.SplitString(@Program, '','')) OR @Program = '''')
                AND (active IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@studentstatus, '','')) OR @studentstatus = '''')
                AND (@studenttype = '''' OR TypeOfStudent = @studenttype)
                AND (@Organization = 0 OR CPD.Campus = @Organization)
                AND (Course_Level_Id = @Faculty OR @Faculty = 0)
                AND (@Offerletter_status = '''' OR @Offerletter_status IS NULL OR Offerletter_status = @Offerletter_status)
                AND (SS.SEMESTER_NO IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@semester, '','')) OR @semester = '''')
                AND (@SourceofInformation = '''' OR @SourceofInformation = ''0'' OR SourceofInformation = @SourceofInformation)
                AND (SPO.sponsorid = @Sponsor OR @Sponsor = 0)
                AND (@Gender = '''' OR @Gender = ''0'' OR Candidate_Gender = @Gender)
            ORDER BY NA.Department_Id ASC, CONCAT(Candidate_Fname, '' '', Candidate_Lname) ASC
            OFFSET @PageSize * (@CurrentPage - 1) ROWS
            FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
        END
        
        -- ============================
        -- Count for Pagination
        -- ============================
        IF (@flag = 1)
        BEGIN
            SELECT COUNT(*) AS totcounts
            FROM (
                SELECT DISTINCT CPD.Candidate_Id
                FROM Tbl_Candidate_Personal_Det CPD
                LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
                LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
                LEFT JOIN tbl_Department DE ON DE.Department_Id = NA.Department_Id
                LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
                LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
                LEFT JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
                LEFT JOIN Tbl_Offerlettre OL ON OL.candidate_id = CPD.Candidate_Id
                LEFT JOIN tbl_approval_log AL ON AL.candidate_id = CPD.Candidate_Id AND AL.delete_status = 0
                LEFT JOIN student_sponsor SPO ON SPO.studentid = CPD.Candidate_Id
                LEFT JOIN Tbl_Nationality NY ON CPD.Candidate_Nationality = CAST(NY.Nationality_Id AS VARCHAR(50))
                LEFT JOIN Tbl_Course_Semester CSEM ON CSEM.Semester_Id = SS.SEMESTER_NO
                LEFT JOIN ref_sponsor refs ON refs.sponsorid = SPO.sponsorid
                LEFT JOIN dbo.Tbl_Country CS ON CC.Candidate_ContAddress_Country = CS.Country_Id
                LEFT JOIN dbo.Tbl_State CCS ON CCS.State_Id = CC.Candidate_ContAddress_State
                LEFT JOIN dbo.Tbl_City CCC ON CCC.City_Id = CC.Candidate_ContAddress_City
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = CPD.CounselorEmployee_id
                LEFT JOIN Tbl_Agent AS Agt ON agt.Agent_ID = CPD.Agent_ID
                WHERE
                    (IM.id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@Intake, '','')) OR @Intake = '''')
                    AND (NA.Department_Id IN (SELECT CAST(Item AS BIGINT) FROM dbo.SplitString(@Program, '','')) OR @Program = '''')
                    AND (active IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@studentstatus, '','')) OR @studentstatus = '''')
                    AND (@studenttype = '''' OR TypeOfStudent = @studenttype)
                    AND (@Organization = 0 OR CPD.Campus = @Organization)
                    AND (Course_Level_Id = @Faculty OR @Faculty = 0)
                    AND (@Offerletter_status = '''' OR @Offerletter_status IS NULL OR Offerletter_status = @Offerletter_status)
                    AND (SS.SEMESTER_NO IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@semester, '','')) OR @semester = '''')
                    AND (@SourceofInformation = '''' OR @SourceofInformation = ''0'' OR SourceofInformation = @SourceofInformation)
                    AND (SPO.sponsorid = @Sponsor OR @Sponsor = 0)
                    AND (@Gender = '''' OR @Gender = ''0'' OR Candidate_Gender = @Gender)
            ) base;
        END
        END
    ')
END

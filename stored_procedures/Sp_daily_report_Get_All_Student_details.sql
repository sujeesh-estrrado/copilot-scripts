IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_daily_report_Get_All_Student_details]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_daily_report_Get_All_Student_details]
        @intake_id BIGINT
        AS
        BEGIN
            SELECT DISTINCT 
                P.Candidate_Id, CONCAT( P.Candidate_Fname, '' '', P.Candidate_Lname) AS candidate_name, 
                P.Candidate_Gender, P.AdharNumber, C.Candidate_Mob1, C.Candidate_Email, P.Candidate_Nationality, 
                C.Candidate_Country, P.TypeOfStudent, P.Religion, SourceofInformation, p.EnrollBy, 
                ApplicationStage, P.Candidate_Gender, P.Race, p.ApplicationStatus, 
                C.Candidate_Telephone, C.Candidate_PermAddress, C.Candidate_PermAddress_Line2, 
                C.Candidate_PermAddress_postCode, C.Candidate_PermAddress_Country, 
                C.Candidate_PermAddress_State, C.Candidate_PermAddress_City, P.New_Admission_Id, 
                P.Disability_Chkbox_Status, P.Disability_Type, P.CounselorEmployee_id, P.Residing_Country, 
                P.Scolorship_Remark, P.Room_Type, P.Scolorship_Name, P.Mode_Of_Study,   
                P.Bh1M_Doc_Name, P.Disability_Doc_name, P.Display_Status, AirportPickup_Status, 
                A.Course_Level_Id, CL.Course_Level_Name, CONCAT(FromDate, ''  to  '', ToDate) AS duration,
                CONCAT(C.Emergency_Mob, '' '', C.Emergency_Telephone) AS Emergency_contacts, bd.Batch_Code,
                (CASE WHEN P.Hostel_Required = 0 THEN ''NO'' WHEN P.Hostel_Required = 1 THEN ''YES'' ELSE ''-NA-'' END) AS Hostel, 
                (CASE WHEN EN.English_Test != ''NULL'' THEN EN.English_Test ELSE ''-NA-'' END) AS English_Test,
                MONTH(BD.Batch_From) AS IntakeMonth, YEAR(BD.Batch_From) AS IntakeYear,
                (CASE WHEN OGN.Organization_Name != ''NULL'' THEN OGN.Organization_Name ELSE ''-NA-'' END) AS Organization_name,
                p.RegDate, p.AgentName, 
                (CASE WHEN P.BR1M_Status = 0 THEN ''NO'' WHEN P.BR1M_Status = 1 THEN ''YES'' ELSE ''-NA-'' END) AS BR1Mstatus,
                (CASE WHEN D.Department_Name != ''NULL'' THEN D.Department_Name ELSE ''-NA-'' END) AS Department,
                (CASE WHEN AGENT.Agent_Name != ''NULL'' THEN AGENT.Agent_Name ELSE ''-NA-'' END) AS AgentName,
                CONVERT(VARCHAR(10), CAST(o.Sentdate AS DATETIME), 103) AS offerIssuedDate,
                CONCAT(e.Employee_FName, '' '', e.Employee_LName) AS offerIssuedBy, 
                P.ApplicationStatus,
                (CASE WHEN p.Scolorship_Name = ''NULL'' THEN ''-NA-'' WHEN p.Scolorship_Name = '''' THEN ''-NA-'' ELSE p.Scolorship_Name END) AS ScolorshipName,
                bd.Batch_Id,
                (CASE WHEN (SELECT COUNT(*) FROM Tbl_Interview_log IV WHERE IV.Candidate_id = p.Candidate_Id) > 0 THEN ''YES'' ELSE ''NO'' END) AS interview,
                MN.Batch_From AS Intakeduration
            FROM dbo.Tbl_Candidate_Personal_Det AS P 
                INNER JOIN dbo.Tbl_Candidate_ContactDetails AS C ON C.Candidate_Id = P.Candidate_Id 
                LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails_Mapping AS M ON M.Cand_ContactDet_Id = C.Cand_ContactDet_Id 
                LEFT OUTER JOIN dbo.tbl_New_Admission AS A ON P.New_Admission_Id = A.New_Admission_Id
                LEFT OUTER JOIN dbo.Tbl_Department AS D ON A.Department_Id = D.Department_Id
                LEFT JOIN Tbl_Candidate_AirportPickup AP ON P.Candidate_Id = AP.Candidate_Id
                LEFT JOIN Tbl_Country c1 ON C.Candidate_Country = c1.Country_Id
                LEFT JOIN Tbl_Country c2 ON C.Candidate_Guardian_Country = c2.Country_Id
                LEFT JOIN Tbl_Country c3 ON C.Emergency_Country = c3.Country_Id
                LEFT JOIN Tbl_State s1 ON C.Candidate_Sate = s1.State_Id
                LEFT JOIN Tbl_State s2 ON C.Candidate_Guardian_State = s2.State_Id
                LEFT JOIN Tbl_State s3 ON C.Emergency_State = s3.State_Id
                LEFT JOIN Tbl_City ct1 ON C.Candidate_City = ct1.City_Id
                LEFT JOIN Tbl_City ct2 ON C.Candidate_Guardian_City = ct2.City_Id
                LEFT JOIN Tbl_City ct3 ON C.Emergency_City = ct3.City_Id
                LEFT JOIN Tbl_Course_Level CL ON A.Course_Level_Id = CL.Course_Level_Id 
                LEFT JOIN Tbl_Candidate_Englishtest ET ON C.Candidate_Id = ET.Cand_Id
                LEFT JOIN Tbl_EnglishTestMaster EN ON ET.English_Text_Id = EN.English_Text_Id
                LEFT JOIN Tbl_Course_Batch_Duration BD ON A.Batch_Id = BD.Batch_Id
                LEFT JOIN Tbl_Organzations OGN ON p.Campus = OGN.Organization_Id
                LEFT JOIN Tbl_Agent AGENT ON p.Agent_ID = AGENT.Agent_ID
                LEFT JOIN Tbl_Offerlettre o ON o.candidate_id = p.Candidate_Id
                LEFT JOIN Tbl_Employee e ON e.Employee_Id = o.Sented_by
                LEFT JOIN Tbl_Course_Batch_Duration MN ON MN.Batch_Id = BD.Batch_Id
            WHERE bd.Batch_Id = @intake_id
        END
    ')
END

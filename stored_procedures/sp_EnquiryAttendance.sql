IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_EnquiryAttendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_EnquiryAttendance] 
            @flag BIGINT = 0,
            @candidateID BIGINT = 0,
            @CouncellorID BIGINT = 0,
            @Fromdate DATETIME = NULL,
            @Todate DATETIME = NULL
        AS
        BEGIN
            IF (@flag = 1) -- Update Attended Date
            BEGIN
                INSERT INTO Tbl_EnquiryAttendence
                VALUES (@candidateID, @CouncellorID, GETDATE(), 0)

                UPDATE Tbl_Candidate_Personal_Det 
                SET LastUpdate = GETDATE() 
                WHERE candidate_Id = @candidateID 
                AND CounselorEmployee_id = @CouncellorID
            END

            IF (@flag = 2) -- Get Total Attended Enquiries By Councellor ID
            BEGIN
                SELECT COUNT(DISTINCT CandidateID) AS counts 
                FROM Tbl_EnquiryAttendence 
                WHERE CouncellorID = @CouncellorID 
                    AND (
                        ((CONVERT(DATE, AttendedDateTime)) >= @Fromdate 
                            AND (CONVERT(DATE, AttendedDateTime)) < DATEADD(DAY, 1, @Todate)) 
                        OR (@Fromdate IS NULL AND @Todate IS NULL)
                        OR (@Fromdate IS NULL AND (CONVERT(DATE, AttendedDateTime)) < DATEADD(DAY, 1, @Todate))
                        OR (@Todate IS NULL AND (CONVERT(DATE, AttendedDateTime)) >= @Fromdate)
                    )
            END

            IF (@flag = 3) -- Get Total Attended Enquiries By CouncellorLead ID
            BEGIN
                SELECT COUNT(DISTINCT CandidateID) 
                FROM Tbl_EnquiryAttendence
            END

            IF (@flag = 4) -- Get Total Not Attended Enquiries By Councellor ID
            BEGIN
                SELECT 
                    (SELECT COUNT(Candidate_Id) FROM Tbl_Candidate_Personal_Det 
                     WHERE CounselorEmployee_id = @CouncellorID) 
                    - (SELECT COUNT(*) FROM Tbl_EnquiryAttendence 
                       WHERE CouncellorID = @CouncellorID)
            END

            IF (@flag = 5) -- Get All Counsellors
            BEGIN
                SELECT EMP.Employee_Id, EMP.Employee_FName AS Counsellor
                FROM dbo.Tbl_RoleAssignment AS RA 
                INNER JOIN dbo.tbl_Role AS R ON RA.role_id = R.role_Id 
                INNER JOIN dbo.Tbl_Employee AS EMP ON RA.employee_id = EMP.Employee_Id
                WHERE (RA.role_id = 7 OR RA.role_id = 14)
            END

            IF (@flag = 6) -- Get Total Count of Enquiries by CouncellorID
            BEGIN
                SELECT COUNT(Candidate_Id) 
                FROM Tbl_Candidate_Personal_Det 
                WHERE CounselorEmployee_id = @CouncellorID  
                    AND (
                        ((CONVERT(DATE, RegDate)) >= @Fromdate 
                            AND (CONVERT(DATE, RegDate)) < DATEADD(DAY, 1, @Todate)) 
                        OR (@Fromdate IS NULL AND @Todate IS NULL)
                        OR (@Fromdate IS NULL AND (CONVERT(DATE, RegDate)) < DATEADD(DAY, 1, @Todate))
                        OR (@Todate IS NULL AND (CONVERT(DATE, RegDate)) >= @Fromdate)
                    )
            END

            IF (@flag = 7) -- Get Total Count of Enquiries by Program
            BEGIN
                SELECT Dept.Department_Name AS Programme, COUNT(CPD.Candidate_Id) AS Enquiries
                FROM dbo.Tbl_Candidate_Personal_Det AS CPD 
                INNER JOIN dbo.tbl_New_Admission AS NA ON CPD.New_Admission_Id = NA.New_Admission_Id 
                INNER JOIN dbo.Tbl_Department AS Dept ON NA.Department_Id = Dept.Department_Id
                WHERE CounselorEmployee_id = @CouncellorID OR @CouncellorID = 0
                GROUP BY Dept.Department_Name
            END

            IF (@flag = 8)
            BEGIN
                SELECT * 
                FROM Tbl_EnquiryAttendence 
                WHERE (Delete_status = 0 OR Delete_status IS NULL) 
                    AND CandidateID = @candidateID
            END

            IF (@flag = 9)
            BEGIN
                UPDATE Tbl_EnquiryAttendence 
                SET Delete_status = 1 
                WHERE CandidateID = @candidateID
            END
        END
    ')
END

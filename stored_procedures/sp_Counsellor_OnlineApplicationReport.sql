IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Counsellor_OnlineApplicationReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Counsellor_OnlineApplicationReport]    
        (    
        @CouncellorID bigint = 0
        )
        AS
        BEGIN
            DECLARE @withdraw bigint
            DECLARE @Reject bigint
            DECLARE @PaymentReceived bigint
            DECLARE @Offersend bigint
            DECLARE @Reply bigint
            DECLARE @Follow bigint
            DECLARE @Reads bigint
            DECLARE @New bigint
            DECLARE @Counsellor Varchar(MAX)

            SET @withdraw = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''Withdrawn'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''Withdrawn'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                ) W
            )

            SET @Reject = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''rejected'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''rejected'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                ) r
            )

            SET @PaymentReceived = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''approved'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''approved'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                ) l
            )

            SET @Offersend = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''approved'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''approved'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                ) k
            )

            SET @Reply = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''approved'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                    AND ApplicationStatus = ''approved'' 
                    AND MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE())
                ) R
            )

            SET @Reads = (
                SELECT COUNT(*) 
                FROM Tbl_EnquiryAttendence 
                WHERE CouncellorID = @CouncellorID  
                AND MONTH(AttendedDateTime) = MONTH(GETDATE()) 
                AND YEAR(AttendedDateTime) = YEAR(GETDATE())
            )

            SET @Follow = (
                SELECT COUNT(Candidate_Id) 
                FROM Tbl_FollowUp_Detail 
                WHERE Counselor_Employee = @CouncellorID 
                AND MONTH(Followup_Date) = MONTH(GETDATE()) 
                AND YEAR(Followup_Date) = YEAR(GETDATE())
            )

            SET @New = (
                SELECT (
                    SELECT COUNT(Candidate_Id) 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE()) 
                    AND CounselorEmployee_id = @CouncellorID
                ) - 
                (SELECT COUNT(DISTINCT CandidateID) 
                 FROM Tbl_EnquiryAttendence 
                 WHERE CouncellorID = @CouncellorID 
                 AND MONTH(AttendedDateTime) = MONTH(GETDATE()) 
                 AND YEAR(AttendedDateTime) = YEAR(GETDATE()) 
                 AND CandidateID IN (
                    SELECT COUNT(Candidate_Id) 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE MONTH(RegDate) = MONTH(GETDATE()) 
                    AND YEAR(RegDate) = YEAR(GETDATE()) 
                    AND CounselorEmployee_id = @CouncellorID
                ))
            )

            SET @Counsellor = (
                SELECT Employee_FName + '' '' + Employee_LName 
                FROM Tbl_Employee 
                WHERE Employee_Id = @CouncellorID
            )

            BEGIN
                CREATE TABLE #tempchart (
                    valuetype VARCHAR(MAX),
                    value BIGINT
                )

                INSERT INTO #tempchart
                SELECT ''withdraw'', @withdraw AS withdraw 
                UNION ALL
                SELECT ''Reject'', @Reject AS Reject 
                UNION ALL
                SELECT ''PaymentReceived'', @PaymentReceived AS [Payment Received] 
                UNION ALL
                SELECT ''Offersend'', @Offersend AS Offersend 
                UNION ALL
                SELECT ''Reply'', @Reply AS Reply 
                UNION ALL
                SELECT ''Follow'', @Follow AS Follow 
                UNION ALL
                SELECT ''Reads'', @Reads AS Reads 
                UNION ALL
                SELECT ''New'', @New AS New

                SELECT * FROM #tempchart
                --WHERE value != 0
            END
        END
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Counsellor_OnlineApplicationReportfilter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Counsellor_OnlineApplicationReportfilter] 
        (
            @CouncellorID bigint = 0,
            @Fromdate varchar(MAX) = '''',
            @todate varchar(MAX) = ''''
        )
        AS
        BEGIN
            DECLARE @withdraw bigint;
            DECLARE @Reject bigint;
            DECLARE @PaymentReceived bigint;
            DECLARE @Offersend bigint;
            DECLARE @Reply bigint;
            DECLARE @Follow bigint;
            DECLARE @Reads bigint;
            DECLARE @New bigint;
            DECLARE @Counsellor Varchar(MAX);

            SET @withdraw = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''Withdrawn''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''Withdrawn''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                ) U
            );

            SET @Reject = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''rejected''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''rejected''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                ) M
            );

            SET @PaymentReceived = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''approved''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''approved''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                ) B
            );

            SET @Offersend = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''approved''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''approved''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                ) Y
            );

            SET @Reply = (
                SELECT COUNT(*) 
                FROM (
                    SELECT Candidate_Id 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''approved''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                    UNION ALL
                    SELECT Candidate_Id 
                    FROM Tbl_Student_NewApplication 
                    WHERE CounselorEmployee_id = @CouncellorID 
                        AND ApplicationStatus = ''approved''
                        AND (
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        )
                ) C
            );

            SET @Reads = (
                SELECT COUNT(*) 
                FROM Tbl_EnquiryAttendence  
                WHERE CouncellorID = @CouncellorID 
                    AND (
                        ((CONVERT(date, AttendedDateTime)) >= @Fromdate AND (CONVERT(date, AttendedDateTime)) < DATEADD(day, 1, @todate)) 
                        OR (@Fromdate IS NULL AND @todate IS NULL) 
                        OR (@Fromdate IS NULL AND (CONVERT(date, AttendedDateTime)) < DATEADD(day, 1, @todate)) 
                        OR (@todate IS NULL AND (CONVERT(date, AttendedDateTime)) >= @Fromdate)
                    )
            );

            SET @Follow = (
                SELECT COUNT(*) 
                FROM Tbl_FollowUp_Detail 
                WHERE Counselor_Employee = @CouncellorID 
                    AND (
                        ((CONVERT(date, Followup_Date)) >= @Fromdate AND (CONVERT(date, Followup_Date)) < DATEADD(day, 1, @todate)) 
                        OR (@Fromdate IS NULL AND @todate IS NULL) 
                        OR (@Fromdate IS NULL AND (CONVERT(date, Followup_Date)) < DATEADD(day, 1, @todate)) 
                        OR (@todate IS NULL AND (CONVERT(date, Followup_Date)) >= @Fromdate)
                    )
            );

            SET @New = (
                SELECT COUNT(Candidate_Id) 
                FROM Tbl_Candidate_Personal_Det 
                WHERE 
                    ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                    OR (@Fromdate IS NULL AND @todate IS NULL) 
                    OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                    OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                    AND CounselorEmployee_id = @CouncellorID
            ) - (
                SELECT COUNT(DISTINCT CandidateID) 
                FROM Tbl_EnquiryAttendence 
                WHERE CouncellorID = @CouncellorID
                    AND (
                        ((CONVERT(date, AttendedDateTime)) >= @Fromdate AND (CONVERT(date, AttendedDateTime)) < DATEADD(day, 1, @todate)) 
                        OR (@Fromdate IS NULL AND @todate IS NULL) 
                        OR (@Fromdate IS NULL AND (CONVERT(date, AttendedDateTime)) < DATEADD(day, 1, @todate)) 
                        OR (@todate IS NULL AND (CONVERT(date, AttendedDateTime)) >= @Fromdate)
                    )
                    AND CandidateID IN (
                        SELECT COUNT(Candidate_Id) 
                        FROM Tbl_Candidate_Personal_Det 
                        WHERE 
                            ((CONVERT(date, RegDate)) >= @Fromdate AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@Fromdate IS NULL AND @todate IS NULL) 
                            OR (@Fromdate IS NULL AND (CONVERT(date, RegDate)) < DATEADD(day, 1, @todate)) 
                            OR (@todate IS NULL AND (CONVERT(date, RegDate)) >= @Fromdate)
                        AND CounselorEmployee_id = @CouncellorID
                    )
            );

            SET @Counsellor = (
                SELECT Employee_FName + '' '' + Employee_LName 
                FROM Tbl_Employee 
                WHERE Employee_Id = @CouncellorID
            );

            CREATE TABLE #tempchart (valuetype varchar(MAX), value bigint);
            INSERT INTO #tempchart 
            SELECT ''withdraw'', @withdraw 
            UNION ALL
            SELECT ''reject'', @Reject 
            UNION ALL
            SELECT ''paymentreceived'', @PaymentReceived 
            UNION ALL
            SELECT ''offersend'', @Offersend 
            UNION ALL
            SELECT ''reply'', @Reply 
            UNION ALL
            SELECT ''follow'', @Follow 
            UNION ALL
            SELECT ''reads'', @Reads 
            UNION ALL
            SELECT ''new'', @New;

            SELECT * FROM #tempchart;

            DROP TABLE #tempchart;
        END
    ');
END

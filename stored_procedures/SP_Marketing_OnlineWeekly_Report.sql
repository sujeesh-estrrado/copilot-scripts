IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_OnlineWeekly_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Marketing_OnlineWeekly_Report]  
(	
	@flag bigint = 0,
	@Status varchar(MAX) = '''',
	@Fromdate datetime = null,
	@todate varchar(MAX) = '''',
	@CounselorEmployeeId bigint = 0
)
AS      
BEGIN 
    IF (@flag = 1)
    BEGIN
        SELECT * INTO #TEMP FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Enqcount DESC) AS slno, BK.* FROM (        
            (SELECT COUNT(DISTINCT D.Candidate_Id) AS Enqcount, D.CounselorEmployee_id 
             FROM Tbl_Employee E
             LEFT JOIN Tbl_Employee_User U ON E.Employee_Id = U.Employee_Id
             LEFT JOIN Tbl_RoleAssignment A ON A.employee_id = E.Employee_Id
             LEFT JOIN Tbl_Role R ON R.role_Id = A.role_id
             LEFT JOIN Tbl_Candidate_Personal_Det D ON D.CounselorEmployee_id = E.Employee_Id
             LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
             LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
             LEFT JOIN Tbl_Offerlettre o ON O.candidate_id = D.Candidate_Id 
             WHERE role_Name = ''Counsellor'' AND (ApplicationStatus = ''Pending'') 
             AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103))
             GROUP BY D.CounselorEmployee_id
            )
        ) BK) B
        
        SELECT T.*, Employee_FName + '' '' + Employee_LName AS Empname 
        FROM #TEMP T 
        LEFT JOIN Tbl_Employee E ON T.CounselorEmployee_id = E.Employee_Id
        WHERE T.CounselorEmployee_id != 0 
    END
    
    IF (@flag = 2)
    BEGIN
        DECLARE @startdate DATETIME;
        DECLARE @enddate DATETIME;
        SET @startdate = CONVERT(DATETIME, @Fromdate, 103);
        SET @enddate = CONVERT(DATETIME, @todate, 103);
        
        WITH mycte AS
        ( 
            SELECT CAST(@startdate AS DATETIME) DateValue
            UNION ALL 
            SELECT DateValue + 1
            FROM mycte 
            WHERE DateValue + 1 <= @enddate
        )
        
        SELECT CONVERT(VARCHAR, DateValue, 103) AS dates FROM mycte
        OPTION (MAXRECURSION 3660);
    END
    
    IF (@flag = 3)
    BEGIN
        DECLARE @new BIGINT;
        DECLARE @read BIGINT;
        DECLARE @called BIGINT;
        DECLARE @reply BIGINT;
        DECLARE @offerlettersent BIGINT;
        DECLARE @payment BIGINT;
        DECLARE @Reject BIGINT;
        DECLARE @Withdraw BIGINT;
        DECLARE @Total BIGINT;
        DECLARE @wrongIC BIGINT;
        DECLARE @Grandtotal BIGINT;

        SET @new = (SELECT COUNT(DISTINCT Candidate_Id) 
                   FROM Tbl_Candidate_Personal_Det 
                   WHERE ApplicationStatus = ''Pending'' 
                   AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));
        
        SET @read = (SELECT COUNT(DISTINCT Candidate_Id) 
                    FROM Tbl_Candidate_Personal_Det 
                    WHERE (ApplicationStatus IN (''Submited'', ''Pending'', ''approved'', ''Verified''))
                    AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));

        SET @called = (SELECT COUNT(DISTINCT Candidate_Id) AS called  
                      FROM Tbl_FollowUp_Detail 
                      WHERE (Followup_Date BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));

        SET @reply = (SELECT COUNT(DISTINCT Candidate_Id) AS called  
                     FROM Tbl_FollowUp_Detail 
                     WHERE (Respond_Type <> '''' AND Respond_Type <> ''NULL'' AND Respond_Type <> ''0'') 
                     AND (Followup_Date BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));

        SET @offerlettersent = (SELECT COUNT(DISTINCT Candidate_Id) 
                               FROM Tbl_Candidate_Personal_Det 
                               WHERE ApplicationStatus = ''Approved'' 
                               AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));

        SET @payment = (SELECT COUNT(DISTINCT studentid) AS countfee 
                       FROM student_bill B 
                       LEFT JOIN Tbl_Candidate_Personal_Det D ON D.Candidate_Id = studentid
                       WHERE outstandingbalance = 0 
                       AND (ApplicationStatus IN (''Submited'', ''Pending'', ''approved'', ''rejected'', ''Verified'', ''Conditional_Admission'', ''Preactivated''))
                       AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));

        SET @Reject = (SELECT COUNT(DISTINCT Candidate_Id) 
                      FROM Tbl_Candidate_Personal_Det 
                      WHERE ApplicationStatus = ''rejected'' 
                      AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));

        SET @Withdraw = (SELECT COUNT(DISTINCT Candidate_Id) 
                        FROM Tbl_Candidate_Personal_Det 
                        WHERE ApplicationStatus = ''withdraw'' 
                        AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)));

        SET @Total = ISNULL(@new, 0) + ISNULL(@read, 0) + ISNULL(@called, 0) + ISNULL(@reply, 0) + 
                    ISNULL(@offerlettersent, 0) + ISNULL(@payment, 0) + ISNULL(@Reject, 0) + ISNULL(@Withdraw, 0);

        SET @wrongIC = (SELECT COUNT(DISTINCT L.Candidate_Id) 
                      FROM Tbl_RejectionLog L
                      LEFT JOIN Tbl_Candidate_Personal_Det D ON D.Candidate_Id = L.Candidate_Id
                      WHERE ApplicationStatus = ''rejected''
                      AND (RegDate BETWEEN CONVERT(DATETIME, @Fromdate, 103) AND CONVERT(DATETIME, @todate, 103)) 
                      AND (RejectRemarks LIKE ''% wrong IC%'' OR RejectRemarks LIKE ''% wrong Passport%''));

        SET @Grandtotal = @Total - ISNULL(@wrongIC, 0);

        CREATE TABLE #tempweek (
            new BIGINT, 
            reads BIGINT, 
            called BIGINT, 
            reply BIGINT, 
            offer BIGINT, 
            payment BIGINT, 
            reject BIGINT, 
            Withdraw BIGINT, 
            total BIGINT, 
            wrongic BIGINT, 
            Grandtotal BIGINT
        );
        
        INSERT INTO #tempweek (new, reads, called, reply, offer, payment, reject, Withdraw, total, wrongic, Grandtotal)
        SELECT @new, @read, @called, @reply, @offerlettersent, @payment, @Reject, @Withdraw, @Total, @wrongIC, @Grandtotal;
        
        SELECT * FROM #tempweek;
    END
    
    IF (@flag = 4)
    BEGIN
        IF (@Status = ''New'')
        BEGIN
            SELECT * INTO #TEMP1 FROM
            (SELECT ROW_NUMBER() OVER (ORDER BY enqcount DESC) AS slno, BK.* FROM (        
                (SELECT COUNT(DISTINCT D.Candidate_Id) AS enqcount, D.CounselorEmployee_id 
                 FROM Tbl_Employee E
                 LEFT JOIN Tbl_Employee_User U ON E.Employee_Id = U.Employee_Id
                 LEFT JOIN Tbl_RoleAssignment A ON A.employee_id = E.Employee_Id
                 LEFT JOIN Tbl_Role R ON R.role_Id = A.role_id
                 LEFT JOIN Tbl_Candidate_Personal_Det D ON D.CounselorEmployee_id = E.Employee_Id
                 LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
                 LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
                 LEFT JOIN Tbl_Offerlettre o ON O.candidate_id = D.Candidate_Id 
                 WHERE role_Name = ''Counsellor'' AND (ApplicationStatus = ''Pending'')
                 AND (CONVERT(VARCHAR, RegDate, 103)) = (CONVERT(VARCHAR, @Fromdate, 103))
                 GROUP BY D.CounselorEmployee_id
                )
            ) BK) B
            
            SELECT T.*, Employee_FName 
            FROM #TEMP1 T 
            LEFT JOIN Tbl_Employee E ON T.CounselorEmployee_id = E.Employee_Id
            WHERE T.CounselorEmployee_id = @CounselorEmployeeId;
        END
        
        IF (@Status = ''Followup'')
        BEGIN
            SELECT * INTO #TEMP2 FROM
            (SELECT ROW_NUMBER() OVER (ORDER BY enqcount DESC) AS slno, BK.* FROM (        
                (SELECT COUNT(DISTINCT F.Candidate_Id) AS enqcount, D.CounselorEmployee_id, Followup_Date 
                 FROM Tbl_Employee E
                 LEFT JOIN Tbl_Employee_User U ON E.Employee_Id = U.Employee_Id
                 LEFT JOIN Tbl_RoleAssignment A ON A.employee_id = E.Employee_Id
                 LEFT JOIN Tbl_Role R ON R.role_Id = A.role_id
                 LEFT JOIN Tbl_Candidate_Personal_Det D ON D.CounselorEmployee_id = E.Employee_Id
                 LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
                 LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
                 LEFT JOIN Tbl_Offerlettre o ON O.candidate_id = D.Candidate_Id 
                 LEFT JOIN Tbl_FollowUp_Detail F ON F.Candidate_Id = D.Candidate_Id
                 WHERE role_Name = ''Counsellor'' 
                 AND (ApplicationStatus IN (''Pending'', ''Conditional_Admission'', ''Verified'', ''approved'', ''submited'', ''Preactivated''))
                 AND (CONVERT(DATETIME, RegDate, 103)) = (CONVERT(DATETIME, @Fromdate, 103))
                 GROUP BY D.CounselorEmployee_id, Followup_Date
                )
            ) BK) B
            
            SELECT T.*, Employee_FName 
            FROM #TEMP2 T 
            LEFT JOIN Tbl_Employee E ON T.CounselorEmployee_id = E.Employee_Id
            WHERE T.CounselorEmployee_id = @CounselorEmployeeId;
        END
        
        IF (@Status = ''Approved'')
        BEGIN
            SELECT * INTO #TEMP3 FROM
            (SELECT ROW_NUMBER() OVER (ORDER BY enqcount DESC) AS slno, BK.* FROM (        
                (SELECT COUNT(DISTINCT D.Candidate_Id) AS enqcount, D.CounselorEmployee_id
                 FROM Tbl_Candidate_Personal_Det D
                 LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
                 LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
                 LEFT JOIN Tbl_Offerlettre o ON O.candidate_id = D.Candidate_Id 
                 WHERE (ApplicationStatus = ''approved'')
                 AND (CONVERT(DATETIME, RegDate, 103)) = (CONVERT(DATETIME, @Fromdate, 103))
                 GROUP BY D.CounselorEmployee_id
                )
            ) BK) B
            
            SELECT T.*, Employee_FName 
            FROM #TEMP3 T 
            LEFT JOIN Tbl_Employee E ON T.CounselorEmployee_id = E.Employee_Id
            WHERE T.CounselorEmployee_id = @CounselorEmployeeId;
        END
        
        IF (@Status = ''rejected'')
        BEGIN
            SELECT * INTO #TEMP4 FROM
            (SELECT ROW_NUMBER() OVER (ORDER BY enqcount DESC) AS slno, BK.* FROM (        
                (SELECT COUNT(DISTINCT D.Candidate_Id) AS enqcount, D.CounselorEmployee_id
                 FROM Tbl_Candidate_Personal_Det D
                 LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
                 LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
                 LEFT JOIN Tbl_Offerlettre o ON O.candidate_id = D.Candidate_Id 
                 WHERE (ApplicationStatus = ''rejected'')
                 AND (CONVERT(DATETIME, RegDate, 103)) = (CONVERT(DATETIME, @Fromdate, 103))
                 GROUP BY D.CounselorEmployee_id
                )
            ) BK) B
            
            SELECT T.*, Employee_FName 
            FROM #TEMP4 T 
            LEFT JOIN Tbl_Employee E ON T.CounselorEmployee_id = E.Employee_Id
            WHERE T.CounselorEmployee_id = @CounselorEmployeeId;
        END
        
        IF (@Status = ''0'')
        BEGIN
            SELECT * INTO #TEMPa FROM
            (SELECT ROW_NUMBER() OVER (ORDER BY enqcount DESC) AS slno, BK.* FROM (        
                (SELECT COUNT(DISTINCT D.Candidate_Id) AS enqcount, D.CounselorEmployee_id 
                 FROM Tbl_Employee E
                 LEFT JOIN Tbl_Employee_User U ON E.Employee_Id = U.Employee_Id
                 LEFT JOIN Tbl_RoleAssignment A ON A.employee_id = E.Employee_Id
                 LEFT JOIN Tbl_Role R ON R.role_Id = A.role_id
                 LEFT JOIN Tbl_Candidate_Personal_Det D ON D.CounselorEmployee_id = E.Employee_Id
                 LEFT JOIN student_bill B ON D.Candidate_Id = B.studentid
                 LEFT JOIN tbl_New_Admission N ON D.New_Admission_Id = N.New_Admission_Id
                 LEFT JOIN Tbl_Offerlettre o ON O.candidate_id = D.Candidate_Id 
                 WHERE (role_Name = ''Counsellor'' OR role_Name = ''Counsellor Lead'') 
                 AND (ApplicationStatus IN (''Pending'', ''Conditional_Admission'', ''Verified'', ''approved'', ''submited'', ''Preactivated''))
                 AND (CONVERT(DATE, D.RegDate, 103)) = (CONVERT(DATE, @Fromdate, 103))
                 GROUP BY D.CounselorEmployee_id
                )
            ) BK) B
            
            SELECT T.*, Employee_FName 
            FROM #TEMPa T 
            LEFT JOIN Tbl_Employee E ON T.CounselorEmployee_id = E.Employee_Id
            WHERE T.CounselorEmployee_id = @CounselorEmployeeId;
        END
    END
END
')
END;
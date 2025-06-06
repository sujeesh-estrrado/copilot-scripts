IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentFine]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_StudentFine] 
        (
            @flag INT = 0,
            @StudentID BIGINT = 0,
            @FirstStudentID BIGINT = 0,
            @CheckPoint BIGINT = 0,
            @BillGroupID BIGINT = 0,
            @FineBillID BIGINT = 0,
            @Status BIT = 1
        )
        AS
        BEGIN
            IF(@flag = 1) -- Due Students
            BEGIN
                SELECT sbg.studentid
                FROM student_bill_group AS sbg 
                JOIN student_bill AS sb ON sbg.billgroupid = sb.billgroupid 
                JOIN tbl_Student_AccountGroup_Map AS SAGM ON SAGM.StudentID = sbg.studentid 
                JOIN fee_group AS FG ON FG.groupid = SAGM.FeeGroupID
                GROUP BY sbg.studentid, FG.groupname, FG.MinimumAmount
                HAVING SUM(outstandingbalance) > FG.MinimumAmount
            END

            IF(@flag = 2) -- Checkpoints (10-14, 15-21, 22-27, >28)
            BEGIN
                DECLARE @tep_table TABLE
                (
                    studentid INT
                )
                INSERT INTO @tep_table
                EXEC sp_StudentFine 1
                
                IF(@CheckPoint = 1) -- between 10 and 14
                BEGIN
                    SELECT DISTINCT(sbg.studentid), SUM(outstandingbalance) AS outstandingbal, 
                           MIN(sb.dateissue) AS IssueDate, MIN(sbg.billgroupid) AS OldestBillGroupID,
                           DATEDIFF(DAY, MIN(sb.dateissue), GETDATE()) AS DateDiffs, CPD.active
                    FROM student_bill_group AS sbg 
                    JOIN student_bill AS sb ON sbg.billgroupid = sb.billgroupid 
                    JOIN tbl_Student_AccountGroup_Map AS SAGM ON SAGM.StudentID = sbg.studentid 
                    JOIN fee_group AS FG ON FG.groupid = SAGM.FeeGroupID 
                    JOIN student_transaction AS st ON st.billgroupid = sb.billgroupid 
                    LEFT JOIN Tbl_Candidate_Personal_Det AS CPD ON CPD.Candidate_Id = sbg.studentid
                    GROUP BY sbg.studentid, CPD.active, CPD.Candidate_Id
                    HAVING SUM(outstandingbalance) > 0 
                           AND sbg.studentid IN (SELECT * FROM @tep_table) 
                           AND CPD.active = 3 
                           AND CPD.Candidate_Id > @FirstStudentID
                           AND (DATEDIFF(DAY, MIN(sb.dateissue), GETDATE()) BETWEEN 10 AND 14)
                END
                
                -- Additional CheckPoints (15-21, 22-27, >28) here...

            END

            IF(@flag = 3) -- Get oldest outstanding bill by student ID
            BEGIN
                SELECT TOP 1 sb.billgroupid, sbg.dateissued, sbg.studentid
                FROM student_bill_group AS sbg 
                JOIN student_bill AS sb ON sbg.billgroupid = sb.billgroupid
                GROUP BY sbg.studentid, sb.billgroupid, sbg.dateissued
                HAVING SUM(sb.outstandingbalance) > 0 AND sbg.studentid = @StudentID
                ORDER BY sbg.dateissued
            END

            IF(@flag = 4) -- Select active StudentDueLog by student ID
            BEGIN
                SELECT id, studentID, BillGrooupID, check_Point, [Status]
                FROM Tbl_StudentDueLog 
                WHERE [Status] = 1 AND studentID = @StudentID
            END

            IF(@flag = 5) -- Insert into StudentDueLog
            BEGIN
                INSERT INTO [dbo].[Tbl_StudentDueLog]
                    ([studentID], [BillGrooupID], [check_Point], [Status])
                VALUES
                    (@studentID, @BillGroupID, @CheckPoint, 1)
            END

            IF(@flag = 6) -- Update active StudentDueLog by student ID
            BEGIN
                UPDATE Tbl_StudentDueLog
                SET BillGrooupID = @BillGroupID, check_Point = @CheckPoint
                WHERE [Status] = 1 AND studentID = @StudentID
            END

            IF(@flag = 7) -- Insert FineLog
            BEGIN
                INSERT INTO [dbo].[tbl_StudentFineLog]
                    ([studentID], [dateOfIssue], [FineBillID], [Status])
                VALUES
                    (@studentID, GETDATE(), @FineBillID, 1)
            END

            IF(@flag = 8) -- Get Active FineLog by Student
            BEGIN
                SELECT [studentID], MAX([dateOfIssue]) AS dateOfIssue
                FROM [dbo].[tbl_StudentFineLog]
                WHERE studentID = @studentID AND [Status] = 1
                GROUP BY studentID
            END

            IF(@flag = 9) -- Inactivate FineLog by Student
            BEGIN
                UPDATE [tbl_StudentFineLog]
                SET [Status] = 0
                WHERE studentID = @studentID AND [Status] = 1
            END
        END
    ')
END

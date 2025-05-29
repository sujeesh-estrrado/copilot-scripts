IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_cound]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_cound] --3,3
        (@id BIGINT, @emp_id BIGINT)
        AS
        BEGIN
            IF (@id = 1)
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus IN (''Pending'', ''submited'', ''approved'', ''rejected'', 
                                            ''Verified'', ''Conditional_Admission'', ''Preactivated'')
            END
            ELSE IF (@id = 2) ---Total enquiry
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE CounselorEmployee_id = @emp_id
                AND ApplicationStatus IN (''Pending'', ''submited'')
            END
            ELSE IF (@id = 3) --Verified count
            BEGIN
                SELECT COUNT(CPD.Candidate_Id)
                FROM dbo.Tbl_Candidate_Personal_Det AS CPD
                WHERE CounselorEmployee_id = @emp_id
                AND ApplicationStatus IN (''approved'', ''Verified'', ''Conditional_Admission'', ''Preactivated'')
                AND Candidate_DelStatus = 0
            END
            ELSE IF (@id = 4)
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''Completed'' 
                AND CounselorEmployee_id = @emp_id
            END
            ELSE IF (@id = 5) --Approved candidate Count
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''Approved''
                AND CounselorEmployee_id = @emp_id
            END
            ELSE IF (@id = 6)
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE counselorEmployee_id = @emp_id
            END
            ELSE IF (@id = 7) --Total paid candidate Count
            BEGIN
                SELECT COUNT(DISTINCT D.Candidate_Id) AS paidcount
                FROM Tbl_Candidate_Personal_Det D
                LEFT JOIN student_bill b ON D.Candidate_Id = b.studentid
                WHERE ApplicationStatus IN (''Pending'', ''submited'', ''approved'', ''rejected'', 
                                            ''Verified'', ''Conditional_Admission'', ''Preactivated'', ''Completed'')
                AND CounselorEmployee_id = @emp_id
                AND ApplicationStage IN (''Submit without payment'', ''Submited with payment'')
                AND billgroupid IN (
                    SELECT billgroupid
                    FROM student_transaction
                    WHERE semesterno = -1
                    AND outstandingbalance > 0
                    AND studentid = Candidate_Id
                    AND billcancel = 0
                )
            END
            ELSE IF (@id = 8) --On Hold candidate Count
            BEGIN
                SELECT COUNT(DISTINCT M.Candidate_Id) AS holdcount
                FROM Tbl_Status_change_by_Marketing M
                LEFT JOIN Tbl_Candidate_Personal_Det D ON M.Candidate_Id = D.candidate_Id
                WHERE CounselorEmployee_id = @emp_id AND M.status = ''Hold''
            END
            ELSE IF (@id = 9) --Pending Followups candidate Count
            BEGIN
                SELECT COUNT(DISTINCT cpd.Candidate_Id) AS Followcount
                FROM tbl_candidate_personal_det cpd
                LEFT JOIN (
                    SELECT Candidate_Id, Next_Date, Respond_Type
                    FROM Tbl_FollowUp_Detail
                    WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
                    AND Follow_Up_Detail_Id IN (
                        SELECT MAX(Follow_Up_Detail_Id)
                        FROM Tbl_FollowUp_Detail
                        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
                        GROUP BY Candidate_Id
                    )
                    AND Action_Taken = 0
                ) AS f ON f.candidate_id = cpd.candidate_id
                WHERE (f.Next_Date IS NULL OR f.Next_Date <= CONVERT(DATE, GETDATE()))
                AND (cpd.ApplicationStatus IN (''pending'', ''submited''))
                AND (cpd.counseloremployee_id = @emp_id OR @emp_id = 0)
            END
            ELSE IF (@id = 10) --Rejected candidate Count
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''rejected''
                AND CounselorEmployee_id = @emp_id
            END
            ELSE IF (@id = 11) --New candidate Count
            BEGIN
                WITH level1 AS (
                    SELECT 
                        (SELECT COUNT(Candidate_Id)
                        FROM Tbl_Candidate_Personal_Det
                        WHERE ApplicationStatus IN (''Pending'', ''submited'')
                        AND CounselorEmployee_id = @emp_id)
                        -
                        (SELECT COUNT(DISTINCT CandidateID)
                        FROM Tbl_EnquiryAttendence
                        INNER JOIN Tbl_Candidate_Personal_Det
                        ON CandidateID = Candidate_Id
                        WHERE ApplicationStatus IN (''Pending'', ''submited'')
                        AND CouncellorID = @emp_id
                        AND CandidateID != 0) AS count
                )
                SELECT CASE WHEN count > 0 THEN count ELSE 0 END AS counts FROM level1
            END
            ELSE IF (@id = 12) --Approved candidate Count for admission
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''Approved''
            END
            ELSE IF (@id = 13) --verified count admission
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus IN (''Verified'', ''Conditional_Admission'')
                OR ApplicationCategory = ''Preactivated''
            END
            ELSE IF (@id = 14)
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''Completed''
            END
            ELSE IF (@id = 15) --Total paid candidate Count
            BEGIN
                SELECT COUNT(DISTINCT D.Candidate_Id) AS paidcount
                FROM Tbl_Candidate_Personal_Det D
                LEFT JOIN student_bill b ON D.Candidate_Id = b.studentid
                WHERE ApplicationStatus IN (''Pending'', ''submited'', ''approved'', ''rejected'', 
                                            ''Verified'', ''Conditional_Admission'', ''Preactivated'', ''Completed'')
                AND ApplicationStage IN (''Submit without payment'', ''Submited with payment'')
                AND billgroupid IN (
                    SELECT billgroupid
                    FROM student_transaction
                    WHERE semesterno = -1
                    AND outstandingbalance > 0
                    AND studentid = Candidate_Id
                    AND billcancel = 0
                )
            END
            ELSE IF (@id = 16) --On Hold candidate Count
            BEGIN
                SELECT COUNT(DISTINCT M.Candidate_Id) AS holdcount
                FROM Tbl_Status_change_by_Marketing M
                LEFT JOIN Tbl_Candidate_Personal_Det D ON M.Candidate_Id = D.candidate_Id
                WHERE M.status = ''Hold''
            END
            ELSE IF (@id = 17) --Pending Followups candidate Count
            BEGIN
                SELECT COUNT(DISTINCT F.Candidate_Id) AS Followcount
                FROM Tbl_FollowUp_Detail F
                LEFT JOIN Tbl_Candidate_Personal_Det D ON F.Candidate_Id = D.candidate_Id
                WHERE FORMAT(Next_Date, ''yyyy-MM-dd'') >= FORMAT(GETDATE(), ''yyyy-MM-dd'')
                AND ApplicationStatus IN (''Pending'', ''submited'')
            END
            ELSE IF (@id = 18) --verified count admission
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''Verified''
                AND CounselorEmployee_id = @emp_id
            END
            ELSE IF (@id = 19) --Preactivated count
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''Preactivated''
                AND CounselorEmployee_id = @emp_id
            END
            ELSE IF (@id = 20) --Rejected count admission
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''rejected''
                AND CounselorEmployee_id = @emp_id
            END
            ELSE IF (@id = 21) --On Hold count for admission
            BEGIN
                SELECT COUNT(DISTINCT M.Candidate_Id) AS holdcount
                FROM Tbl_Status_change_by_Marketing M
                LEFT JOIN Tbl_Candidate_Personal_Det D ON M.Candidate_Id = D.candidate_Id
                WHERE CounselorEmployee_id = @emp_id
                AND M.status = ''Hold''
            END
            ELSE IF (@id = 22) --Completed count for admission
            BEGIN
                SELECT COUNT(Candidate_Id)
                FROM Tbl_Candidate_Personal_Det
                WHERE ApplicationStatus = ''Completed''
                AND CounselorEmployee_id = @emp_id
            END
        END
    ')
END

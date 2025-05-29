IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_StudentPaymentListReport]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_StudentPaymentListReport]
        (
            @flag BIGINT = 0,
            @ProgrammeTypeId BIGINT = 0,
            @IntakeId BIGINT = 0,
            @PgmID BIGINT = 0,
            @CurrentPage BIGINT = 1,
            @PageSize BIGINT = 10,
            @studentid BIGINT = 0
        )
        AS
        BEGIN
            -- FLAG 0: List all Candidates with Pagination
            IF (@flag = 0)
            BEGIN
                SELECT DISTINCT 
                    pd.Candidate_Id,
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS CandidateName, 
                    Pd.IDMatrixNo, 
                    AdharNumber, 
                    IM.Batch_Code AS Batch_Code,
                    CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                    0 AS Amount
                FROM Tbl_Candidate_Personal_Det pd
                LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.CounselorCampus
                WHERE
                    (@IntakeId = 0 OR IM.id = @IntakeId) AND
                    (@PgmID = 0 OR Ad.Department_Id = @PgmID) AND
                    (@ProgrammeTypeId = 0 OR Course_Category_Id = @ProgrammeTypeId)
                ORDER BY CandidateName 
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)
            END

            -- FLAG 1: Count of Candidates
            IF (@flag = 1)
            BEGIN
                SELECT COUNT(DISTINCT pd.Candidate_Id) AS counts
                FROM Tbl_Candidate_Personal_Det pd
                LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.CounselorCampus
                WHERE
                    (@IntakeId = 0 OR IM.id = @IntakeId) AND
                    (@PgmID = 0 OR Ad.Department_Id = @PgmID) AND
                    (@ProgrammeTypeId = 0 OR Course_Category_Id = @ProgrammeTypeId)
            END

            -- FLAG 2: Amount by Student ID
            IF (@flag = 2)
            BEGIN
                SELECT 
                    ISNULL(SUM(student_transaction.amount - student_transaction.adjustmentamount), 0.00) AS Amount
                FROM Tbl_Candidate_Personal_Det pd
                INNER JOIN student_transaction ON pd.Candidate_Id = student_transaction.studentid
                WHERE student_transaction.transactiontype = 1 
                AND pd.Candidate_Id = @studentid
            END

            -- FLAG 3: Total Amount Aggregated
            IF (@flag = 3)
            BEGIN
                SELECT 
                    SUM(ISNULL(student_transaction.amount - student_transaction.adjustmentamount, 0.00)) AS totamount
                FROM Tbl_Candidate_Personal_Det pd
                INNER JOIN student_transaction ON pd.Candidate_Id = student_transaction.studentid
                LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.CounselorCampus
                WHERE
                    student_transaction.transactiontype = 1 AND
                    (@IntakeId = 0 OR IM.id = @IntakeId) AND
                    (@PgmID = 0 OR Ad.Department_Id = @PgmID) AND
                    (@ProgrammeTypeId = 0 OR Course_Category_Id = @ProgrammeTypeId)
            END
        END
    ')
END

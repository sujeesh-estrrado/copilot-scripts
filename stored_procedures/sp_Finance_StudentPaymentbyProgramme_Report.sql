IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_StudentPaymentbyProgramme_Report]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_StudentPaymentbyProgramme_Report]
        (
            @FLAG BIGINT = 0,
            @ProgrammeTypeId BIGINT = 0,
            @IntakeId VARCHAR(MAX) = '''',
            @PgmID VARCHAR(MAX) = '''',
            @PageSize BIGINT,
            @CurrentPage BIGINT
        )
        AS
        BEGIN
            -- FLAG 0: Get Student Payment by Programme with Pagination
            IF (@FLAG = 0)
            BEGIN
                WITH Level1 AS
                (
                    SELECT DISTINCT
                        pd.Candidate_Id,
                        pd.Candidate_Id AS ID,
                        CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS CandidateName,
                        AdharNumber,
                        Ad.Department_Id,
                        Ad.Course_Category_Id,
                        Organization_Name,
                        Pd.IDMatrixNo,
                        IM.Batch_Code AS Batch_Code,
                        Ad.Batch_Id AS IntakeID,
                        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                        s.name AS ApplicationStatus,
                        (
                            SELECT CAST(ISNULL(SUM(p.amount - p.adjustmentamount), 0) AS DECIMAL(18, 2))
                            FROM student_transaction t
                            INNER JOIN student_payment p ON p.studentid = t.studentid AND p.transactionid = t.transactionid
                            WHERE p.studentid = pd.Candidate_Id AND transactiontype = 1
                        ) AS Amount
                    FROM Tbl_Candidate_Personal_Det pd
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.Campus
                    LEFT JOIN Tbl_Student_status S ON S.id = pd.active
                    WHERE
                        (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''') AND
                        (Ad.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) OR @PgmID = '''') AND
                        (@ProgrammeTypeId = 0 OR Course_Category_Id = @ProgrammeTypeId)
                )
                SELECT *
                FROM Level1
                WHERE Amount > 0
                ORDER BY CandidateName ASC
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)
            END

            -- FLAG 1: Get Count and Total Amount
            IF (@FLAG = 1)
            BEGIN
                WITH Level1 AS
                (
                    SELECT DISTINCT
                        pd.Candidate_Id,
                        pd.Candidate_Id AS ID,
                        CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS CandidateName,
                        AdharNumber,
                        Ad.Department_Id,
                        Ad.Course_Category_Id,
                        Organization_Name,
                        Pd.IDMatrixNo,
                        IM.intake_no AS Batch_Code,
                        Ad.Batch_Id AS IntakeID,
                        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                        s.name AS ApplicationStatus,
                        (
                            SELECT CAST(ISNULL(SUM(p.amount - p.adjustmentamount), 0) AS DECIMAL(18, 2))
                            FROM student_transaction t
                            INNER JOIN student_payment p ON p.studentid = t.studentid AND p.transactionid = t.transactionid
                            WHERE p.studentid = pd.Candidate_Id AND transactiontype = 1
                        ) AS Amount
                    FROM Tbl_Candidate_Personal_Det pd
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.Campus
                    LEFT JOIN Tbl_Student_status S ON S.id = pd.active
                    WHERE
                        (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''') AND
                        (Ad.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) OR @PgmID = '''') AND
                        (@ProgrammeTypeId = 0 OR Course_Category_Id = @ProgrammeTypeId)
                )
                SELECT
                    COUNT(*) AS counts,
                    SUM(Amount) AS totamount
                FROM Level1
                WHERE Amount > 0
            END
        END
    ')
END

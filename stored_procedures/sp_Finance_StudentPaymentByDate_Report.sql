IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_StudentPaymentByDate_Report]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_StudentPaymentByDate_Report]
        (
            @flag BIGINT = 0,
            @fromdate DATETIME = NULL,
            @Todate DATETIME = NULL,
            @PageSize BIGINT = 10,
            @CurrentPage BIGINT = 1
        )
        AS
        BEGIN
            DECLARE @UpperBand INT
            DECLARE @LowerBand INT

            SET @LowerBand = (@CurrentPage - 1) * @PageSize
            SET @UpperBand = (@CurrentPage * @PageSize) + 1

            -- FLAG 0: Get Student Payments with Pagination
            IF (@flag = 0)
            BEGIN
                SELECT
                    pd.Candidate_Id,
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS CandidateName,
                    CAST(ISNULL(amount, 0) AS DECIMAL(18, 2)) AS Amount,
                    CONVERT(VARCHAR(10), dateissued, 105) AS Dateissued,
                    AdharNumber,
                    Ad.Department_Id,
                    Ad.Course_Category_Id,
                    Organization_Name,
                    Pd.IDMatrixNo,
                    IM.Batch_Code AS Batch_Code,
                    Ad.Batch_Id AS IntakeID,
                    CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                    ApplicationStatus
                FROM Tbl_Candidate_Personal_Det pd
                INNER JOIN student_transaction st ON pd.Candidate_Id = st.studentid
                LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.CounselorCampus
                WHERE st.transactiontype = 1 AND
                    (
                        ((CONVERT(DATE, dateissued)) >= @fromdate AND (CONVERT(DATE, dateissued)) < DATEADD(DAY, 1, @Todate)) OR
                        (@fromdate IS NULL AND @Todate IS NULL) OR
                        (@fromdate IS NULL AND (CONVERT(DATE, dateissued)) < DATEADD(DAY, 1, @Todate)) OR
                        (@Todate IS NULL AND (CONVERT(DATE, dateissued)) >= @fromdate)
                    )
                ORDER BY CONCAT(Candidate_Fname, '' '', Candidate_Lname), dateissued ASC
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)
            END

            -- FLAG 1: Get Count and Total Amount
            IF (@flag = 1)
            BEGIN
                WITH Level1 AS
                (
                    SELECT
                        pd.Candidate_Id,
                        CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS CandidateName,
                        CAST(ISNULL(amount, 0) AS DECIMAL(18, 2)) AS Amount,
                        CONVERT(VARCHAR(10), dateissued, 105) AS Dateissued,
                        AdharNumber,
                        Ad.Department_Id,
                        Ad.Course_Category_Id,
                        Organization_Name,
                        Pd.IDMatrixNo,
                        IM.intake_no AS Batch_Code,
                        Ad.Batch_Id AS IntakeID,
                        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                        ApplicationStatus
                    FROM Tbl_Candidate_Personal_Det pd
                    INNER JOIN student_transaction st ON pd.Candidate_Id = st.studentid
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.CounselorCampus
                    WHERE st.transactiontype = 1 AND
                        (
                            ((CONVERT(DATE, dateissued)) >= @fromdate AND (CONVERT(DATE, dateissued)) < DATEADD(DAY, 1, @Todate)) OR
                            (@fromdate IS NULL AND @Todate IS NULL) OR
                            (@fromdate IS NULL AND (CONVERT(DATE, dateissued)) < DATEADD(DAY, 1, @Todate)) OR
                            (@Todate IS NULL AND (CONVERT(DATE, dateissued)) >= @fromdate)
                        )
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

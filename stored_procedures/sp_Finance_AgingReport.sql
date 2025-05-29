IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_AgingReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_Finance_AgingReport]
    (
    @flag bigint=0,
    @studentid bigint=0,
    @aging_days bigint=0,
    @BatchID varchar(Max)='''',
    @Department_Id varchar(Max)='''',
    @Facultyid bigint=0,
    @PageSize bigint=10,
    @CurrentPage bigint=1
    )
    AS
    BEGIN
    -- Flag 0: Fetch Aging Summary by Student
    IF(@flag = 0)
    BEGIN
        WITH level1 AS (
            SELECT studentid, SUM(outstandingbalance) AS outstandingbalance,
                DATEDIFF(DAY, dateissue, GETDATE()) AS AgingDays
            FROM dbo.student_bill AS B
            INNER JOIN dbo.student_bill_group AS BG ON B.billgroupid = BG.billgroupid
            WHERE B.outstandingbalance > 0 
                AND DATEDIFF(DAY, B.dateissue, GETDATE()) >= 0
                AND B.billcancel = 0
                AND B.billid NOT IN (
                    SELECT billid
                    FROM tbl_Installment_Bill_Details IBD
                    JOIN tbl_Request_Installment RI ON IBD.InstallmentId = RI.Id
                    WHERE RI.Status = 1
                )
            GROUP BY dateissue, B.studentid
        )
        SELECT t.studentid,
               t.aging_days,
               SUM(t.outstandingbalance) AS outstandingbalance
        FROM (
            SELECT *, CASE
                WHEN AgingDays BETWEEN 0 AND 30 THEN ''30''
                WHEN AgingDays BETWEEN 31 AND 60 THEN ''60''
                WHEN AgingDays BETWEEN 61 AND 90 THEN ''90''
                WHEN AgingDays BETWEEN 91 AND 120 THEN ''120''
                WHEN AgingDays BETWEEN 121 AND 150 THEN ''150''
                WHEN AgingDays BETWEEN 151 AND 180 THEN ''180''
                WHEN AgingDays BETWEEN 181 AND 365 THEN ''365''
                ELSE ''366''
            END AS aging_days
            FROM level1
        ) AS t
        WHERE t.studentid = @studentid
        GROUP BY t.studentid, t.aging_days
        ORDER BY t.studentid
    END

    -- Flag 1: Fetch Student List with Outstanding Balance
    IF(@flag = 1)
    BEGIN
        SELECT DISTINCT B.studentid,
                        CONCAT(Candidate_Fname, '' '', candidate_Lname) AS Studentname,
                        AdharNumber,
                        IDMatrixNo,
                        NA.Course_Level_Id,
                        NA.Department_Id,
                        NA.Batch_Id
        FROM dbo.student_bill AS B
        INNER JOIN dbo.student_bill_group AS BG ON B.billgroupid = BG.billgroupid
        INNER JOIN Tbl_candidate_Personal_Det CDP ON CDP.Candidate_Id = B.studentid
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CDP.New_Admission_Id
        LEFT JOIN Tbl_Course_Level CL ON NA.Course_Level_Id = CL.Course_Level_Id
        LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
        WHERE (B.outstandingbalance > 0)
            AND (DATEDIFF(DAY, B.dateissue, GETDATE()) >= 0)
            AND (B.billcancel = 0)
            AND B.billid NOT IN (
                SELECT billid
                FROM tbl_Installment_Bill_Details IBD
                JOIN tbl_Request_Installment RI ON IBD.InstallmentId = RI.Id
                WHERE RI.Status = 1
            )
            AND (NA.Course_Level_Id = @Facultyid OR @Facultyid = 0)
            AND (IM.id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@BatchID, '','')) OR @BatchID = '''')
            AND (NA.Department_Id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@Department_Id, '','')) OR @Department_Id = '''')
        ORDER BY CONCAT(Candidate_Fname, '' '', candidate_Lname)
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)
    END

    -- Flag 2: Count Total Students with Outstanding Balance
    IF(@flag = 2)
    BEGIN
        SELECT COUNT(*) AS counts
        FROM (
            SELECT DISTINCT B.studentid
            FROM dbo.student_bill AS B
            INNER JOIN dbo.student_bill_group AS BG ON B.billgroupid = BG.billgroupid
            INNER JOIN Tbl_candidate_Personal_Det CDP ON CDP.Candidate_Id = B.studentid
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CDP.New_Admission_Id
            LEFT JOIN Tbl_Course_Level CL ON NA.Course_Level_Id = CL.Course_Level_Id
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
            LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
            WHERE (B.outstandingbalance > 0)
                AND (DATEDIFF(DAY, B.dateissue, GETDATE()) >= 0)
                AND (B.billcancel = 0)
                AND B.billid NOT IN (
                    SELECT billid
                    FROM tbl_Installment_Bill_Details IBD
                    JOIN tbl_Request_Installment RI ON IBD.InstallmentId = RI.Id
                    WHERE RI.Status = 1
                )
                AND (NA.Course_Level_Id = @Facultyid OR @Facultyid = 0)
                AND (IM.id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@BatchID, '','')) OR @BatchID = '''')
                AND (NA.Department_Id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@Department_Id, '','')) OR @Department_Id = '''')
        ) AS temp
    END

    -- Flag 3: Fetch Outstanding Amount by Aging Bucket
    IF(@flag = 3)
    BEGIN
        WITH level1 AS (
            SELECT studentid, SUM(outstandingbalance) AS outstandingbalance,
                DATEDIFF(DAY, dateissue, GETDATE()) AS AgingDays
            FROM dbo.student_bill AS B
            INNER JOIN dbo.student_bill_group AS BG ON B.billgroupid = BG.billgroupid
            WHERE B.outstandingbalance > 0 
                AND DATEDIFF(DAY, B.dateissue, GETDATE()) >= 0
                AND B.billcancel = 0
                AND B.billid NOT IN (
                    SELECT billid
                    FROM tbl_Installment_Bill_Details IBD
                    JOIN tbl_Request_Installment RI ON IBD.InstallmentId = RI.Id
                    WHERE RI.Status = 1
                )
            GROUP BY dateissue, B.studentid
        )
        SELECT ISNULL(SUM(outstandingbalance), CAST(0 AS DECIMAL(18, 2))) AS outstandingbalance,
               t.aging_days
        FROM (
            SELECT *, CASE
                WHEN AgingDays BETWEEN 0 AND 30 THEN ''30''
                WHEN AgingDays BETWEEN 31 AND 60 THEN ''60''
                WHEN AgingDays BETWEEN 61 AND 90 THEN ''90''
                WHEN AgingDays BETWEEN 91 AND 120 THEN ''120''
                WHEN AgingDays BETWEEN 121 AND 150 THEN ''150''
                WHEN AgingDays BETWEEN 151 AND 180 THEN ''180''
                WHEN AgingDays BETWEEN 181 AND 365 THEN ''365''
                ELSE ''366''
            END AS aging_days
            FROM level1
        ) AS t
        WHERE t.studentid = @studentid
        GROUP BY t.aging_days
    END

    -- Flag 4: Fetch Total Sponsorship Amount for Students
    IF(@flag = 4)
    BEGIN
        SELECT ISNULL(SUM(PerSemAmount), CAST(0 AS DECIMAL(18, 2))) AS PerSemAmount
        FROM Tbl_SponsorshipPaymentLog SL
        LEFT JOIN student_sponsor SS ON SS.studentid = SL.StudentID
        LEFT JOIN tbl_SponsorshipSemDetails SD ON SD.SponsorshipID = SS.sponsorid
        WHERE SS.studentid IN (
            SELECT DISTINCT B.studentid
            FROM dbo.student_bill AS B
            INNER JOIN dbo.student_bill_group AS BG ON B.billgroupid = BG.billgroupid
            INNER JOIN Tbl_candidate_Personal_Det CDP ON CDP.Candidate_Id = B.studentid
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CDP.New_Admission_Id
            LEFT JOIN Tbl_Course_Level CL ON NA.Course_Level_Id = CL.Course_Level_Id
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
            LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
            WHERE B.outstandingbalance > 0 
                AND DATEDIFF(DAY, B.dateissue, GETDATE()) >= 0
                AND B.billcancel = 0
                AND B.billid NOT IN (
                    SELECT billid
                    FROM tbl_Installment_Bill_Details IBD
                    JOIN tbl_Request_Installment RI ON IBD.InstallmentId = RI.Id
                    WHERE RI.Status = 1
                )
                AND (NA.Course_Level_Id = @Facultyid OR @Facultyid = 0)
                AND (IM.id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@BatchID, '','')) OR @BatchID = '''')
                AND (NA.Department_Id IN (SELECT CAST(Item AS INT) FROM dbo.SplitString(@Department_Id, '','')) OR @Department_Id = '''')
        )
    END
    END
    ')
END

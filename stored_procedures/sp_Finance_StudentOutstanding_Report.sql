IF NOT EXISTS (
    SELECT 1 FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_StudentOutstanding_Report]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_StudentOutstanding_Report]
        (
            @flag BIGINT = 0,
            @Faculty BIGINT = 0,
            @Program VARCHAR(MAX) = '''',
            @Intake VARCHAR(MAX) = '''',
            @studenttype VARCHAR(MAX) = '''',
            @studentstatus VARCHAR(MAX) = '''',
            @Sponsor VARCHAR(MAX) = '''',
            @Outstandingfrom BIGINT = 0,
            @OutstandingTo BIGINT = 0,
            @operator1 VARCHAR(MAX) = ''<'',
            @operator2 VARCHAR(MAX) = ''>'',
            @CurrentPage INT = 1,
            @PageSize INT = 10
        )
        AS
        BEGIN
            -- Declare common fields to reduce duplicate logic
            SELECT DISTINCT
                CPD.Candidate_Id,
                CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS studentname,
                CPD.IDMatrixNo,
                CPD.AdharNumber,
                CONCAT(DE.Course_Code, ''-'', DE.Department_Name) AS ProgrammeName,
                IM.intake_no AS Batch_Code,
                CPD.active AS studentstatus,
                CPD.TypeOfStudent,
                NA.Course_Level_Id AS facultyId,
                NA.Department_Id,
                SPO.sponsorid,
                BD.Batch_Code,
                ISNULL(SPO.billoutstanding, 0) AS outstandingbalance
            INTO #TempResults
            FROM Tbl_Candidate_Personal_Det CPD
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
            LEFT JOIN tbl_Department DE ON DE.Department_Id = NA.Department_Id
            LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
            LEFT JOIN student_sponsor SPO ON SPO.studentid = CPD.Candidate_Id
            LEFT JOIN Tbl_Nationality NY ON NY.Nationality_Id = CPD.Candidate_Nationality
            LEFT JOIN ref_sponsor refs ON refs.sponsorid = SPO.sponsorid
            WHERE
                (NA.Course_Level_Id = @Faculty OR @Faculty = 0) AND
                (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) OR @Intake = '''') AND
                (NA.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Program, '','')) OR @Program = '''') AND
                (CPD.active IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@studentstatus, '','')) OR @studentstatus = '''') AND
                (@studenttype = '''' OR CPD.TypeOfStudent = @studenttype) AND
                (SPO.sponsorid IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Sponsor, '','')) OR @Sponsor = '''') AND
                ISNULL(SPO.billoutstanding, 0) != 0 AND
                (
                    (ISNULL(SPO.billoutstanding, 0) >= @Outstandingfrom AND ISNULL(SPO.billoutstanding, 0) < @OutstandingTo) OR
                    (@Outstandingfrom = 0 AND @OutstandingTo = 0) OR
                    (@Outstandingfrom = 0 AND ISNULL(SPO.billoutstanding, 0) < @OutstandingTo) OR
                    (@OutstandingTo = 0 AND ISNULL(SPO.billoutstanding, 0) >= @Outstandingfrom)
                )

            -- Handle flag conditions
            IF (@flag = 0)
            BEGIN
                -- Return paginated data when flag = 0
                SELECT *
                FROM #TempResults
                ORDER BY Candidate_Id
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
            END
            ELSE IF (@flag = 1)
            BEGIN
                -- Return complete data when flag = 1
                SELECT *
                FROM #TempResults
                ORDER BY Candidate_Id
                OPTION (RECOMPILE);
            END
        END
    ')
END

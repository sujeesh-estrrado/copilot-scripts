IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_StudentOutstanding_Report_Graphical]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_StudentOutstanding_Report_Graphical] 
        (
            @flag BIGINT = 0,
            @Faculty BIGINT = 0,
            @Program BIGINT = 0,
            @Intake BIGINT = 0,
            @studenttype VARCHAR(MAX) = '''',
            @studentstatus BIGINT = 0,
            @Sponsor BIGINT = 0,
            @Outstandingfrom BIGINT = 0,
            @OutstandingTo BIGINT = 0,
            @operator1 VARCHAR(MAX) = ''<'',
            @operator2 VARCHAR(MAX) = ''>'',
            @deptIds VARCHAR(MAX) = ''''
        )
        AS
        BEGIN
            -- FLAG 0: Main Outstanding Report
            IF (@flag = 0)
            BEGIN
                SELECT DISTINCT
                    CPD.Candidate_Id,
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname, ''('', AdharNumber, '')'') AS studentname,
                    CONCAT(DE.Course_Code, ''-'', DE.Department_Name) AS ProgrammeName,
                    IM.intake_no AS Batch_Code,
                    billoutstanding AS outstandingbalance
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
                    (NA.Department_Id = @Program OR @Program = 0) AND
                    (CPD.active = @studentstatus OR @studentstatus = 0) AND
                    (@studenttype = '''' OR TypeOfStudent = @studenttype) AND
                    (SPO.sponsorid = @Sponsor OR @Sponsor = 0) AND
                    billoutstanding != 0 AND
                    (
                        (billoutstanding >= @Outstandingfrom AND billoutstanding < @OutstandingTo) OR
                        (@Outstandingfrom = 0 AND @OutstandingTo = 0) OR
                        (@Outstandingfrom = 0 AND billoutstanding < @OutstandingTo) OR
                        (@OutstandingTo = 0 AND billoutstanding >= @Outstandingfrom)
                    )
                ORDER BY CPD.Candidate_Id
            END

            -- FLAG 1: Fetch Distinct Programs for Graph
            IF (@flag = 1)
            BEGIN
                SELECT DISTINCT
                    CONCAT(DE.Course_Code, ''-'', DE.Department_Name) AS ProgrammeName,
                    DE.Department_Id
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
                    (NA.Department_Id = @Program OR @Program = 0) AND
                    (CPD.active = @studentstatus OR @studentstatus = 0) AND
                    (@studenttype = '''' OR TypeOfStudent = @studenttype) AND
                    (SPO.sponsorid = @Sponsor OR @Sponsor = 0) AND
                    billoutstanding != 0 AND
                    (
                        (billoutstanding >= @Outstandingfrom AND billoutstanding < @OutstandingTo) OR
                        (@Outstandingfrom = 0 AND @OutstandingTo = 0) OR
                        (@Outstandingfrom = 0 AND billoutstanding < @OutstandingTo) OR
                        (@OutstandingTo = 0 AND billoutstanding >= @Outstandingfrom)
                    ) AND
                    (DE.Department_Id IS NOT NULL AND DE.Department_Id != 0)
                ORDER BY CONCAT(DE.Course_Code, ''-'', DE.Department_Name)
            END

            -- FLAG 2: Students with Outstanding by Program
            IF (@flag = 2)
            BEGIN
                SELECT DISTINCT
                    CPD.Candidate_Id,
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname, ''('', AdharNumber, '')'', ''Outstanding:'', billoutstanding) AS studentname,
                    NA.Department_Id,
                    CONCAT(DE.Course_Code, ''-'', DE.Department_Name) AS ProgrammeName,
                    IM.intake_no AS Batch_Code
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
                    (NA.Batch_Id = @Intake OR @Intake = 0) AND
                    (NA.Department_Id = @Program OR @Program = 0) AND
                    (CPD.active = @studentstatus OR @studentstatus = 0) AND
                    (@studenttype = '''' OR TypeOfStudent = @studenttype) AND
                    (SPO.sponsorid = @Sponsor OR @Sponsor = 0) AND
                    billoutstanding != 0 AND
                    (
                        (billoutstanding >= @Outstandingfrom AND billoutstanding < @OutstandingTo) OR
                        (@Outstandingfrom = 0 AND @OutstandingTo = 0) OR
                        (@Outstandingfrom = 0 AND billoutstanding < @OutstandingTo) OR
                        (@OutstandingTo = 0 AND billoutstanding >= @Outstandingfrom)
                    ) AND
                    NA.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@deptIds, '',''))
                ORDER BY CPD.Candidate_Id
            END

            -- FLAG 3: Students Outstanding Summary
            IF (@flag = 3)
            BEGIN
                SELECT
                    billoutstanding,
                    CPD.Candidate_Id,
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname, ''('', AdharNumber, '')'', ''Outstanding:'', billoutstanding) AS studentname
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
                    (NA.Batch_Id = @Intake OR @Intake = 0) AND
                    (NA.Department_Id = @Program OR @Program = 0) AND
                    (CPD.active = @studentstatus OR @studentstatus = 0) AND
                    (@studenttype = '''' OR TypeOfStudent = @studenttype) AND
                    (SPO.sponsorid = @Sponsor OR @Sponsor = 0) AND
                    billoutstanding != 0 AND
                    (
                        (billoutstanding >= @Outstandingfrom AND billoutstanding < @OutstandingTo) OR
                        (@Outstandingfrom = 0 AND @OutstandingTo = 0) OR
                        (@Outstandingfrom = 0 AND billoutstanding < @OutstandingTo) OR
                        (@OutstandingTo = 0 AND billoutstanding >= @Outstandingfrom)
                    )
            END
        END
    ')
END

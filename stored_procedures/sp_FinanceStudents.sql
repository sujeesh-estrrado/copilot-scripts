IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_FilterStudent_Intake_Program_Faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_FilterStudent_Intake_Program_Faculty]
        (
            @IntakeId VARCHAR(MAX) = '''',
            @PgmID VARCHAR(MAX) = '''',
            @FacultyId BIGINT = 0,
            @PageSize BIGINT = 10,
            @CurrentPage BIGINT = 1,
            @flag BIGINT = 0
        )
        AS
        BEGIN
            -- Flag 0: Default Case
            IF (@flag = 0)
            BEGIN
                SELECT DISTINCT  
                    Pd.Candidate_Id,
                    Pd.Candidate_Id AS ID,
                    CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, 
                    Pd.AdharNumber,
                    Pd.IDMatrixNo,
                    bd.Batch_Code,
                    bd.Batch_Id AS IntakeID,
                    D.Department_Name,
                    D.Department_Id AS ProgrammeID,
                    D.GraduationTypeId AS FacultyID
                FROM dbo.Tbl_Course_Duration_PeriodDetails AS cd
                LEFT OUTER JOIN dbo.tbl_New_Admission AS Ad ON Ad.Batch_Id = cd.Batch_Id
                LEFT OUTER JOIN dbo.Tbl_Candidate_Personal_Det AS Pd ON Pd.New_Admission_Id = Ad.New_Admission_Id
                LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id
                LEFT OUTER JOIN dbo.Tbl_IntakeMaster AS IM ON IM.id = bd.IntakeMasterID
                LEFT OUTER JOIN dbo.Tbl_Department AS D ON D.Department_Id = Ad.Department_Id
                WHERE 
                    (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''') AND
                    (Ad.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) OR @PgmID = '''') AND
                    (Ad.Course_Level_Id = @FacultyId OR @FacultyId = 0)
                ORDER BY ID
            END

            -- Flag 1: Same as Flag 0 with possible future modifications
            ELSE IF (@flag = 1)
            BEGIN
                SELECT DISTINCT  
                    Pd.Candidate_Id,
                    Pd.Candidate_Id AS ID,
                    CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, 
                    Pd.AdharNumber,
                    Pd.IDMatrixNo,
                    bd.Batch_Code,
                    bd.Batch_Id AS IntakeID,
                    D.Department_Name,
                    D.Department_Id AS ProgrammeID,
                    D.GraduationTypeId AS FacultyID
                FROM dbo.Tbl_Course_Duration_PeriodDetails AS cd
                LEFT OUTER JOIN dbo.tbl_New_Admission AS Ad ON Ad.Batch_Id = cd.Batch_Id
                LEFT OUTER JOIN dbo.Tbl_Candidate_Personal_Det AS Pd ON Pd.New_Admission_Id = Ad.New_Admission_Id
                LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id
                LEFT OUTER JOIN dbo.Tbl_IntakeMaster AS IM ON IM.id = bd.IntakeMasterID
                LEFT OUTER JOIN dbo.Tbl_Department AS D ON D.Department_Id = Ad.Department_Id
                WHERE 
                    (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''') AND
                    (Ad.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) OR @PgmID = '''') AND
                    (Ad.Course_Level_Id = @FacultyId OR @FacultyId = 0)
                ORDER BY ID
            END

            -- Flag 2: Advanced Filtering with Row_Number
            ELSE IF (@flag = 2)
            BEGIN
                WITH CandidateRanked AS (
                    SELECT 
                        Pd.Candidate_Id,
                        Pd.Candidate_Id AS ID, 
                        CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, 
                        Pd.AdharNumber, 
                        Pd.IDMatrixNo, 
                        bd.Batch_Code, 
                        bd.Batch_Id AS IntakeID, 
                        D.Department_Name, 
                        D.Department_Id AS ProgrammeID, 
                        D.GraduationTypeId AS FacultyID,
                        ROW_NUMBER() OVER (PARTITION BY Pd.Candidate_Id ORDER BY bd.Batch_Code) AS RowNum
                    FROM dbo.Tbl_Course_Duration_PeriodDetails AS cd
                    LEFT OUTER JOIN dbo.tbl_New_Admission AS Ad ON Ad.Batch_Id = cd.Batch_Id
                    LEFT OUTER JOIN dbo.Tbl_Candidate_Personal_Det AS Pd ON Pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id
                    LEFT OUTER JOIN dbo.Tbl_IntakeMaster AS IM ON IM.id = bd.IntakeMasterID
                    LEFT OUTER JOIN dbo.Tbl_Department AS D ON D.Department_Id = Ad.Department_Id
                    WHERE 
                        (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''') AND
                        (Ad.Course_Level_Id = @FacultyId OR @FacultyId = 0)
                )
                SELECT 
                    Candidate_Id,
                    ID,
                    CandidateName,
                    AdharNumber,
                    IDMatrixNo,
                    Batch_Code,
                    IntakeID,
                    Department_Name,
                    ProgrammeID,
                    FacultyID
                FROM CandidateRanked
                WHERE RowNum = 1
                ORDER BY ID
            END
        END
    ')
END

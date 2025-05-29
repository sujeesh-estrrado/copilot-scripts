IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_ISSO_Stude_Academic]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_ISSO_Stude_Academic]
(
    @Candidate_Id BIGINT,
    @flag BIGINT = 0
)
AS
BEGIN
    IF (@flag = 0)
    BEGIN
        SELECT 
            D.Department_Name,
            CBD.Batch_Code,
            CONCAT(DATEDIFF(MONTH, CDP.Duration_Period_From, CDP.Duration_Period_To), '' '', ''Months'') AS Duration,
            CONVERT(VARCHAR(10), CDP.Duration_Period_From, 23) AS Duration_Period_From,
            CONVERT(VARCHAR(10), CDP.Duration_Period_To, 23) AS Duration_Period_To,
            SS.name AS Status
        FROM 
            Tbl_Candidate_Personal_Det CPD 
            LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
            LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id 
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id 
            LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CBD.Duration_Id
            LEFT JOIN Tbl_Student_status SS ON SS.id = CPD.active
        WHERE 
            CPD.Candidate_Id = @Candidate_Id 
    END
    ELSE IF (@flag = 1)
    BEGIN
        -- Fetch Details for New_Admission_Id (Primary Choice)
        SELECT 
            D.Department_Name,
            CBD.Batch_Code,
            CONCAT(DATEDIFF(MONTH, CDP.Duration_Period_From, CDP.Duration_Period_To), '' '', ''Months'') AS Duration,
            CONVERT(VARCHAR(10), CDP.Duration_Period_From, 23) AS Duration_Period_From,
            CONVERT(VARCHAR(10), CDP.Duration_Period_To, 23) AS Duration_Period_To,
            ''1'' AS Choice
        FROM 
            Tbl_Candidate_Personal_Det CPD 
            LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
            LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id 
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id 
            LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CBD.Duration_Id
        WHERE 
            CPD.Candidate_Id = @Candidate_Id 

        UNION ALL 

        -- Fetch Details for Choice_2 (Only if Choice_2 is NOT NULL and NOT 0)
        SELECT 
            D.Department_Name,
            CBD.Batch_Code,
            CONCAT(DATEDIFF(MONTH, CDP.Duration_Period_From, CDP.Duration_Period_To), '' '', ''Months'') AS Duration,
            CONVERT(VARCHAR(10), CDP.Duration_Period_From, 23) AS Duration_Period_From,
            CONVERT(VARCHAR(10), CDP.Duration_Period_To, 23) AS Duration_Period_To,
            ''2'' AS Choice
        FROM 
            Tbl_Candidate_Personal_Det CPD 
            LEFT JOIN Tbl_New_Admission NA ON CPD.Option2 = NA.New_Admission_Id
            LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id 
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id 
            LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CBD.Duration_Id
        WHERE 
            CPD.Candidate_Id = @Candidate_Id
            AND CPD.Option2 IS NOT NULL 
            AND CPD.Option2 <> 0
            AND NA.New_Admission_Id IS NOT NULL
            AND CPD.ApplicationStatus <> ''Completed''

        UNION ALL 

        -- Fetch Details for Choice_3 (Only if Choice_3 is NOT NULL and NOT 0)
        SELECT 
            D.Department_Name,
            CBD.Batch_Code,
            CONCAT(DATEDIFF(MONTH, CDP.Duration_Period_From, CDP.Duration_Period_To), '' '', ''Months'') AS Duration,
            CONVERT(VARCHAR(10), CDP.Duration_Period_From, 23) AS Duration_Period_From,
            CONVERT(VARCHAR(10), CDP.Duration_Period_To, 23) AS Duration_Period_To,
            ''3'' AS Choice
        FROM 
            Tbl_Candidate_Personal_Det CPD 
            LEFT JOIN Tbl_New_Admission NA ON CPD.Option3 = NA.New_Admission_Id
            LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id 
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id 
            LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CBD.Duration_Id
        WHERE 
            CPD.Candidate_Id = @Candidate_Id
            AND CPD.Option3 IS NOT NULL 
            AND CPD.Option3 <> 0
            AND NA.New_Admission_Id IS NOT NULL
            AND CPD.ApplicationStatus <> ''Completed''
    END
END
');
END;
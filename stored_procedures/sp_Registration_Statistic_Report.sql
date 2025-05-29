IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Registration_Statistic_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Registration_Statistic_Report]
-- [dbo].[sp_Registration_Statistic_Report] 1,1,'''',1,100
(
    @flag INT,
    @FacultyId BIGINT = 0,
    @gender VARCHAR(20) = '''',
    @CurrentPage BIGINT = 0,
    @pagesize BIGINT = 0
)
AS
BEGIN
    IF (@flag = 1)
    BEGIN
        DECLARE @UpperBand INT
        DECLARE @LowerBand INT

        SET @LowerBand = (@CurrentPage - 1) * @PageSize
        SET @UpperBand = (@CurrentPage * @PageSize) + 1 
   
        SELECT * INTO #TEMP1 FROM
        (
            SELECT ROW_NUMBER() OVER (ORDER BY Department_Name DESC) AS slno, BK.*  
            FROM
            (        
                SELECT DISTINCT  
                    Department_Name,
                    CASE 
                        WHEN Race = ''0'' THEN ''''  
                        WHEN Race = ''--Select--'' THEN '''' 
                        ELSE Race 
                    END AS Race,
                    COUNT(Race) AS Racecount,
                    bd.Batch_Code AS Intake,
                    c.Course_Level_Name,
                    (c.Course_Level_Name + '' - '' + Department_Name) AS faculty
                FROM Tbl_Candidate_Personal_Det CP 
                LEFT JOIN [dbo].[tbl_New_Admission] NA ON CP.New_Admission_Id = NA.New_Admission_Id
                LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
                LEFT JOIN Tbl_Course_Level C ON C.Course_Level_Id = NA.Course_Level_Id
                LEFT JOIN Tbl_Course_Batch_Duration bd ON NA.Batch_Id = bd.Batch_Id
                WHERE (NA.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))  
                AND (@FacultyId = 0 OR NA.Course_Level_Id = @FacultyId OR @FacultyId = '''' OR @FacultyId IS NULL) 
                AND (Candidate_Gender IN (''Male'', ''Female'', ''0'', ''Other'')) 
                AND (Candidate_Gender LIKE @gender + ''%'')
                GROUP BY Race, Department_Name, bd.Batch_Code, c.Course_Level_Name
            ) BK
        ) B
        
        SELECT * FROM #TEMP1 
        WHERE slno > @LowerBand AND slno < @UpperBand    
    END
    
    IF (@flag = 2)
    BEGIN
        SELECT * INTO #TEMP2 FROM
        (
            SELECT ROW_NUMBER() OVER (ORDER BY Department_Name DESC) AS slno, BK.*  
            FROM
            (        
                SELECT DISTINCT 
                    Department_Name,
                    Race,
                    COUNT(Race) AS Racecount,
                    bd.Batch_Code AS Intake
                FROM Tbl_Candidate_Personal_Det CP 
                LEFT JOIN [dbo].[tbl_New_Admission] NA ON CP.New_Admission_Id = NA.New_Admission_Id
                LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
                LEFT JOIN Tbl_Course_Level C ON C.Course_Level_Id = NA.Course_Level_Id
                LEFT JOIN Tbl_Course_Batch_Duration bd ON NA.Batch_Id = bd.Batch_Id
                WHERE (NA.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))  
                AND (@FacultyId = 0 OR NA.Course_Level_Id = @FacultyId OR @FacultyId = '''' OR @FacultyId IS NULL) 
                AND (Candidate_Gender IN (''Male'', ''Female'', ''0'', ''Other'')) 
                AND (Candidate_Gender LIKE @gender + ''%'')
                GROUP BY Race, Department_Name, bd.Batch_Code
            ) BK
        ) B
        
        SELECT COUNT(Department_Name) AS totcount FROM #TEMP2
    END          
END
');
END;
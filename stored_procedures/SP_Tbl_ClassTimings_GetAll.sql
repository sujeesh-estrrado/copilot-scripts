IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ClassTimings_GetAll]')
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[SP_Tbl_ClassTimings_GetAll]
(
    @SearchTerm VARCHAR(MAX) = '''',    
    @PageSize BIGINT = 0,    
    @CurrentPage BIGINT = 0,    
    @Flag BIGINT = 0    
)
AS
BEGIN
    IF @Flag = 1 
    BEGIN
        SELECT 
            CT.Customize_ClassTimingId AS ID,
            CT.Hour_Name,
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.Start_Time, 100), 7)) AS Start_Time,
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.End_Time, 100), 7)) AS End_Time,
            D.Department_Name,
            CT.Is_BreakTime
        FROM 
            Tbl_Customize_ClassTiming CT
        INNER JOIN 
            Tbl_Customize_ClassTimingMapping CTM ON CT.Customize_ClassTimingId = CTM.Customize_ClassTimingId
        INNER JOIN 
            Tbl_Department D ON CTM.Department_Id = D.Department_Id
        WHERE 
            CT.ClassTiming_Status = 0
            AND (
                @SearchTerm = '''' OR 
                CT.Hour_Name LIKE ''%'' + @SearchTerm + ''%'' OR
                CT.Start_Time LIKE ''%'' + @SearchTerm + ''%'' OR
                CT.End_Time LIKE ''%'' + @SearchTerm + ''%'' OR
                D.Department_Name LIKE ''%'' + @SearchTerm + ''%'' OR
                (CAST(CT.Is_BreakTime AS NVARCHAR(5)) LIKE ''%'' + @SearchTerm + ''%'')  -- Fixed: Casting BIT to NVARCHAR
            )
        GROUP BY 
            CT.Customize_ClassTimingId, Hour_Name, CT.Start_Time, CT.End_Time, D.Department_Name, CT.Is_BreakTime;
    END

    IF @Flag = 2 
    BEGIN
        SELECT 
            CT.Customize_ClassTimingId AS ID,
            CT.Hour_Name,
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.Start_Time, 100), 7)) AS Start_Time,
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.End_Time, 100), 7)) AS End_Time,
            D.Department_Name,
            CT.Is_BreakTime
        FROM 
            Tbl_Customize_ClassTiming CT
        INNER JOIN 
            Tbl_Customize_ClassTimingMapping CTM ON CT.Customize_ClassTimingId = CTM.Customize_ClassTimingId
        INNER JOIN 
            Tbl_Department D ON CTM.Department_Id = D.Department_Id
        WHERE 
            CT.ClassTiming_Status = 0
            AND (
                @SearchTerm = '''' OR 
                CT.Hour_Name LIKE ''%'' + @SearchTerm + ''%'' OR
                CT.Start_Time LIKE ''%'' + @SearchTerm + ''%'' OR
                CT.End_Time LIKE ''%'' + @SearchTerm + ''%'' OR
                D.Department_Name LIKE ''%'' + @SearchTerm + ''%'' OR
                (CAST(CT.Is_BreakTime AS NVARCHAR(5)) LIKE ''%'' + @SearchTerm + ''%'')  -- Fixed: Casting BIT to NVARCHAR
            )
        GROUP BY 
            CT.Customize_ClassTimingId, Hour_Name, CT.Start_Time, CT.End_Time, D.Department_Name, CT.Is_BreakTime
        ORDER BY 
            CT.Customize_ClassTimingId DESC
        OFFSET @PageSize * (@CurrentPage - 1) ROWS    
        FETCH NEXT @PageSize ROWS ONLY;
    END
     IF @Flag = 0 
    BEGIN
        SELECT 
            CT.Customize_ClassTimingId AS ID,
            CT.Hour_Name,
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.Start_Time, 100), 7)) AS Start_Time,
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.End_Time, 100), 7)) AS End_Time,
            D.Department_Name,
            CT.Is_BreakTime
        FROM 
            Tbl_Customize_ClassTiming CT
        INNER JOIN 
            Tbl_Customize_ClassTimingMapping CTM ON CT.Customize_ClassTimingId = CTM.Customize_ClassTimingId
        INNER JOIN 
            Tbl_Department D ON CTM.Department_Id = D.Department_Id
        WHERE 
            CT.ClassTiming_Status = 0
            AND (
                @SearchTerm = '''' OR 
                CT.Hour_Name LIKE ''%'' + @SearchTerm + ''%'' OR
                CT.Start_Time LIKE ''%'' + @SearchTerm + ''%'' OR
                CT.End_Time LIKE ''%'' + @SearchTerm + ''%'' OR
                D.Department_Name LIKE ''%'' + @SearchTerm + ''%'' OR
                (CAST(CT.Is_BreakTime AS NVARCHAR(5)) LIKE ''%'' + @SearchTerm + ''%'')  -- Fixed: Casting BIT to NVARCHAR
            )
        GROUP BY 
            CT.Customize_ClassTimingId, Hour_Name, CT.Start_Time, CT.End_Time, D.Department_Name, CT.Is_BreakTime
        ORDER BY 
            CT.Customize_ClassTimingId DESC
        OFFSET @PageSize * (@CurrentPage - 1) ROWS    
        FETCH NEXT @PageSize ROWS ONLY;
    END
END;
    ')
END

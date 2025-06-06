IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ClassTimings_ClassTimetable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[SP_Tbl_ClassTimings_ClassTimetable]
    @SearchTerm VARCHAR(MAX) = '''',    
    @PageSize BIGINT = 0,    
    @CurrentPage BIGINT = 0,    
    @Flag BIGINT = 0,
    @Department_Id BIGINT,
    @Batch_Id BIGINT
AS  
BEGIN  
    IF @Flag = 0 
    BEGIN
        ;WITH OrderedClassTimings AS (
            SELECT 
            
                CC.Customize_ClassTimingId AS ID,
                CC.Hour_Name,  
                FORMAT(CC.Start_Time, ''hh:mmtt'') AS Start_Time,  
                FORMAT(CC.End_Time, ''hh:mmtt'') AS End_Time,  
                CC.Is_BreakTime,
                ROW_NUMBER() OVER (PARTITION BY CC.Customize_ClassTimingId ORDER BY CC.Start_Time) AS RowNum
            FROM Tbl_Customize_ClassTiming CC
            INNER JOIN Tbl_Customize_ClassTimingMapping CCM 
                ON CC.Customize_ClassTimingId = CCM.Customize_ClassTimingId
            WHERE CC.ClassTiming_Status = 0 
                AND CCM.Department_Id = @Department_Id
                AND CCM.Batch_Id = @Batch_Id
        )
        SELECT ID, Hour_Name, Start_Time, End_Time, Is_BreakTime
        FROM OrderedClassTimings
        WHERE RowNum = 1
        ORDER BY CAST(Start_Time AS TIME) -- Ensures correct sorting from AM to PM
    END

    IF @Flag = 1 
    BEGIN
        ;WITH OrderedClassTimings AS (
            SELECT 
            

                CC.Customize_ClassTimingId AS ID,
                CC.Hour_Name,  

                FORMAT(CC.Start_Time, ''hh:mmtt'') AS Start_Time,  
                FORMAT(CC.End_Time, ''hh:mmtt'') AS End_Time,  
                CC.Is_BreakTime,
                ROW_NUMBER() OVER (PARTITION BY CC.Customize_ClassTimingId ORDER BY CC.Start_Time) AS RowNum
            FROM Tbl_Customize_ClassTiming CC
            INNER JOIN Tbl_Customize_ClassTimingMapping CCM 
                ON CC.Customize_ClassTimingId = CCM.Customize_ClassTimingId
            WHERE CC.ClassTiming_Status = 0 
                AND CCM.Department_Id = @Department_Id
                AND CCM.Batch_Id = @Batch_Id
        )
        SELECT ID, Hour_Name, Start_Time, End_Time, Is_BreakTime
        FROM OrderedClassTimings
        WHERE RowNum = 1
        ORDER BY CAST(Start_Time AS TIME) -- Ensures correct sorting from AM to PM
    END

    IF @Flag = 2 
    BEGIN
        ;WITH OrderedClassTimings AS (
            SELECT           

                CC.Customize_ClassTimingId AS ID,
                CC.Hour_Name,  
                FORMAT(CC.Start_Time, ''hh:mmtt'') AS Start_Time,  
                FORMAT(CC.End_Time, ''hh:mmtt'') AS End_Time,  
                CC.Is_BreakTime,
                ROW_NUMBER() OVER (PARTITION BY CC.Customize_ClassTimingId ORDER BY CC.Start_Time) AS RowNum
            FROM Tbl_Customize_ClassTiming CC
            INNER JOIN Tbl_Customize_ClassTimingMapping CCM 
                ON CC.Customize_ClassTimingId = CCM.Customize_ClassTimingId
            WHERE CC.ClassTiming_Status = 0 
                AND CCM.Department_Id = @Department_Id
                AND CCM.Batch_Id = @Batch_Id
        )
        SELECT ID, Hour_Name, Start_Time, End_Time, Is_BreakTime
        FROM OrderedClassTimings
        WHERE RowNum = 1
        ORDER BY CAST(Start_Time AS TIME) -- Ensures correct sorting from AM to PM
    END
END
    ')
END

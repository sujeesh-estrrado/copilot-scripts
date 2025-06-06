IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ClassTimings_GetAll_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_ClassTimings_GetAll_Report]
 @Employee_Id BIGINT
AS
BEGIN
 WITH DistinctValues AS (
    SELECT DISTINCT  
        CT.Customize_ClassTimingId AS ID,
        CT.Hour_Name AS Hour_Name,  
        FORMAT(CT.Start_Time, ''hh:mm tt'') AS Start_Time,  
        FORMAT(CT.End_Time, ''hh:mm tt'') AS End_Time
    FROM 
        Tbl_Class_TimeTable CTT
        INNER JOIN Tbl_Customize_ClassTiming CT ON CT.Customize_ClassTimingId = CTT.Class_Timings_Id
        INNER JOIN Tbl_Customize_ClassTimingMapping CTM ON CT.Customize_ClassTimingId = CTM.Customize_ClassTimingId
    WHERE 
        CTT.Employee_Id = @Employee_Id
        AND CTT.Del_Status = 0
),
MergedStatus AS (
    SELECT 
        ID,
        MAX(Merged_Status) AS Merged_Status  
    FROM (
        SELECT DISTINCT CTT.Class_Timings_Id AS ID, CAST(CTT.Merged_Status AS VARCHAR(10)) AS Merged_Status
        FROM Tbl_Class_TimeTable CTT
        WHERE CTT.Employee_Id = @Employee_Id AND CTT.Del_Status = 0
    ) AS DistinctMerged
    GROUP BY ID
)
SELECT 
    STRING_AGG(CAST(DV.ID AS VARCHAR(10)), '', '') WITHIN GROUP (ORDER BY DV.Start_Time ASC) AS ID,  
    STRING_AGG(DV.Hour_Name, '', '') WITHIN GROUP (ORDER BY DV.Start_Time ASC) AS Hour_Name,
    DV.Start_Time,
    DV.End_Time,
    MAX(MS.Merged_Status) AS Merged_Status  
FROM 
    DistinctValues DV
    LEFT JOIN MergedStatus MS ON DV.ID = MS.ID
GROUP BY 
    DV.Start_Time, 
    DV.End_Time
ORDER BY 
    CONVERT(DATETIME, DV.Start_Time, 120) ASC;

END;
    ')
END

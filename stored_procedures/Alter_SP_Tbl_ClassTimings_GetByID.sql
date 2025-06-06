IF EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ClassTimings_GetByID]')
    AND type = N'P'
)
BEGIN
    EXEC('
        ALTER procedure [dbo].[SP_Tbl_ClassTimings_GetByID](@Class_Timings_Id bigint)  
AS  
BEGIN  
SELECT 
    CT.Customize_ClassTimingId as ID,
    Hour_Name,
    LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.Start_Time, 100), 7)) AS Start_Time,
    LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.End_Time, 100), 7)) AS End_Time,
    D.Department_Id   AS  Course_Department_Id,
    D.Department_Name AS  Course_Department_Name,
    CTM.Batch_Id      AS  Duration_Mapping_Id,
    CT.Is_BreakTime, 
    STRING_AGG(CTM.Days_Id, ''-'') AS Days_Id,   
    CTM.Group_Name AS Days
FROM 
    Tbl_Customize_ClassTiming CT
INNER JOIN 
    Tbl_Customize_ClassTimingMapping CTM ON CT.Customize_ClassTimingId = CTM.Customize_ClassTimingId
INNER JOIN 
    Tbl_Department D ON CTM.Department_Id = D.Department_Id
WHERE 
    CT.Customize_ClassTimingId = @Class_Timings_Id AND ClassTiming_Status = 0 
GROUP BY 
    CT.Customize_ClassTimingId, Hour_Name, CT.Start_Time, CT.End_Time, D.Department_Name, CTM.Group_Id, CTM.Group_Name, CTM.Batch_Id, D.Department_Id, CT.Is_BreakTime
    

END
    ')
END

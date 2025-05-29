IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[M_slot_DDL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[M_slot_DDL] 
    @courseid INT = 0,
    @flag BIGINT,
    @scheduleid INT = 0
AS    
BEGIN 
    IF @flag = 0
    BEGIN
SELECT 
    s.Id,
    s.CourseId, 
    s.MaxAllocation, 
    s.TimeLine_FromDate, 
    s.TimeLine_EndDate,
    CourseDate = CASE 
        WHEN s.selectiontype = 1 THEN 
            CONCAT(
                CONVERT(VARCHAR, s.TimeLine_FromDate, 103), 
                '' - '', 
                CONVERT(VARCHAR, s.TimeLine_EndDate, 103)
            )
        WHEN s.selectiontype = 0 THEN 
            CONCAT(
                CONVERT(VARCHAR, MIN(sm.Date), 103), 
                '' - '', 
                CONVERT(VARCHAR, MAX(sm.Date), 103)
            )
        ELSE NULL
    END,
    Duration = CASE
        WHEN s.selectiontype = 1 THEN dbo.GetBusinessDaysCount(s.TimeLine_FromDate, s.TimeLine_EndDate) + 1
        WHEN s.selectiontype = 0 THEN dbo.GetBusinessDaysCount(MIN(sm.Date), MAX(sm.Date)) + 1
        ELSE NULL
    END,
    SlotCount = ISNULL(mc.SlotCount, 0)
FROM 
    Tbl_Schedule_Planning AS s
LEFT JOIN Tbl_Schedule_DayWise_Selection AS sm ON s.Id = sm.ScheduleId
OUTER APPLY (
    SELECT COUNT(*) AS SlotCount
    FROM Tbl_Modular_Candidate_Details md
    WHERE md.Modular_Slot_Id = s.Id 
      AND md.Modular_Course_Id = s.CourseId 
      AND md.Delete_Status = 0
) AS mc
WHERE 
    s.CourseId = @courseid 
    AND s.Isdeleted = 0
    AND ISNULL(mc.SlotCount, 0) < s.MaxAllocation
GROUP BY 
    s.Id, s.CourseId, s.MaxAllocation, s.TimeLine_FromDate, 
    s.TimeLine_EndDate, s.selectiontype, mc.SlotCount


    END 

    ELSE IF @flag = 1
    BEGIN
     SELECT  
    MC.FeeHeading,
    MC.ModularCourseFee
FROM Tbl_ModularCourseMapFee MC
WHERE MC.ModularCourseID = @courseid
AND MC.Ischecked=1
ORDER BY 
    CASE WHEN MC.FeeHeading = ''CourseFee'' THEN 0 ELSE 1 END,
    MC.FeeHeading 
    END 

    ELSE IF @flag = 2
    BEGIN
        SELECT 
            s.Id,
            Duration = CASE
                WHEN s.selectiontype = 1 THEN dbo.GetBusinessDaysCount(s.TimeLine_FromDate, s.TimeLine_EndDate)
                WHEN s.selectiontype = 0 THEN dbo.GetBusinessDaysCount(MIN(sm.Date), MAX(sm.Date))
                ELSE NULL
            END
        FROM 
            Tbl_Schedule_Planning AS s
        LEFT JOIN Tbl_Schedule_DayWise_Selection AS sm ON s.Id = sm.ScheduleId
        WHERE 
            s.Id = @scheduleid
            AND s.Isdeleted = 0
        GROUP BY 
            s.Id, s.selectiontype, s.TimeLine_FromDate, s.TimeLine_EndDate
    END
END
    ')
END;

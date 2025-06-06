IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[M_slots]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[M_slots] 
    @courseid INT = 0,
    @flag BIGINT,
    @Modularid INT = 0,
    @scheduleid INT = 0
AS    
BEGIN 
    IF @flag = 10
    BEGIN
        -- Add a column to indicate if this is the candidate''s selected slot
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
            IsSelectedSlot = CASE WHEN EXISTS (
                SELECT 1 FROM Tbl_Modular_Candidate_Details 
                WHERE   Modular_Candidate_Id  = @Modularid
            ) THEN 1 ELSE 0 END
        FROM 
            Tbl_Schedule_Planning AS s
        LEFT JOIN Tbl_Schedule_DayWise_Selection AS sm ON s.Id = sm.ScheduleId
        WHERE 
            s.CourseId = @courseid 
            AND s.Isdeleted = 0
        GROUP BY 
            s.Id, s.CourseId, s.MaxAllocation, s.TimeLine_FromDate, 
            s.TimeLine_EndDate, s.selectiontype
        ORDER BY IsSelectedSlot DESC  
    END 
END
   ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Scheduled_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Modular_Scheduled_List]         
(        
    @Flag INT = 0,        
    @SearchTerm VARCHAR(MAX) = '''',        
    @CurrentPage BIGINT = 0,        
    @PageSize BIGINT = 0,
    @CourseId BIGINT
)        
AS        
BEGIN        
    DECLARE @TotalRecords INT;
     
    SELECT 
        @TotalRecords = COUNT(DISTINCT SP.ID)
    FROM tbl_Modular_Courses MC
    LEFT JOIN Tbl_Schedule_Planning SP ON MC.Id = SP.CourseId
    LEFT JOIN Tbl_Schedule_DayWise_Selection SDS ON SP.Id = SDS.ScheduleId
    WHERE
        MC.Isdeleted = 0
        AND SP.Isdeleted = 0
        AND SP.CourseId = @CourseId
      ;

    WITH RankedCourses AS (
        SELECT 
            SP.Id AS ScheduleId,
            MC.ID AS CourseId,
            MC.CourseName,
            MC.CourseCode,
            SP.MaxAllocation, 
            CASE 
               WHEN SP.SelectionTYPE = 1 THEN CONVERT(DATE, SP.Timeline_FromDate)
               ELSE CONVERT(DATE, MIN(SDS.Date))
            END AS FromDate,
            CASE 
               WHEN SP.SelectionTYPE = 1 THEN CONVERT(DATE, SP.Timeline_EndDate)
               ELSE CONVERT(DATE, MAX(SDS.Date))
            END AS ToDate,
            CASE 
               WHEN SP.SelectionTYPE = 1 
                    THEN dbo.GetBusinessDaysCount(SP.Timeline_FromDate, SP.Timeline_EndDate)
               ELSE dbo.GetBusinessDaysCount(MIN(SDS.Date), MAX(SDS.Date))
            END AS Duration,
            ROW_NUMBER() OVER (ORDER BY SP.Id DESC) AS RowNum
        FROM tbl_Modular_Courses MC
        LEFT JOIN Tbl_Schedule_Planning SP ON MC.Id = SP.CourseId
        LEFT JOIN Tbl_Schedule_DayWise_Selection SDS ON SP.Id = SDS.ScheduleId
        WHERE
            MC.Isdeleted = 0
            AND SP.Isdeleted = 0
            AND SP.CourseId = @CourseId
            
        GROUP BY 
            SP.Id, 
            MC.ID, 
            MC.CourseName, 
            MC.CourseCode, 
            SP.MaxAllocation, 
            SP.Timeline_FromDate, 
            SP.Timeline_EndDate, 
            SP.SelectionTYPE
    )

    SELECT 
        ScheduleId,
        CourseId,
        CourseName,
        CourseCode,
        MaxAllocation,
        FromDate,
        ToDate,
        Duration,
        RowNum,
        @TotalRecords AS TotalRecords
    FROM RankedCourses

END
    ')
END;

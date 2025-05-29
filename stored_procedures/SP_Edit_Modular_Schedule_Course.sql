IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Edit_Modular_Schedule_Course]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Edit_Modular_Schedule_Course]
( 
    @ScheduleId BIGINT
)
AS
BEGIN

SELECT 
MC.Id AS CourseId,
MC.CourseName,
MC.CourseCode,
SP.MaxAllocation,
SP.SelectionType,
SP.TimeLine_FromDate,
SP.TimeLine_EndDate,
SP.TimeLine_StartTime,
SP.TimeLine_EndTime,
SDS.Date,
SDS.EndTime,
SDS.StartTime
FROM
tbl_Modular_Courses MC
LEFT JOIN Tbl_Schedule_Planning SP ON MC.Id =SP.CourseId
LEFT JOIN Tbl_Schedule_DayWise_Selection SDS ON SP.Id=SDS.ScheduleId AND SDS.IsDeleted=0
WHERE
MC.Isdeleted=0
AND SP.Isdeleted=0 
AND SP.ID=@ScheduleId

END
    ')
END;

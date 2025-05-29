IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[M_COURSE_DDL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[M_COURSE_DDL]
@ModularId BIGINT
AS    
BEGIN 

  WITH ActiveSchedules AS (
    SELECT 
        CourseId,
        Id AS ScheduleId,
        MaxAllocation
    FROM Tbl_Schedule_Planning
    WHERE Isdeleted = 0
),
CandidateCountBySchedule AS (
    SELECT 
        MCD.Modular_Slot_Id,
        COUNT(*) AS TotalCandidates
    FROM Tbl_Modular_Candidate_Details MCD
    WHERE MCD.Delete_Status = 0 AND MCD.ActivatedStatus=1
    GROUP BY MCD.Modular_Slot_Id
),
CoursesWithAvailableSlots AS (
    SELECT DISTINCT
        MC.Id AS CourseId
    FROM tbl_Modular_Courses MC
    INNER JOIN ActiveSchedules ASch ON MC.Id = ASch.CourseId
    LEFT JOIN CandidateCountBySchedule CC ON ASch.ScheduleId = CC.Modular_Slot_Id
    WHERE 
        MC.Isdeleted = 0
        AND (CC.TotalCandidates IS NULL OR CC.TotalCandidates < ASch.MaxAllocation)
)
SELECT 
    MC.Id,
    MC.CourseName,
    MC.CourseCode
FROM tbl_Modular_Courses MC
INNER JOIN CoursesWithAvailableSlots CA ON MC.Id = CA.CourseId
WHERE MC.Isdeleted = 0
ORDER BY MC.Id



 
END
    ')
END;

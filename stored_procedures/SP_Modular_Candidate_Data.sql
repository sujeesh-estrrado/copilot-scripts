IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Candidate_Data]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Modular_Candidate_Data]         
(         
    @Candidate_Id BIGINT,
    @SlotId BIGINT
)        
AS        
BEGIN        
    
 SELECT  
    MCD.Modular_Candidate_Id,
    MCD.Modular_Course_Id,
    MCD.Modular_Slot_Id,
    MC.CourseName,
    MC.CourseCode, 
    MCD.Application_Status,
    CASE 
        WHEN SP.SelectionTYPE = 1 THEN CONVERT(DATE, SP.Timeline_FromDate)
        ELSE CONVERT(DATE, MIN(SDS.Date))
    END AS FromDate,
    CASE 
        WHEN SP.SelectionTYPE = 1 THEN CONVERT(DATE, SP.Timeline_EndDate)
        ELSE CONVERT(DATE, MAX(SDS.Date))
    END AS ToDate,
    MCD.Status AS Modular_Course_Status
FROM tbl_Modular_Courses MC
LEFT JOIN Tbl_Schedule_Planning SP ON MC.Id = SP.CourseId
LEFT JOIN Tbl_Schedule_DayWise_Selection SDS ON SP.Id = SDS.ScheduleId
LEFT JOIN Tbl_Modular_Candidate_Details MCD ON MC.Id = MCD.Modular_Course_Id 
WHERE
    MC.Isdeleted = 0
    AND SP.Isdeleted = 0
    AND MCD.Delete_Status = 0
    AND MCD.Modular_Candidate_Id = @Candidate_Id          
    AND MCD.Modular_Slot_Id = @SlotId
GROUP BY 
    MCD.Modular_Candidate_Id,
    MCD.Modular_Course_Id,
    MCD.Modular_Slot_Id,
    MC.CourseName,
    MC.CourseCode,
    MCD.Application_Status,
    SP.SelectionTYPE,
    SP.Timeline_FromDate,
    SP.Timeline_EndDate,
    MCD.Status


END
    ')
END;

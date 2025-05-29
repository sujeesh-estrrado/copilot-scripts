IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Modular_Status_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Modular_Status_Update] 
@status varchar(50) ='''',
@modularid int = '''',
@flag int = ''''
as
begin
if (@flag=0)
update Tbl_Modular_Candidate_Details set Status=@status where Modular_Candidate_Id=@modularid
end
begin
if (@flag=1)
update Tbl_Modular_Candidate_Details set Status=3 where Modular_Candidate_Id=@modularid
 --SELECT SCOPE_IDENTITY();
end
begin
if (@flag=2)
update Tbl_Modular_Candidate_Details set Status=2 where Modular_Candidate_Id=@modularid
end

begin
if (@flag=3)
select Candidate_Id as candidateid from Tbl_Modular_Candidate_Details where Modular_Candidate_Id=@modularid
end
begin
if (@flag=4)
SELECT 
m.Modular_Candidate_Id,
    mc.CourseName,
    mc.CourseCode,
    m.status,
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
    END
FROM Tbl_Modular_Candidate_Details AS m
LEFT JOIN tbl_Modular_Courses AS mc ON mc.Id = m.Modular_Course_Id
LEFT JOIN Tbl_Schedule_Planning AS s ON s.Id = m.Modular_Slot_Id
LEFT JOIN Tbl_Schedule_DayWise_Selection AS sm ON s.Id = sm.ScheduleId
WHERE m.Candidate_Id = @modularid
GROUP BY
m.Modular_Candidate_Id,
    mc.CourseName,
    mc.CourseCode,
    m.status,
    s.TimeLine_FromDate,
    s.TimeLine_EndDate,
    s.selectiontype
end
    ')
END;

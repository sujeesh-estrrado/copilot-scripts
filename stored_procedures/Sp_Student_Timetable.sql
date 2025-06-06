IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Student_Timetable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Student_Timetable]
@Candidate_Id BIGINT = 0
AS
BEGIN
    DECLARE @TodayWeekDayID INT = DATEPART(WEEKDAY, GETDATE());

    -- Table to store timetable data
    DECLARE @Timetable TABLE (
        Subject NVARCHAR(255),
        Time NVARCHAR(50),
        Start_Time TIME,
        End_Time TIME,
        WeekDayID INT,
        Day NVARCHAR(50) -- Stores weekday name
    );

    -- Insert timetable data (All days including today and future days)
    INSERT INTO @Timetable
    SELECT DISTINCT 
        S.Course_Name AS Subject,
        FORMAT(CCT.Start_Time, ''hh:mm tt'') + '' to '' + FORMAT(CCT.End_Time, ''hh:mm tt'') AS Time,
        CCT.Start_Time,
        CCT.End_Time,
        WS.WeekDay_Settings_Id,
        WS.WeekDay_Name 
    FROM    
        Tbl_Candidate_Personal_Det CPD
        INNER JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
        INNER JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=NA.Batch_Id
        INNER JOIN Tbl_Course_Duration_PeriodDetails CDP on CDP.Batch_Id=CBD.Batch_Id
        INNER JOIN Tbl_Class_TimeTable CT ON CT.Duration_Mapping_Id = CDP.Duration_Period_Id
        INNER JOIN Tbl_New_Course S ON S.Course_Id = CT.Semster_Subject_Id 
        INNER JOIN Tbl_Customize_ClassTiming CCT ON CCT.Customize_ClassTimingId = CT.Class_Timings_Id
        INNER JOIN Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = CT.Day_Id
       -- INNER JOIN Tbl_Student_Absence SA ON CPD.Candidate_Id = SA.Candidate_Id 
            --AND SA.Duration_Mapping_Id = CT.Duration_Mapping_Id
    WHERE 
        CPD.Candidate_Id = @Candidate_Id and
        CT.Del_Status=0

    -- Fetch timetable with proper ordering
    SELECT 
        Subject,
        Time,
        Day
    FROM @Timetable
    ORDER BY 
        -- Priority 1: Today''s Remaining Classes First
        CASE 
            WHEN WeekDayID = @TodayWeekDayID - 1 AND End_Time > CAST(GETDATE() AS TIME) THEN 0
            ELSE 1
        END,  
        -- Priority 2: Order by Next Available Days (Handles Sunday to Monday transition)
        CASE 
            WHEN WeekDayID < @TodayWeekDayID-1 THEN WeekDayID + 7  -- Ensures Monday comes after Sunday
            ELSE WeekDayID
        END,
        -- Priority 3: Order by Start Time
        Start_Time;
END;
    ')
END

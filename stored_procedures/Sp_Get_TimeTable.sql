IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_TimeTable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_TimeTable]
            @Employee_Id INT = NULL
        AS
        BEGIN
            DECLARE @TodayWeekDayID INT = DATEPART(WEEKDAY, GETDATE());

            -- Temporary table to store timetable data
            DECLARE @Timetable TABLE (
                Subject NVARCHAR(255),
                Time NVARCHAR(50),
                Start_Time TIME,
                End_Time TIME,
                WeekDayID INT,
                Day NVARCHAR(50)
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
            FROM Tbl_Class_TimeTable CT
            INNER JOIN Tbl_Employee E ON E.Employee_Id = CT.Employee_Id
            INNER JOIN Tbl_New_Course S ON S.Course_Id = CT.Semster_Subject_Id 
            INNER JOIN Tbl_Customize_ClassTiming CCT ON CCT.Customize_ClassTimingId = CT.Class_Timings_Id
            INNER JOIN Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = CT.Day_Id
            WHERE 
                CT.Employee_Id = @Employee_Id 
                AND CT.Del_Status = 0;

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
                -- Priority 2: Next Available Days (Sunday to Monday transition)
                CASE 
                    WHEN WeekDayID < @TodayWeekDayID THEN WeekDayID + 7
                    ELSE WeekDayID
                END,
                -- Priority 3: Start Time
                Start_Time;
        END;
    ')
END

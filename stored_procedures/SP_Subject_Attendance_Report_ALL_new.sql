IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Subject_Attendance_Report_ALL_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Subject_Attendance_Report_ALL_new] 
        (@SemesterSubjectId bigint, @Fromdate datetime, @Todate datetime, @Duration_Mapping_Id bigint)
        AS
        BEGIN
            INSERT INTO TBL_attendance1 ([date], [datetype])
            SELECT Student_Holiday_FromDate AS date, ''holiday'' AS datetype
            FROM dbo.Tbl_Student_Holidays
            WHERE Student_Holiday_FromDate NOT IN 
            (SELECT Absent_Date FROM dbo.Tbl_Student_Absence WHERE Absent_Date >= @FromDate AND Absent_Date <= @Todate) 
            AND Student_Holiday_FromDate >= @FromDate AND Student_Holiday_FromDate <= @Todate
            
            UNION
            
            SELECT Absent_Date AS date, ''Normal'' AS datetype
            FROM Tbl_Student_Absence
            WHERE Absent_Date >= @FromDate AND Absent_Date <= @Todate

            INSERT INTO TBL_attendance2
            (Class_Timings_Id, [Candidate_Id], [CandidateName], [AdharNumber], [Intake], [Semester_Code], [Department_Name],
            [Duration_Mapping_Id], [Subject_Id], [Department_Id], [Semester_Subject_Id], [Subject_Name], [Absent_Type], 
            [Study_Mode], [TypeOfStudent], [AbsentType], [Absent_Date], [Weekday_Code], [ClassTimings])
            SELECT DISTINCT
                CT.Class_Timings_Id,
                CPD.Candidate_Id,
                CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS [CandidateName],
                CPD.AdharNumber,
                D.Course_Code + '' '' + CBD.Batch_Code AS Intake,
                CS.Semester_Code,
                D.Department_Name,
                CDM.Duration_Mapping_Id,
                S.Subject_Id,
                D.Department_Id,
                SS.Semester_Subject_Id,
                S.Subject_Name,
                SA.Absent_Type,
                CBD.Study_Mode,
                TypeOfStudent,
                CASE SA.Absent_Type
                    WHEN ''absent'' THEN ''N''
                    ELSE ''Y''
                END AS AbsentType,
                CONVERT(varchar(50), SA.Absent_Date, 103) AS Absent_Date,
                DATENAME(weekday, Absent_Date) AS Weekday_Code,
                (SELECT Hour_Name + ''-'' + CONVERT(char(5), Start_Time, 108) + ''-'' + CONVERT(char(5), End_Time, 108)
                 FROM dbo.Tbl_ClassTimings
                 WHERE Class_Timings_Id = SA.Class_Timings_Id) AS ClassTimings
            FROM dbo.Tbl_Semester_Subjects SS
            INNER JOIN dbo.Tbl_Department_Subjects DS ON DS.Department_Subject_Id = SS.Department_Subjects_Id
            INNER JOIN dbo.Tbl_Subject S ON S.Subject_Id = DS.Subject_Id
            INNER JOIN dbo.Tbl_Student_Subject_Child SSC ON SSC.Subject_Id = S.Subject_Id
            INNER JOIN dbo.Tbl_Student_Subject_Master SSM ON SSM.Student_Subject_Map_Master = SSC.Student_Subject_Map_Master
            INNER JOIN dbo.Tbl_Student_Semester SSe ON SSe.Candidate_Id = SSM.Candidate_Id AND SSe.Student_Semester_Current_Status = 1
            INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SSM.Candidate_Id
            INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = SSM.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CDM.Duration_Period_Id
            INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id
            INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id
            INNER JOIN dbo.Tbl_Department D ON D.Department_Id = SSM.Department_Id
            INNER JOIN dbo.Tbl_Class_TimeTable CT ON CT.Duration_Mapping_Id = CDM.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_WeekDay_Batch_Mapping WBM ON WBM.WeekDay_Batch_Mapping_Id = CT.WeekDay_Settings_Id
            INNER JOIN dbo.Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = WBM.WeekDay_Settings_Id
            INNER JOIN dbo.Tbl_Student_Absence SA ON SA.Candidate_Id = CPD.Candidate_Id
            AND SA.Class_Timings_Id = CT.Class_Timings_Id AND S.Subject_Id = SA.Subject_Id
            WHERE SS.Semester_Subject_Id = @SemesterSubjectId AND CDM.Duration_Mapping_Id = @Duration_Mapping_Id
            AND SA.Absent_Date BETWEEN @FromDate AND @Todate

            SELECT * FROM TBL_attendance2

            SELECT Class_Timings_Id, Absent_Date, WeekDay_Code, ClassTimings
            FROM (
                SELECT DISTINCT Class_Timings_Id, Absent_Date, WeekDay_Code, ClassTimings
                FROM TBL_attendance2
                UNION
                SELECT DISTINCT 0 AS Class_Timings_Id, CONVERT(varchar(50), date, 103) AS date, DATENAME(weekday, date) AS Weekday_Code, ''holiday'' AS ClassTimings
                FROM TBL_attendance1 WHERE datetype = ''holiday''
            ) ad
            ORDER BY Absent_Date, ad.ClassTimings

            SELECT DISTINCT Candidate_Id, CandidateName, AdharNumber, Study_Mode, Intake FROM TBL_attendance2

            INSERT INTO A (totalpossibleattendance, ClassTimings, Absent_Date)
            SELECT COUNT(AbsentType) AS totalpossibleattendance, ClassTimings, Absent_Date
            FROM TBL_attendance2
            GROUP BY ClassTimings, Absent_Date

            INSERT INTO B ([totalpresent], ClassTimings, Absent_Date)
            SELECT ISNULL(COUNT(AbsentType), 0) AS totalpresent, ClassTimings, Absent_Date
            FROM TBL_attendance2 WHERE AbsentType = ''Y''
            GROUP BY ClassTimings, Absent_Date

            SELECT A.totalpossibleattendance, B.totalpresent, A.ClassTimings, A.Absent_Date,
            ISNULL((A.totalpossibleattendance - B.totalpresent), A.totalpossibleattendance) AS totalabsence
            FROM A
            LEFT JOIN B ON A.ClassTimings = B.ClassTimings AND A.Absent_Date = B.Absent_Date
            LEFT JOIN TBL_attendance1 t2 ON CONVERT(varchar(50), t2.date, 103) = A.Absent_Date

            SELECT CONVERT(varchar(50), date, 103) AS date, datetype FROM TBL_attendance1

            DELETE FROM A
            DELETE FROM B
            DELETE FROM TBL_attendance1
            DELETE FROM TBL_attendance2
        END
    ')
END

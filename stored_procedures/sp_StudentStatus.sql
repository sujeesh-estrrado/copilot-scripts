IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_StudentStatus]
        AS
        BEGIN
            SELECT id, name, active 
            FROM Tbl_Student_status 
            WHERE active = 1
        END
    ')
END


IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentStatus_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_StudentStatus_new]
        AS
        BEGIN
            SELECT id, name, active 
            FROM Tbl_Student_status 
            WHERE active = 1 
            AND (id BETWEEN 2 AND 18 OR id = 45)
        END
    ')
END


IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Subject_Attendance_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Subject_Attendance_Report]
        (
            @SemesterSubjectId BIGINT,                       
            @Fromdate DATETIME, 
            @Todate DATETIME,
            @TypeOfStudent VARCHAR(50),
            @Duration_Mapping_Id BIGINT
        )
        AS 
        BEGIN
            -- Insert holiday data
            INSERT INTO TBL_attendance1 ([date], [datetype]) 
            SELECT Student_Holiday_FromDate AS date, 
                   ''holiday'' AS datetype       
            FROM dbo.Tbl_Student_Holidays 
            WHERE Student_Holiday_FromDate NOT IN 
            (SELECT Absent_Date FROM dbo.Tbl_Student_Absence 
             WHERE Absent_Date >= @FromDate 
               AND Absent_Date <= @Todate) 
               AND Student_Holiday_FromDate >= @FromDate 
               AND Student_Holiday_FromDate <= @Todate
               
            UNION
               
            -- Insert absence data
            SELECT Absent_Date AS date, ''Normal'' AS datetype 
            FROM Tbl_Student_Absence 
            WHERE Absent_Date >= @FromDate 
              AND Absent_Date <= @Todate;
               
            -- Insert attendance data
            INSERT INTO TBL_attendance2 ([Candidate_Id], [CandidateName], [AdharNumber], 
                                         [Intake], [Semester_Code], [Department_Name], 
                                         [Duration_Mapping_Id], [Subject_Id], [Department_Id], 
                                         [Semester_Subject_Id], [Subject_Name], [Absent_Type], 
                                         [Study_Mode], [TypeOfStudent], [AbsentType], [Absent_Date], 
                                         [Weekday_Code], [ClassTimings])
            SELECT DISTINCT  
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
                CONVERT(VARCHAR(50), SA.Absent_Date, 103) AS Absent_Date,
                DATENAME(weekday, Absent_Date) AS Weekday_Code,
                (SELECT Hour_Name + ''-'' + CONVERT(CHAR(5), Start_Time, 108) + ''-'' + 
                        CONVERT(CHAR(5), End_Time, 108) 
                 FROM dbo.Tbl_ClassTimings 
                 WHERE Class_Timings_Id = SA.Class_Timings_Id) AS ClassTimings
            FROM dbo.Tbl_Semester_Subjects SS 
            INNER JOIN dbo.Tbl_Department_Subjects DS 
                ON DS.Department_Subject_Id = SS.Department_Subjects_Id
            INNER JOIN dbo.Tbl_Subject S 
                ON S.Subject_Id = DS.Subject_Id
            INNER JOIN dbo.Tbl_Student_Subject_Child SSC 
                ON SSC.Subject_Id = S.Subject_Id
            INNER JOIN dbo.Tbl_Student_Subject_Master SSM 
                ON SSM.Student_Subject_Map_Master = SSC.Student_Subject_Map_Master
            INNER JOIN dbo.Tbl_Student_Semester SSe 
                ON SSe.Candidate_Id = SSM.Candidate_Id 
                AND SSe.Student_Semester_Current_Status = 1
            INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD 
                ON CPD.Candidate_Id = SSM.Candidate_Id
            INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM 
                ON CDM.Duration_Mapping_Id = SSM.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP 
                ON CDP.Duration_Period_Id = CDM.Duration_Period_Id
            INNER JOIN dbo.Tbl_Course_Batch_Duration CBD 
                ON CBD.Batch_Id = CDP.Batch_Id
            INNER JOIN dbo.Tbl_Course_Semester CS 
                ON CS.Semester_Id = CDP.Semester_Id
            INNER JOIN dbo.Tbl_Department D 
                ON D.Department_Id = SSM.Department_Id
            INNER JOIN dbo.Tbl_Class_TimeTable CT 
                ON CT.Duration_Mapping_Id = CDM.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_WeekDay_Batch_Mapping WBM 
                ON WBM.WeekDay_Batch_Mapping_Id = CT.WeekDay_Settings_Id
            INNER JOIN dbo.Tbl_WeekDay_Settings WS 
                ON WS.WeekDay_Settings_Id = WBM.WeekDay_Settings_Id
            INNER JOIN dbo.Tbl_Student_Absence SA 
                ON SA.Candidate_Id = CPD.Candidate_Id
                AND SA.Class_Timings_Id = CT.Class_Timings_Id 
                AND S.Subject_Id = SA.Subject_Id
                AND SA.Absent_Date >= @FromDate 
                AND SA.Absent_Date <= @Todate
            WHERE SS.Semester_Subject_Id = @SemesterSubjectId    
              AND TypeOfStudent = @TypeOfStudent 
              AND CDM.Duration_Mapping_Id = @Duration_Mapping_Id;
            
            -- Select results from attendance2
            SELECT * FROM TBL_attendance2;

            -- Select attendance data
            SELECT Absent_Date, WeekDay_Code, ClassTimings
            FROM (
                SELECT DISTINCT Absent_Date, WeekDay_Code, ClassTimings 
                FROM TBL_attendance2
                UNION
                SELECT DISTINCT CONVERT(VARCHAR(50), date, 103) AS date,
                                DATENAME(weekday, date) AS Weekday_Code,
                                ''holiday'' AS ClassTimings
                FROM TBL_attendance1 
                WHERE datetype = ''holiday''
            ) ad 
            ORDER BY ClassTimings;

            -- Select candidate details
            SELECT DISTINCT Candidate_Id, CandidateName, AdharNumber, Study_Mode, Intake 
            FROM TBL_attendance2;

            -- Insert total possible attendance
            INSERT INTO A (totalpossibleattendance, ClassTimings, Absent_Date)    
            SELECT COUNT(AbsentType) AS totalpossibleattendance, ClassTimings, Absent_Date  
            FROM TBL_attendance2 
            GROUP BY ClassTimings, Absent_Date;

            -- Insert total present attendance
            INSERT INTO B (totalpresent, ClassTimings, Absent_Date)   
            SELECT ISNULL(COUNT(AbsentType), 0) AS totalpresent, ClassTimings, Absent_Date 
            FROM TBL_attendance2 
            WHERE AbsentType = ''Y''                  
            GROUP BY ClassTimings, Absent_Date;

            -- Select attendance details
            SELECT A.totalpossibleattendance, B.totalpresent, A.ClassTimings, A.Absent_Date,
                   ISNULL((A.totalpossibleattendance - B.totalpresent), A.totalpossibleattendance) AS totalabsence
            FROM A 
            LEFT JOIN B ON A.ClassTimings = B.ClassTimings 
                    AND A.Absent_Date = B.Absent_Date
            LEFT JOIN TBL_attendance1 t2 
                ON CONVERT(VARCHAR(50), t2.date, 103) = A.Absent_Date;

            -- Select holiday data
            SELECT CONVERT(VARCHAR(50), date, 103) AS date, datetype 
            FROM TBL_attendance1;

            -- Clean up
            DELETE FROM A;
            DELETE FROM B;
            DELETE FROM TBL_attendance1;
            DELETE FROM TBL_attendance2;
        END
    ')
END

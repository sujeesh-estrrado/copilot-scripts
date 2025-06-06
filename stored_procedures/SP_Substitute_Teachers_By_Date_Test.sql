IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Substitute_Teachers_By_Date_Test]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Substitute_Teachers_By_Date_Test]
            @From_Date datetime,
            @To_Date datetime
        AS
        BEGIN

            SELECT DISTINCT 
                TS.Teacher_Substituition_Id as ID,
                TS.Week_Day_Id as WeekDay_Settings_Id,
                TS.Class_Timings_Id,
                TS.Employee_In_Leave_Id,
                E.Employee_FName + '' '' + E.Employee_LName as AbsentEmployee,
                EE.Employee_FName + '' '' + EE.Employee_LName as SubstituteEmployee,
                TS.Employee_Substitute_Id,
                TS.Leave_Date,
                WS.WeekDay_Name,
                CT.Hour_Name,
                CBD.Batch_Code + ''/'' + CC.Course_Category_Name + ''/'' + D.Department_Name + ''/'' + CS.Semester_Code as Department

            FROM Tbl_Teacher_Substituition TS
            INNER JOIN Tbl_ClassTimings CT ON CT.Class_Timings_Id = TS.Class_Timings_Id
            LEFT JOIN Tbl_Class_TimeTable CTI ON CTI.Class_Timings_Id = CT.Class_Timings_Id
            INNER JOIN Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = TS.Week_Day_Id
            INNER JOIN Tbl_Employee E ON E.Employee_Id = TS.Employee_In_Leave_Id
            INNER JOIN Tbl_Employee EE ON EE.Employee_Id = TS.Employee_Substitute_Id
            LEFT JOIN Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = CTI.Duration_Mapping_Id
            LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CDM.Duration_Period_Id
            LEFT JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id
            LEFT JOIN Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id
            LEFT JOIN Tbl_Course_Department CD ON CD.Course_Department_Id = CDM.Course_Department_Id
            LEFT JOIN Tbl_Department D ON D.Department_Id = CD.Department_Id
            LEFT JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = CD.Course_Category_Id

            WHERE (TS.Leave_Date BETWEEN @From_Date AND @To_Date)
                AND Class_TimeTable_Status = 0

        END
    ')
END

IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_EmployeeId_By_SemesterSubjectId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_EmployeeId_By_SemesterSubjectId]
        (
            @Semester_Subject_Id BIGINT
        )
        AS
        BEGIN
            SELECT
                SS.Semester_Subject_Id,
                E.Employee_Id,
                E.Employee_FName + '''' + Employee_LName AS [EmployeeName]
            FROM
                Tbl_Subject_Hours_PerWeek SH
            INNER JOIN Tbl_Semester_Subjects SS ON SS.Semester_Subject_Id = SH.Semester_Subject_Id
            INNER JOIN Tbl_Employee E ON E.Employee_Id = SH.Employee_Id
            WHERE
                SS.Semester_Subjects_Status = 0
                AND SS.Semester_Subject_Id = @Semester_Subject_Id
                AND SH.Subject_Hours_PerWeekStatus = 0
        END
    ')
END

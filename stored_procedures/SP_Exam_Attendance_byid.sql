IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Attendance_byid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Exam_Attendance_byid]
            @Attendance_Master_Id BIGINT = 0
        AS
        BEGIN
            SELECT DISTINCT 
                EM.Attendance_Master_Id,
                Attendance_SheetNo,
                CONVERT(VARCHAR(50), EM.Created_Date, 103) AS Created_Date,
                ES.Course_id,
                EXM.Exam_Master_id,
                CONCAT(NC.Course_Name, '' - '', NC.Course_code) AS Coursename,
                CONCAT(E.Employee_Fname, '' '', E.Employee_LName) AS Invigilator,
                D.Department_Id,
                D.Department_Name,
                CBD.Batch_Id,
                CBD.intake_no,
                S.Semester_Id,
                S.Semester_Name,
                CASE 
                    WHEN EM.Approval_Status = 0 THEN ''Submited''
                    WHEN EM.Approval_Status = 1 THEN ''Approved''
                    WHEN EM.Approval_Status = 2 THEN ''Rejected''
                    ELSE ''Pending'' 
                END AS Attendancestatus,
                ChiefInvigilator
            FROM Tbl_Exam_Attendance_Master EM
            INNER JOIN Tbl_Exam_Attendance EA ON EA.Attendance_Master_Id = EM.Attendance_Master_Id
            INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Schedule_Id = EM.Exam_Schedule_Id
            INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Details_Id = EM.Exam_Schedule_Details_Id
            INNER JOIN Tbl_New_Course NC ON NC.Course_Id = ES.Course_id
            INNER JOIN Tbl_Employee E ON E.Employee_Id = EM.Marked_By
            INNER JOIN Tbl_Exam_Master EXM ON EXM.Exam_Master_id = ES.Exam_Master_Id
            LEFT JOIN Tbl_Course_Duration_PeriodDetails CPD ON CPD.Duration_Period_Id = EXM.Duration_Period_id
            INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CPD.Batch_Id 
                AND CBD.Batch_DelStatus = 0 
                AND CPD.Delete_Status = 0
            INNER JOIN Tbl_Department D ON D.Department_Id = CBD.Duration_Id
            INNER JOIN Tbl_Course_Level L ON L.Course_Level_Id = D.GraduationTypeId
            INNER JOIN Tbl_Course_Semester S ON S.Semester_Id = CPD.Semester_Id 
                AND S.Semester_DelStatus = 0
            INNER JOIN Invigilator_Mapping IM ON IM.Exam_Schedule_Details_Id = ESD.Exam_Schedule_Details_Id
            WHERE EM.Attendance_Master_Id = @Attendance_Master_Id
        END
    ')
END

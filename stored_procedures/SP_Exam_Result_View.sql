IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Result_View]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Exam_Result_View] 
        @flag bigint = 0, 
        @Exam_Master_id bigint = 0,  
        @Course_id bigint = 0,  
        @EntryType varchar(Max) = ''R2''
        AS
        BEGIN   
            IF (@flag = 0)  
            BEGIN  
                SELECT DISTINCT 
                    EXM.Exam_Master_Id,
                    EXM.Exam_Name,
                    EXM.Exam_Type,
                    CONCAT(NC.Course_Name, '' '', Course_Code) AS Coursename,  
                    CONVERT(varchar, ES.Exam_Date, 103) AS Exam_Date, 
                    CONCAT(B.Block_Name, '' '', F.Floor_Name, '' '', R.Room_Name) AS Room_Name,
                    ES.Course_id,                                                  
                    CONVERT(varchar(15), CAST(ES.Exam_Time_From AS TIME), 100) AS Exam_Time_From,                                             
                    CONVERT(varchar(15), CAST(ES.Exam_Time_To AS TIME), 100) AS Exam_Time_To,   
                    CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) AS Employeename   
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_New_Course NC ON NC.Course_id = ES.Course_id  
                INNER JOIN Tbl_Employee E ON E.Employee_Id = ESD.ChiefInvigilator  
                INNER JOIN Tbl_Room R ON R.Room_Id = ESD.Venue  
                INNER JOIN Tbl_Block B ON R.Block_Id = B.Block_Id  
                INNER JOIN Tbl_Floor F ON F.Floor_Id = R.Floor_Id             
                WHERE EXM.Exam_Master_id = @Exam_Master_id                
                AND Publish_status = 2     
            END  

            IF (@flag = 1)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT EA.Student_Id), 0) AS totstudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_Exam_Attendance_Master EM ON EM.Exam_Schedule_Id = ES.Exam_Schedule_Id 
                        AND EM.Exam_Schedule_Details_Id = ESD.Exam_Schedule_Details_Id  
                INNER JOIN Tbl_Exam_Attendance EA ON EA.Attendance_Master_Id = EM.Attendance_Master_Id                  
                WHERE EXM.Exam_Master_id = @Exam_Master_id  
                AND ES.Course_id = @Course_id           
                AND EM.Approval_Status = 1 
                AND Publish_status = 2     
            END  

            IF (@flag = 2)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT EA.Student_Id), 0) AS Presentstudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_Exam_Attendance_Master EM ON EM.Exam_Schedule_Id = ES.Exam_Schedule_Id 
                        AND EM.Exam_Schedule_Details_Id = ESD.Exam_Schedule_Details_Id  
                INNER JOIN Tbl_Exam_Attendance EA ON EA.Attendance_Master_Id = EM.Attendance_Master_Id                  
                WHERE EXM.Exam_Master_id = @Exam_Master_id  
                AND ES.Course_id = @Course_id           
                AND EM.Approval_Status = 1 
                AND Publish_status = 2  
                AND Present = 1   
            END  

            IF (@flag = 3)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT MA.Student_Id), 0) AS absentstudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id               
                WHERE (Result_status = ''Y'' OR Result_status = ''Z'') 
                AND EXM.Exam_Master_id = @Exam_Master_id  
                AND MA.Course_id = @Course_id  
                AND EntryType = @EntryType   
            END  

            IF (@flag = 4)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT EA.Student_Id), 0) AS Misconductstudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_Exam_Attendance_Master EM ON EM.Exam_Schedule_Id = ES.Exam_Schedule_Id 
                        AND EM.Exam_Schedule_Details_Id = ESD.Exam_Schedule_Details_Id  
                INNER JOIN Tbl_Exam_Attendance EA ON EA.Attendance_Master_Id = EM.Attendance_Master_Id                  
                WHERE EXM.Exam_Master_id = @Exam_Master_id  
                AND ES.Course_id = @Course_id           
                AND EM.Approval_Status = 1 
                AND Publish_status = 2  
                AND Misconduct = 1   
            END  

            IF (@flag = 5)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT MA.Student_Id), 0) AS failedstudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id               
                WHERE (Result_status = ''F'') 
                AND EXM.Exam_Master_id = @Exam_Master_id  
                AND MA.Course_id = @Course_id  
                AND EntryType = @EntryType   
            END  

            IF (@flag = 6)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT MA.Student_Id), 0) AS Barredstudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id               
                WHERE (Result_status = ''X'') 
                AND EXM.Exam_Master_id = @Exam_Master_id  
                AND MA.Course_id = @Course_id  
                AND EntryType = @EntryType   
            END  

            IF (@flag = 7)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT MA.Student_Id), 0) AS Incompletestudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id               
                WHERE (Result_status = ''I'') 
                AND EXM.Exam_Master_id = @Exam_Master_id  
                AND MA.Course_id = @Course_id  
                AND EntryType = @EntryType   
            END  

            IF (@flag = 8)  
            BEGIN  
                SELECT ISNULL(COUNT(DISTINCT MA.Student_Id), 0) AS passstudents  
                FROM Tbl_Exam_Master EXM   
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                 
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id   
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id               
                WHERE (Result_status NOT IN (''I'', ''Y'', ''Z'', ''Academic Disciplinary – Pardoned'', 
                                              ''Academic Disciplinary – Not Pardoned'', ''F'', ''X'') 
                       AND Result_status IS NOT NULL)  
                AND EXM.Exam_Master_id = @Exam_Master_id  
                AND MA.Course_id = @Course_id  
                AND EntryType = @EntryType   
            END  
        END
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_GetSummaryofCourse]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Exam_GetSummaryofCourse]              
        (                
            @flag BIGINT = 0,              
            @PageSize BIGINT = 10,                
            @CurrentPage BIGINT = 1,           
            @Department_id BIGINT = 0,         
            @intake_id BIGINT = 0        
        )              
        AS              
        BEGIN              
            IF (@flag = 0)              
            BEGIN              
                SELECT DISTINCT 
                    EXM.Exam_Master_Id,
                    EXM.Exam_Name,
                    EXM.Exam_Type,
                    CONCAT(NC.Course_Name, '' '', NC.Course_Code) AS Coursename,      
                    CONVERT(VARCHAR, ES.Exam_Date, 103) AS Exam_Date, 
                    CONCAT(B.Block_Name, '' '', F.Floor_Name, '' '', R.Room_Name) AS Room_Name,
                    ES.Course_id,                                                     
                    CONVERT(VARCHAR(15), CAST(ES.Exam_Time_From AS TIME), 100) AS Exam_Time_From,                                                  
                    CONVERT(VARCHAR(15), CAST(ES.Exam_Time_To AS TIME), 100) AS Exam_Time_To,       
                    CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) AS Employeename,
                    NC.Course_Code,
                    NC.ContactHours      
                FROM Tbl_Exam_Master EXM       
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                    
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id       
                INNER JOIN Tbl_New_Course NC ON NC.Course_id = ES.Course_id      
                INNER JOIN Tbl_Employee E ON E.Employee_Id = ESD.ChiefInvigilator      
                INNER JOIN Tbl_Room R ON R.Room_Id = ESD.Venue      
                INNER JOIN Tbl_Block B ON R.Block_Id = B.Block_Id         
                INNER JOIN Tbl_Floor F ON F.Floor_Id = R.Floor_Id     
                LEFT JOIN Tbl_Course_Duration_PeriodDetails CPD ON CPD.Duration_Period_Id = EXM.Duration_Period_id                              
                INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CPD.Batch_Id     
                INNER JOIN Tbl_Department D ON D.Department_Id = CBD.Duration_Id    
                WHERE (D.Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)            
                    AND (CPD.Batch_Id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0) 
                    AND Publish_status = 2           
                ORDER BY EXM.Exam_Master_id DESC              
                OFFSET @PageSize * (@CurrentPage - 1) ROWS                
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                
            END              
            IF (@flag = 1)              
            BEGIN              
                -- Pagination count get              
                SELECT * INTO #temp FROM (                
                    SELECT DISTINCT 
                        EXM.Exam_Master_Id,
                        EXM.Exam_Name,
                        EXM.Exam_Type,
                        CONCAT(NC.Course_Name, '' '', NC.Course_Code) AS Coursename,      
                        CONVERT(VARCHAR, ES.Exam_Date, 103) AS Exam_Date, 
                        CONCAT(B.Block_Name, '' '', F.Floor_Name, '' '', R.Room_Name) AS Room_Name,
                        ES.Course_id,                                                     
                        CONVERT(VARCHAR(15), CAST(ES.Exam_Time_From AS TIME), 100) AS Exam_Time_From,                                                  
                        CONVERT(VARCHAR(15), CAST(ES.Exam_Time_To AS TIME), 100) AS Exam_Time_To,       
                        CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) AS Employeename,
                        NC.Course_Code,
                        NC.ContactHours        
                    FROM Tbl_Exam_Master EXM       
                    INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                  
                    INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id       
                    INNER JOIN Tbl_New_Course NC ON NC.Course_id = ES.Course_id      
                    INNER JOIN Tbl_Employee E ON E.Employee_Id = ESD.ChiefInvigilator      
                    INNER JOIN Tbl_Room R ON R.Room_Id = ESD.Venue      
                    INNER JOIN Tbl_Block B ON R.Block_Id = B.Block_Id         
                    INNER JOIN Tbl_Floor F ON F.Floor_Id = R.Floor_Id     
                    LEFT JOIN Tbl_Course_Duration_PeriodDetails CPD ON CPD.Duration_Period_Id = EXM.Duration_Period_id                              
                    INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CPD.Batch_Id     
                    INNER JOIN Tbl_Department D ON D.Department_Id = CBD.Duration_Id    
                    WHERE (D.Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)            
                        AND (CPD.Batch_Id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0) 
                        AND Publish_status = 2                
                ) base                
                SELECT COUNT(*) AS totcount FROM #temp                
            END              
        END
    ')
END

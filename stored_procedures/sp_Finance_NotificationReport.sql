IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_NotificationReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[sp_Finance_NotificationReport] 
        (
            @flag BIGINT = 0,
            @BatchID BIGINT = 0,
            @Department_Id BIGINT = 0,
            @Facultyid BIGINT = 0,
            @fromdate DATETIME = NULL,
            @Todate DATETIME = NULL,
            @PageSize BIGINT = 10,
            @CurrentPage BIGINT = 1
        )
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                SELECT DISTINCT 
                    Notification_id,
                    Notification_Msg,
                    CASE 
                        WHEN NA.Course_Level_Id IS NULL THEN ''N/A'' 
                        WHEN NA.Course_Level_Id = 0 THEN ''N/A'' 
                        ELSE Course_Level_Name 
                    END AS Course_Level_Name,
                    CPD.Candidate_Id,
                    CASE 
                        WHEN IM.intake_no IS NULL THEN ''N/A'' 
                        WHEN IM.intake_no = '''' THEN ''N/A'' 
                        ELSE IM.intake_no 
                    END AS intake_no,
                    BD.Batch_Code,
                    IM.Batch_Code,
                    CASE 
                        WHEN NA.Course_Level_Id IS NULL THEN ''N/A'' 
                        WHEN NA.Course_Level_Id = 0 THEN ''N/A'' 
                        ELSE CONCAT(D.Course_Code, ''-'', D.Department_Name) 
                    END AS Department_Name,
                    BD.IntakeMasterID,
                    CONVERT(VARCHAR(10), Notification_date, 105) AS Notification_date,
                    CASE 
                        WHEN IsRead_Status = 1 THEN ''Read'' 
                        ELSE ''Not Read'' 
                    END AS readstatus,
                    Sented_by,
                    N.User_Id,
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS studentname,
                    CASE 
                        WHEN Sented_by = 1 THEN ''Admin'' 
                        WHEN Sented_by = 0 THEN ''System'' 
                        ELSE CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) 
                    END AS Employeename
                FROM 
                    Tbl_NotificationNew N
                    INNER JOIN Tbl_Student_User SU ON SU.User_Id = N.User_Id
                    LEFT JOIN Tbl_Employee_User EU ON EU.User_Id = N.Sented_by
                    INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SU.Candidate_Id
                    LEFT JOIN Tbl_Employee E ON E.Employee_Id = EU.Employee_Id
                    LEFT JOIN Tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
                    LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id
                    LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
                    LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
                WHERE 
                    Category = ''Finance''
                    AND (
                        (CONVERT(date, Notification_date) >= @fromdate AND CONVERT(date, Notification_date) < DATEADD(day, 1, @Todate)) 
                        OR (@fromdate IS NULL AND @Todate IS NULL)
                        OR (@fromdate IS NULL AND CONVERT(date, Notification_date) < DATEADD(day, 1, @Todate))
                        OR (@Todate IS NULL AND CONVERT(date, Notification_date) >= @fromdate)
                    )
                    AND (@BatchID = 0 OR BD.IntakeMasterID = @BatchID)
                    AND (@Department_Id = 0 OR NA.Department_Id = @Department_Id)
                    AND (@Facultyid = 0 OR NA.Course_Level_Id = @Facultyid)
                ORDER BY 
                    Notification_date DESC
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY 
                OPTION (RECOMPILE);
            END

            IF (@flag = 2)
            BEGIN
                SELECT * 
                INTO #temp 
                FROM (
                    SELECT DISTINCT 
                        Notification_id,
                        Notification_Msg,
                        CASE 
                            WHEN NA.Course_Level_Id IS NULL THEN ''N/A'' 
                            WHEN NA.Course_Level_Id = 0 THEN ''N/A'' 
                            ELSE Course_Level_Name 
                        END AS Course_Level_Name,
                        CPD.Candidate_Id,
                        CASE 
                            WHEN IM.intake_no IS NULL THEN ''N/A'' 
                            ELSE IM.intake_no 
                        END AS intake_no,
                        BD.Batch_Code,
                        CASE 
                            WHEN NA.Course_Level_Id IS NULL THEN ''N/A'' 
                            WHEN NA.Course_Level_Id = 0 THEN ''N/A'' 
                            ELSE CONCAT(D.Course_Code, ''-'', D.Department_Name) 
                        END AS Department_Name,
                        BD.IntakeMasterID,
                        CONVERT(VARCHAR(10), Notification_date, 105) AS Notification_date,
                        CASE 
                            WHEN IsRead_Status = 1 THEN ''Read'' 
                            ELSE ''Not Read'' 
                        END AS readstatus,
                        Sented_by,
                        N.User_Id,
                        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS studentname,
                        CASE 
                            WHEN Sented_by = 1 THEN ''Admin'' 
                            WHEN Sented_by = 0 THEN ''System'' 
                            ELSE CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) 
                        END AS Employeename
                    FROM 
                        Tbl_NotificationNew N
                        INNER JOIN Tbl_Student_User SU ON SU.User_Id = N.User_Id
                        LEFT JOIN Tbl_Employee_User EU ON EU.User_Id = N.Sented_by
                        INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SU.Candidate_Id
                        LEFT JOIN Tbl_Employee E ON E.Employee_Id = EU.Employee_Id
                        LEFT JOIN Tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
                        LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id
                        LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
                        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
                        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
                    WHERE 
                        Category = ''Finance''
                        AND (
                            (CONVERT(date, Notification_date) >= @fromdate AND CONVERT(date, Notification_date) < DATEADD(day, 1, @Todate)) 
                            OR (@fromdate IS NULL AND @Todate IS NULL)
                            OR (@fromdate IS NULL AND CONVERT(date, Notification_date) < DATEADD(day, 1, @Todate))
                            OR (@Todate IS NULL AND CONVERT(date, Notification_date) >= @fromdate)
                        )
                        AND (@BatchID = 0 OR BD.IntakeMasterID = @BatchID)
                        AND (@Department_Id = 0 OR NA.Department_Id = @Department_Id)
                        AND (@Facultyid = 0 OR NA.Course_Level_Id = @Facultyid)
                ) base

                SELECT COUNT(*) AS counts FROM #temp;

                DROP TABLE #temp;
            END
        END
    ');
END
GO
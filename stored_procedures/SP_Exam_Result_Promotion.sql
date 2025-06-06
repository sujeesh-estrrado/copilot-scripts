IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Result_Promotion]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Exam_Result_Promotion] 
        (
            @flag bigint = 0, 
            @SemesterId bigint = 0, 
            @intake bigint = 0, 
            @pgmid bigint = 0, 
            @examstatus bigint = 0, 
            @pagesize bigint = 0, 
            @pageno bigint = 0, 
            @Exam_Master_id bigint = 0, 
            @PublishType bigint = 0
        )
        AS
        BEGIN
            IF (@flag = 0) 
            BEGIN
                -- Select records based on the condition
                SELECT 
                    CONCAT(D.department_name, ''-'', D.Course_Code) AS Program,
                    EM.Duration_Period_id, 
                    CBD.Batch_Code AS Intake, 
                    CBD.Batch_Id, 
                    S.Semester_Id, 
                    D.Department_Id,
                    EM.Exam_Type AS PublishTypevalue, 
                    L.Course_Level_Name AS faculty, 
                    S.Semester_Name AS semester, 
                    CONVERT(VARCHAR(10), EM.Exam_start_date, 103) AS Exam_start_date, 
                    CONVERT(VARCHAR(10), EM.Exam_end_date, 103) AS Exam_end_date,
                    CASE 
                        WHEN EM.Publish_status = 2 THEN ''Approved'' 
                        WHEN EM.Publish_status = 1 THEN ''Pending'' 
                    END AS Status, 
                    EM.Exam_master_id, 
                    CONVERT(VARCHAR(10), EM.create_date, 103) AS create_date, 
                    EM.Exam_Name AS Examname, 
                    CASE 
                        WHEN EM.ExamDep_Approval IS NULL THEN ''Pending'' 
                        WHEN EM.ExamDep_Approval = 0 THEN ''Pending'' 
                        WHEN EM.ExamDep_Approval = 1 THEN ''Approved'' 
                    END AS ExamDep_Approval, 
                    CASE 
                        WHEN EM.Registrar_Approval IS NULL THEN ''Pending'' 
                        WHEN EM.Registrar_Approval = 0 THEN ''Pending'' 
                        WHEN EM.Registrar_Approval = 1 THEN ''Approved'' 
                    END AS Registrar_Approval, 
                    CASE 
                        WHEN EM.Exam_Type = 1 THEN ''Internal'' 
                        WHEN EM.Exam_Type = 2 THEN ''Regular'' 
                        WHEN EM.Exam_Type = 3 THEN ''Resit'' 
                        WHEN EM.Exam_Type = 4 THEN ''Repeat'' 
                    END AS PublishType, 
                    CASE 
                        WHEN EM.Result_PublishStatus IS NULL THEN ''Pending'' 
                        WHEN Registrar_Approval = 1 THEN ''Approved''  
                        WHEN EM.Result_PublishStatus = 1 THEN ''Published'' 
                    END AS Result_PublishStatus
                FROM Tbl_Exam_Master EM
                LEFT JOIN Tbl_Course_Duration_PeriodDetails CPD ON CPD.Duration_Period_Id = EM.Duration_Period_id
                INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CPD.Batch_Id AND CBD.Batch_DelStatus = 0 AND CPD.Delete_Status = 0
                INNER JOIN Tbl_Department D ON D.Department_Id = CBD.Duration_Id
                INNER JOIN Tbl_Course_Level L ON L.Course_Level_Id = D.GraduationTypeId
                INNER JOIN Tbl_Course_Semester S ON S.Semester_Id = CPD.Semester_Id AND S.Semester_DelStatus = 0
                WHERE EM.Publish_status = 2 AND EM.Exam_Master_id IN (SELECT Exam_Id FROM Tbl_MarkEntryMaster WHERE Exam_Id = EM.Exam_Master_id)
                AND (@SemesterId = 0 OR S.Semester_Id = @SemesterId)
                AND (@intake = 0 OR CBD.Batch_Id = @intake)
                AND (@pgmid = 0 OR D.Department_Id = @pgmid)
                
                UNION ALL
                
                SELECT 
                    CONCAT(D.department_name, ''-'', D.Course_Code) AS Program,
                    EM.Duration_Period_id, 
                    CBD.Batch_Code AS Intake, 
                    CBD.Batch_Id, 
                    S.Semester_Id, 
                    D.Department_Id,
                    5 AS PublishTypevalue, 
                    L.Course_Level_Name AS faculty, 
                    S.Semester_Name AS semester, 
                    CONVERT(VARCHAR(10), EM.Exam_start_date, 103) AS Exam_start_date, 
                    CONVERT(VARCHAR(10), EM.Exam_end_date, 103) AS Exam_end_date,
                    CASE 
                        WHEN EM.Publish_status = 2 THEN ''Approved'' 
                        WHEN EM.Publish_status = 1 THEN ''Pending'' 
                    END AS Status, 
                    EM.Exam_master_id, 
                    CONVERT(VARCHAR(10), EM.create_date, 103) AS create_date, 
                    EM.Exam_Name AS Examname, 
                    CASE 
                        WHEN EM.ExamDep_Approval IS NULL THEN ''Pending'' 
                        WHEN EM.ExamDep_Approval = 0 THEN ''Pending'' 
                        WHEN EM.ExamDep_Approval = 1 THEN ''Approved'' 
                    END AS ExamDep_Approval, 
                    CASE 
                        WHEN EM.Registrar_Approval IS NULL THEN ''Pending'' 
                        WHEN EM.Registrar_Approval = 0 THEN ''Pending'' 
                        WHEN EM.Registrar_Approval = 1 THEN ''Approved'' 
                    END AS Registrar_Approval, 
                    ''Re-Evaluation'' AS PublishType, 
                    CASE 
                        WHEN EM.Result_PublishStatus IS NULL THEN ''Pending'' 
                        WHEN Registrar_Approval = 1 THEN ''Approved''  
                        WHEN EM.Result_PublishStatus = 1 THEN ''Published'' 
                    END AS Result_PublishStatus
                FROM Tbl_Exam_Master EM
                LEFT JOIN Tbl_Course_Duration_PeriodDetails CPD ON CPD.Duration_Period_Id = EM.Duration_Period_id
                INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CPD.Batch_Id AND CBD.Batch_DelStatus = 0 AND CPD.Delete_Status = 0
                INNER JOIN Tbl_Department D ON D.Department_Id = CBD.Duration_Id
                INNER JOIN Tbl_Course_Level L ON L.Course_Level_Id = D.GraduationTypeId
                INNER JOIN Tbl_Course_Semester S ON S.Semester_Id = CPD.Semester_Id AND S.Semester_DelStatus = 0
                WHERE EM.Publish_status = 2 AND EM.Exam_Master_id IN (SELECT Exam_Id FROM Tbl_MarkEntryMaster WHERE Exam_Id = EM.Exam_Master_id AND EntryType = ''R3'')
                AND (@SemesterId = 0 OR S.Semester_Id = @SemesterId)
                AND (@intake = 0 OR CBD.Batch_Id = @intake)
                AND (@pgmid = 0 OR D.Department_Id = @pgmid)
                
                ORDER BY EM.Exam_master_id DESC
            END

            IF (@flag = 1) 
            BEGIN
                UPDATE Tbl_Exam_Master 
                SET ExamDep_Approval = 1 
                WHERE Exam_Master_id = @Exam_Master_id
            END

            IF (@flag = 2) 
            BEGIN
                UPDATE Tbl_Exam_Master 
                SET Registrar_Approval = 1 
                WHERE Exam_Master_id = @Exam_Master_id
            END

            IF (@flag = 3) 
            BEGIN
                UPDATE Tbl_Exam_Master 
                SET Result_PublishStatus = 1, PublishType = @PublishType 
                WHERE Exam_Master_id = @Exam_Master_id
            END

            IF (@flag = 4) 
            BEGIN
                SELECT 
                    Exam_Master_id, 
                    CASE 
                        WHEN ExamDep_Approval IS NULL THEN 0 
                        WHEN ExamDep_Approval = 0 THEN 0 
                        ELSE 1 
                    END AS ExamDep_Approval, 
                    CASE 
                        WHEN Registrar_Approval IS NULL THEN 0 
                        WHEN Registrar_Approval = 0 THEN 0 
                        ELSE 1 
                    END AS Registrar_Approval, 
                    CASE 
                        WHEN Result_PublishStatus IS NULL THEN 0 
                        WHEN Result_PublishStatus = 0 THEN 0 
                        ELSE 1 
                    END AS Publish_status
                FROM Tbl_Exam_Master 
                WHERE Exam_Master_id = @Exam_Master_id
            END
        END
    ')
END

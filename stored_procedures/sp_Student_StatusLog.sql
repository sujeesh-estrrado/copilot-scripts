IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Student_StatusLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Student_StatusLog]
        @studentid BIGINT = 0,
        @flag BIGINT = 0,
        @courseid BIGINT = 0,
        @oldcourseid BIGINT = 0,
        @oldmatrixno VARCHAR(MAX) = '''',
        @newmatrixno VARCHAR(MAX) = '''',
        @currentstatus BIGINT = 0,
        @newstatus BIGINT = 0,
        @changeby BIGINT = 0,
        @datedefered DATETIME = NULL,
        @datereturn DATETIME = NULL,
        @remarks VARCHAR(MAX) = ''''
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT 
                    ss.name AS currentstatus,
                    dateeffective,
                    CASE 
                        WHEN changeby IS NULL THEN ''Candidate''
                        WHEN changeby = 0 THEN ''System''
                        WHEN changeby = 1 THEN ''Admin''
                        ELSE CONCAT(Employee_Fname, '' '', Employee_LName)
                    END AS changeby,
                    NA.Department_Id, 
                    NA.Batch_Id,
                    D.department_Id,
                    CASE 
                        WHEN BD.Batch_Code = ''0'' THEN ''NA''
                        WHEN BD.Batch_Code IS NULL THEN ''NA''
                        ELSE BD.Batch_Code
                    END AS Batch_Code,
                    CASE 
                        WHEN BD.Batch_Code = ''0'' THEN ''NA''
                        WHEN D.Department_Name IS NULL THEN ''NA''
                        ELSE D.Department_Name
                    END AS Department_Name,
                    SL.remarks
                FROM 
                    student_statuslog SL
                    LEFT JOIN Tbl_Employee E ON E.Employee_Id = changeby
                    LEFT JOIN Tbl_Student_status ss ON ss.id = newstatus
                    LEFT JOIN Tbl_Candidate_Personal_Det PD ON PD.Candidate_id = SL.studentid
                    LEFT JOIN Tbl_New_Admission NA ON NA.New_Admission_Id = PD.New_Admission_Id
                    LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
                    LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
                WHERE 
                    studentid = @studentid 
                    AND newstatus != 0
            END
            
            IF (@flag = 1)
            BEGIN
                INSERT INTO student_statuslog 
                    (studentid, courseid, oldcourseid, oldmatrixno, newmatrixno, currentstatus, newstatus, 
                    dateeffective, datechange, changeby, datedeferred, datereturn, remarks)
                VALUES 
                    (@studentid, @courseid, @oldcourseid, @oldmatrixno, @newmatrixno, @currentstatus, 
                    @newstatus, GETDATE(), GETDATE(), @changeby, @datedefered, @datereturn, @remarks)
            END
        END
    ')
END

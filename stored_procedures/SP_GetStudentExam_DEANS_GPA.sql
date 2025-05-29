IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStudentExam_DEANS_GPA]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetStudentExam_DEANS_GPA]        
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
                MA.Student_Id AS StudentId1,
                CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Studentname,      
                AdharNumber,
                IDMatrixNo,
                S.SEMESTER_NO,
                cs.Semester_Name,
                D.Course_Code,
                D.Department_Name,
                EXM.Exam_Master_id,
                SG.EntryType,    
                ISNULL(SG.GPA, 0.00) AS GPA,
                ISNULL(SG.CGPA, 0.00) AS CGPA,
                ISNULL(SG.Cumulative_Credit_Score, 0.00) AS Cumulative_Credit_Score    
            FROM Tbl_Exam_Master EXM                           
            INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                                        
            INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id                           
            INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id                                      
            INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = MA.Student_Id                       
            INNER JOIN Tbl_Student_Semester S ON S.Candidate_Id = MA.Student_Id                   
            LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = S.SEMESTER_NO     
            LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id    
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id      
            LEFT JOIN Tbl_Student_GradeStatus SG ON SG.Student_Id = CPD.Candidate_Id     
                AND SG.Exam_Master_id = EXM.Exam_Master_id 
                AND SG.Semester_Id = cs.Semester_Id    
            WHERE SG.GPA < 2.00      
                AND (@Department_id = 0 OR NA.Department_Id = @Department_id)      
                AND (@intake_id = 0 OR NA.Batch_Id = @intake_id)     
            ORDER BY Exam_Master_id DESC        
            OFFSET @PageSize * (@CurrentPage - 1) ROWS          
            FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);          
        END          

        IF (@flag = 1)          
        BEGIN          
            DECLARE @totcount INT;

            SELECT @totcount = COUNT(*) 
            FROM (
                SELECT DISTINCT 
                    MA.Student_Id 
                FROM Tbl_Exam_Master EXM                           
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id                                                        
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id                           
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id                                      
                INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = MA.Student_Id                       
                INNER JOIN Tbl_Student_Semester S ON S.Candidate_Id = MA.Student_Id                   
                LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = S.SEMESTER_NO     
                LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id    
                LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id      
                LEFT JOIN Tbl_Student_GradeStatus SG ON SG.Student_Id = CPD.Candidate_Id     
                    AND SG.Exam_Master_id = EXM.Exam_Master_id 
                    AND SG.Semester_Id = cs.Semester_Id    
                WHERE SG.GPA < 2.00      
                    AND (@Department_id = 0 OR NA.Department_Id = @Department_id)      
                    AND (@intake_id = 0 OR NA.Batch_Id = @intake_id)   
            ) AS base;

            SELECT @totcount AS totcount;
        END          
    END  
    ');
END;

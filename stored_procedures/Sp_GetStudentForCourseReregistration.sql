IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetStudentForCourseReregistration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_GetStudentForCourseReregistration]        
    (@intake BIGINT, @semesterid BIGINT, @pagesize BIGINT, @CurrentPage BIGINT, @flag BIGINT)        
    AS        
    BEGIN        
        IF (@flag = 0)        
        BEGIN        
            SELECT 
                P.AdharNumber,
                P.IDMatrixNo,
                CONCAT(P.Candidate_Fname, '' '', P.Candidate_Lname) AS StudentName,
                PD.Duration_Period_Id,
                P.Candidate_Id AS ID 
            FROM Tbl_Candidate_Personal_Det P        
            INNER JOIN Tbl_New_Admission NA ON P.New_Admission_Id = NA.New_Admission_Id        
            INNER JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = P.Candidate_Id        
            LEFT JOIN Tbl_Course_Duration_PeriodDetails PD ON PD.Duration_Period_Id = SS.Duration_Period_Id        
            WHERE 
                P.active IN (1, 2, 3) 
                AND PD.Batch_Id = @intake 
                AND SS.SEMESTER_NO = @semesterid        
            ORDER BY P.Candidate_Id DESC        
            OFFSET @pagesize * (@CurrentPage - 1) ROWS       
            FETCH NEXT @pagesize ROWS ONLY OPTION (RECOMPILE);        
        END        

        IF (@flag = 1)        
        BEGIN        
            SELECT COUNT(1) AS counts 
            FROM Tbl_Candidate_Personal_Det P        
            INNER JOIN Tbl_New_Admission NA ON P.New_Admission_Id = NA.New_Admission_Id        
            INNER JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = P.Candidate_Id        
            LEFT JOIN Tbl_Course_Duration_PeriodDetails PD ON PD.Duration_Period_Id = SS.Duration_Period_Id        
            WHERE 
                P.active IN (2, 3) 
                AND NA.Batch_Id = @intake 
                AND SS.SEMESTER_NO = @semesterid;        
        END        
    END  
    ');
END;

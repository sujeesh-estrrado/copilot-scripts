IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetStudentForSeatAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_GetStudentForSeatAllocation]        
    (@intake BIGINT = 0, @semesterid BIGINT = 0, @flag BIGINT = 0)        
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
            LEFT JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = P.Candidate_Id      
            LEFT JOIN Tbl_Course_Duration_PeriodDetails PD ON PD.Duration_Period_Id = SS.Duration_Period_Id        
            WHERE 
                P.active IN (2, 3) 
                AND (@intake = 0 OR PD.Batch_Id = @intake) 
                AND (@semesterid = 0 OR SS.SEMESTER_NO = @semesterid)
            ORDER BY NEWID();         
        END        
    END 
    ');
END;

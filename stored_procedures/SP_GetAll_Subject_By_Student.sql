IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Subject_By_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Subject_By_Student]
        (
            @Candidate_Id BIGINT        
        )        
        AS        
        BEGIN        
            SELECT DISTINCT 
                SS.*,        
                ISNULL(CPD.Candidate_Fname, '''') + '' '' + 
                ISNULL(CPD.Candidate_Mname, '''') + '' '' + 
                ISNULL(CPD.Candidate_Lname, '''') AS StudentName,
                SS.Candidate_Id,      
                Batch_Code + ''-'' + Semester_Code AS BatchSemester,    
                SSC.Semester_Subject_Id,              
                SSC.Duration_Mapping_Id,              
                SSC.Department_Subjects_Id,      
                S.Subject_Name AS SubjectName,        
                (SELECT COUNT(Subject_Id) 
                 FROM Tbl_Subject  
                 WHERE Parent_Subject_Id = S.Subject_Id) AS ChildCount     
                           
            FROM dbo.Tbl_Student_Semester SS       
            INNER JOIN Tbl_Candidate_Personal_Det CPD 
                ON CPD.Candidate_Id = SS.Candidate_Id      
            INNER JOIN Tbl_Course_Duration_Mapping cdm   
                ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id           
            INNER JOIN Tbl_Course_Duration_PeriodDetails cdp 
                ON cdm.Duration_Period_Id = cdp.Duration_Period_Id              
            INNER JOIN Tbl_Course_Batch_Duration cbd 
                ON cbd.Batch_Id = cdp.Batch_Id               
            INNER JOIN Tbl_Course_Semester cs 
                ON cs.Semester_Id = cdp.Semester_Id       
            INNER JOIN Tbl_Semester_Subjects ssc 
                ON ssc.Duration_Mapping_Id = SS.Duration_Mapping_Id     
            INNER JOIN Tbl_Department_Subjects DS 
                ON SSC.Department_Subjects_Id = DS.Department_Subject_Id            
            INNER JOIN Tbl_Subject S 
                ON DS.Subject_Id = S.Subject_Id       
                     
            WHERE 
                SS.Candidate_Id = @Candidate_Id 
                AND SS.Student_Semester_Delete_Status = 0 
                AND SS.Student_Semester_Current_Status = 1      
        END
    ')
END

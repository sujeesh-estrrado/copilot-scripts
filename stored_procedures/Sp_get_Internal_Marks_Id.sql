IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_get_Internal_Marks_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_get_Internal_Marks_Id] 
    (@candidateId BIGINT)    
    AS    
    BEGIN    
        SELECT            
            S.Candidate_Id,          
            S.Duration_Mapping_Id,         
            SS.Semester_Subject_Id,   
            Tbl_Subject.Subject_Name,  
            cs.Semester_Name,       
            CONCAT(C.Candidate_Fname, '' '', C.Candidate_Mname, '' '', C.Candidate_Lname) AS [CandidateName],        
            ISNULL(CIM.Internal_Marks, 0) AS Internal_Marks,      
            CRN.RollNumber, 
            CUR.University_Regno,      
            ISNULL(IM.Total_Marks, 0) AS Total_Marks, 
            ISNULL(IM.Min_Marks, 0) AS Min_Marks        
         
        FROM 
            Tbl_Student_Semester S            
            INNER JOIN Tbl_Candidate_Personal_Det C ON S.Candidate_Id = C.Candidate_Id            
            INNER JOIN dbo.Tbl_Semester_Subjects SS ON SS.Duration_Mapping_Id = S.Duration_Mapping_Id   
            INNER JOIN Tbl_Course_Duration_Mapping CD ON CD.Duration_Mapping_Id = SS.Duration_Mapping_Id
            LEFT JOIN Tbl_Course_Duration_PeriodDetails CP ON CP.Duration_Period_Id = CD.Duration_Period_Id
            LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = CP.Batch_Id       
            INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id = CP.Semester_Id   
            LEFT JOIN Tbl_Exam_Internal_Marks IM ON IM.Semester_Subject_Id = SS.Semester_Subject_Id  
            LEFT JOIN Tbl_Department_Subjects DS ON DS.Department_Subject_Id = SS.Department_Subjects_Id  
            LEFT JOIN Tbl_Subject ON Tbl_Subject.Subject_Id = DS.Subject_Id  
            LEFT JOIN Tbl_Exam_Candidate_Internal_Marks CIM ON CIM.Exam_InternalMarks_Id = IM.Exam_InternalMarks_Id 
                AND CIM.Candidate_Id = C.Candidate_Id        
            LEFT JOIN Tbl_Candidate_RollNumber CRN ON CRN.Candidate_Id = C.Candidate_Id       
            LEFT JOIN dbo.Tbl_Candidate_University_Regno CUR ON CUR.Candidate_Id = C.Candidate_Id       
        WHERE 
            S.Candidate_Id = @candidateId
    END
    ')
END

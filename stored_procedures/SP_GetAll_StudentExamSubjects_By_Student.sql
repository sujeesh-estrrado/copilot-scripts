IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_StudentExamSubjects_By_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_StudentExamSubjects_By_Student]                
        @Course_Department_Id BIGINT,
        @Duration_Mapping_Id BIGINT,
        @Candidate_Id BIGINT                
        AS                  
        BEGIN           
       
            SELECT           
                DISTINCT(SEC.SubjectId) AS Subject_Id,          
                SEC.SubjectName AS Subject_Name,            
                SEC.SubjectCode AS Subject_Code,      
                SEC.AssesmentCode AS Assessment_Code,      
                SEC.GradingScherme AS Grading_Scheme,    
                SEC.CurrentStatus,    
                ''YES'' AS typ             
            FROM Tbl_StudentExamSubjectsChild SEC          
            INNER JOIN Tbl_StudentExamSubjectMaster SEM 
                ON SEC.StudentExamSubjectMasterId = SEM.StudentExamSubjectMasterId          
            WHERE SEM.Department_Id = @Course_Department_Id           
            AND SEM.Duration_Mapping_Id = @Duration_Mapping_Id          
            AND SEM.Candidate_Id = @Candidate_Id        
          
            UNION          
          
            SELECT              
                DISTINCT(SC.Subject_Id) AS Subject_Id,                 
                S.Subject_Name,            
                S.Subject_Code,      
                S.Assessment_Code,       
                SMM.Grading_Scheme,    
                '''' AS CurrentStatus,    
                ''NO'' AS typ          
            FROM Tbl_Student_Subject_Child SC                  
            INNER JOIN Tbl_Student_Subject_Master SM 
                ON SC.Student_Subject_Map_Master = SM.Student_Subject_Map_Master                 
            INNER JOIN Tbl_Subject S 
                ON SC.Subject_Id = S.Subject_Id      
            INNER JOIN dbo.Tbl_Subject_Master SMM 
                ON SMM.Subject_Master_Code_Id = S.Subject_Master_Code_Id          
            WHERE SC.Subject_Id NOT IN (
                SELECT SECC.SubjectId              
                FROM Tbl_StudentExamSubjectsChild SECC          
                INNER JOIN Tbl_StudentExamSubjectMaster SEMM 
                    ON SECC.StudentExamSubjectMasterId = SEMM.StudentExamSubjectMasterId          
                WHERE SEMM.Department_Id = @Course_Department_Id           
                AND SEMM.Duration_Mapping_Id = @Duration_Mapping_Id          
                AND SEMM.Candidate_Id = @Candidate_Id
            )
            AND SM.Department_Id = @Course_Department_Id         
            AND SM.Duration_Mapping_Id = @Duration_Mapping_Id        
            AND SM.Candidate_Id = @Candidate_Id
        END
    ')
END
ELSE
BEGIN
    EXEC('
        ALTER PROCEDURE [dbo].[SP_GetAll_StudentExamSubjects_By_Student]                
        @Course_Department_Id BIGINT,
        @Duration_Mapping_Id BIGINT,
        @Candidate_Id BIGINT                
        AS                  
        BEGIN           
       
            SELECT           
                DISTINCT(SEC.SubjectId) AS Subject_Id,          
                SEC.SubjectName AS Subject_Name,            
                SEC.SubjectCode AS Subject_Code,      
                SEC.AssesmentCode AS Assessment_Code,      
                SEC.GradingScherme AS Grading_Scheme,    
                SEC.CurrentStatus,    
                ''YES'' AS typ             
            FROM Tbl_StudentExamSubjectsChild SEC          
            INNER JOIN Tbl_StudentExamSubjectMaster SEM 
                ON SEC.StudentExamSubjectMasterId = SEM.StudentExamSubjectMasterId          
            WHERE SEM.Department_Id = @Course_Department_Id           
            AND SEM.Duration_Mapping_Id = @Duration_Mapping_Id          
            AND SEM.Candidate_Id = @Candidate_Id        
          
            UNION          
          
            SELECT              
                DISTINCT(SC.Subject_Id) AS Subject_Id,                 
                S.Subject_Name,            
                S.Subject_Code,      
                S.Assessment_Code,       
                SMM.Grading_Scheme,    
                '''' AS CurrentStatus,    
                ''NO'' AS typ          
            FROM Tbl_Student_Subject_Child SC                  
            INNER JOIN Tbl_Student_Subject_Master SM 
                ON SC.Student_Subject_Map_Master = SM.Student_Subject_Map_Master                 
            INNER JOIN Tbl_Subject S 
                ON SC.Subject_Id = S.Subject_Id      
            INNER JOIN dbo.Tbl_Subject_Master SMM 
                ON SMM.Subject_Master_Code_Id = S.Subject_Master_Code_Id          
            WHERE SC.Subject_Id NOT IN (
                SELECT SECC.SubjectId              
                FROM Tbl_StudentExamSubjectsChild SECC          
                INNER JOIN Tbl_StudentExamSubjectMaster SEMM 
                    ON SECC.StudentExamSubjectMasterId = SEMM.StudentExamSubjectMasterId          
                WHERE SEMM.Department_Id = @Course_Department_Id           
                AND SEMM.Duration_Mapping_Id = @Duration_Mapping_Id          
                AND SEMM.Candidate_Id = @Candidate_Id
            )
            AND SM.Department_Id = @Course_Department_Id         
            AND SM.Duration_Mapping_Id = @Duration_Mapping_Id        
            AND SM.Candidate_Id = @Candidate_Id
        END
    ')
END

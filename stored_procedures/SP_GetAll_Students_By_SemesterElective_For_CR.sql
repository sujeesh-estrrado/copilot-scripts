IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Students_By_SemesterElective_For_CR]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Students_By_SemesterElective_For_CR]  
        (
            @Duration_Mapping_Id BIGINT,
            @Semester_Subjects_Id BIGINT
        )    
        AS        
        BEGIN       
            SELECT       
                SE.Candidate_Id,        
                SE.Semester_Subjects_Id,    
                ISNULL(Candidate_Fname, '''') + '' '' + ISNULL(Candidate_Mname, '''') + '' '' + ISNULL(Candidate_Lname, '''') AS [CandidateName],
                S.Subject_Name AS ElectiveSubjectName,  
                CC.Course_Category_Name + ''-'' + D.Department_Name AS [Department Name],
                CS.Semester_Code,
                CRN.RollNumber    
            FROM Tbl_Semester_Elective_Students SE      
            INNER JOIN Tbl_Candidate_Personal_Det C ON SE.Candidate_Id = C.Candidate_Id     
            INNER JOIN Tbl_Semester_Subjects SS ON SE.Semester_Subjects_Id = SS.Semester_Subject_Id
            INNER JOIN Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id  
            INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDM.Duration_Period_Id = CDP.Duration_Period_Id 
            INNER JOIN Tbl_Department_Subjects DS ON SS.Department_Subjects_Id = DS.Department_Subject_Id 
            INNER JOIN Tbl_Subject S ON DS.Subject_Id = S.Subject_Id
            INNER JOIN Tbl_Course_Department CD ON CD.Course_Department_Id = DS.Course_Department_Id  
            INNER JOIN Tbl_Department D ON CD.Department_Id = D.Department_Id       
            INNER JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = CD.Course_Category_Id  
            INNER JOIN Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id    
            INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id
            INNER JOIN dbo.Tbl_Candidate_RollNumber CRN ON CRN.Candidate_Id = C.Candidate_Id      
            WHERE 
                SE.Semester_Subjects_Id = @Semester_Subjects_Id 
                AND SS.Duration_Mapping_Id = @Duration_Mapping_Id    
            ORDER BY [CandidateName]
        END
    ')
END

IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Subjects_By_CandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Subjects_By_CandidateId] 
        @id INT = 0
        AS
        BEGIN
            SELECT * 
            FROM (
                SELECT 
                    S.Duration_Mapping_Id AS DurationMappingID, 
                    S.Semester_Subject_Id, 
                    S.Department_Subjects_Id, 
                    C.Course_Name AS SubjectName, 
                    C.Course_code,  
                    CP.Batch_Id, 
                    CP.Semester_Id, 
                    B.Batch_Code AS BatchName, 
                    Batch_Code + ''-'' + Semester_Code AS BatchSemester, 
                    B.Batch_Id AS BatchID, 
                    D.Department_Id AS CourseDepartmentID, 
                    CC.Course_Category_Name + ''-'' + D.Department_Name AS DepartmentName, 
                    SE.Semester_Name AS SemesterName 
                FROM 
                    Tbl_Semester_Subjects S     
                LEFT JOIN 
                    Tbl_New_Course C 
                    ON C.Course_Id = S.Department_Subjects_Id  
                INNER JOIN 
                    Tbl_Course_Duration_PeriodDetails CP 
                    ON S.Duration_Mapping_Id = CP.Duration_Period_Id        
                INNER JOIN 
                    Tbl_Course_Batch_Duration B 
                    ON CP.Batch_Id = B.Batch_Id              
                INNER JOIN 
                    Tbl_Course_Semester SE 
                    ON CP.Semester_Id = SE.Semester_Id              
                INNER JOIN 
                    Tbl_Course_Department CD 
                    ON CD.Department_Id = B.Duration_Id            
                INNER JOIN 
                    Tbl_Course_Category CC 
                    ON CC.Course_Category_Id = CD.Course_Category_Id            
                INNER JOIN 
                    Tbl_Department D 
                    ON CD.Department_Id = D.Department_Id  
                INNER JOIN 
                    Tbl_Student_Semester SS 
                    ON SS.Duration_Period_Id = CP.Duration_Period_Id 
                WHERE 
                    CP.Delete_Status = 0 
                    AND SS.Candidate_Id = @id
            ) Temp_Tbl
            ORDER BY Semester_Subject_Id DESC
        END
    ')
END

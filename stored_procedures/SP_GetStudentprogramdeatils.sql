IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStudentprogramdeatils]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetStudentprogramdeatils]          
    (            
        @flag BIGINT = 0,          
        @PageSize BIGINT = 10,            
        @CurrentPage BIGINT = 1,       
        @Department_id BIGINT = 0,     
        @intake_id BIGINT = 0,  
        @Coursetype BIGINT = 0  
    )            
    AS            
    BEGIN            
        IF (@flag = 0)            
        BEGIN            
            SELECT DISTINCT 
                CPD.Candidate_Id, 
                CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname) AS StudentName, 
                CPD.New_Admission_Id, 
                CPD.AdharNumber,   
                im.Batch_Code AS MasterIntake,            
                bd.Batch_Id,  
                bd.Batch_Code, 
                D.Department_Name, 
                D.Course_Code, 
                CL.Course_Level_Name,  
                D.Department_Id  
            FROM dbo.Tbl_Candidate_Personal_Det AS CPD 
            LEFT JOIN Tbl_Student_status S ON S.id = CPD.active            
            LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id            
            LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = CPD.New_Admission_Id   
            LEFT JOIN dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id   
            LEFT JOIN dbo.Tbl_Course_Batch_Duration AS BD ON N.Batch_Id = BD.Batch_Id    
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid            
            LEFT JOIN dbo.Tbl_Course_Department AS CDep ON CDep.Department_Id = N.Department_Id 
            LEFT JOIN dbo.Tbl_Department AS D ON D.Department_Id = CDep.Department_Id 
            LEFT JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId    
            WHERE   
                (@Department_id = 0 OR N.Department_Id = @Department_id)            
                AND (@intake_id = 0 OR N.Batch_Id = @intake_id)             
                AND (@Coursetype = 0 OR N.Course_Category_Id = @Coursetype)   
            ORDER BY CPD.Candidate_Id DESC     
            OFFSET @PageSize * (@CurrentPage - 1) ROWS            
            FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);            
        END            

        IF (@flag = 1)            
        BEGIN            
            -- Pagination count without using temp table          
            SELECT COUNT(DISTINCT CPD.Candidate_Id) AS TotalCount  
            FROM dbo.Tbl_Candidate_Personal_Det AS CPD 
            LEFT JOIN Tbl_Student_status S ON S.id = CPD.active            
            LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id            
            LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = CPD.New_Admission_Id   
            LEFT JOIN dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id   
            LEFT JOIN dbo.Tbl_Course_Batch_Duration AS BD ON N.Batch_Id = BD.Batch_Id    
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.intakemasterid            
            LEFT JOIN dbo.Tbl_Course_Department AS CDep ON CDep.Department_Id = N.Department_Id 
            LEFT JOIN dbo.Tbl_Department AS D ON D.Department_Id = CDep.Department_Id 
            LEFT JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId    
            WHERE   
                (@Department_id = 0 OR N.Department_Id = @Department_id)            
                AND (@intake_id = 0 OR N.Batch_Id = @intake_id)             
                AND (@Coursetype = 0 OR N.Course_Category_Id = @Coursetype);   
        END            
    END 
    ');
END;

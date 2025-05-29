IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_TC_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_TC_Details]              
        AS              
        BEGIN              
            SELECT              
                SR.Student_Reg_Id,              
                SR.Candidate_Id,     
                SG.BloodGroup,     
                CP.IdentificationNo AS IdentificationNumber,              
                ISNULL(CP.Candidate_Fname, '''') + '' '' + ISNULL(CP.Candidate_Mname, '''') + '' '' + ISNULL(CP.Candidate_Lname, '''') AS Candidate_Name,              
                CP.Candidate_Gender AS Gender,              
                CP.Candidate_Dob AS DOB,              
                CC.Course_Category_Id,              
                D.Department_Id,              
                Tbl_Course_Category.Course_Category_Name + '' '' + D.Department_Name AS Class,              
                SR.Student_Reg_No,              
                P.Candidate_Telephone AS Telephone,
                P.Candidate_Email,
                t.*,        
                Tbl_Student_Semester.Student_Semester_Current_Status AS newstatus,        
                Tbl_Course_Duration_Mapping.Course_Department_Id,        
                Tbl_Course_Department.Course_Category_Id,        
                Tbl_Course_Department.Department_Id,        
                D.Department_Name AS new_dept,        
                Tbl_Course_Category.Course_Category_Name            
            FROM dbo.Tbl_Student_Registration SR              
            LEFT JOIN dbo.Tbl_Candidate_Personal_Det CP 
                ON CP.Candidate_Id = SR.Candidate_Id              
            LEFT JOIN dbo.Tbl_Candidate_ContactDetails CD 
                ON CD.Candidate_Id = CP.Candidate_Id              
            LEFT JOIN dbo.Tbl_Course_Category CC 
                ON CC.Course_Category_Id = SR.Course_Category_Id              
            LEFT JOIN dbo.Tbl_Candidate_ContactDetails P 
                ON P.Candidate_Id = CP.Candidate_Id              
            LEFT JOIN dbo.Tbl_Student_TC_Details t 
                ON t.Candidate_Id = CP.Candidate_Id              
            LEFT JOIN Tbl_Student_Semester 
                ON Tbl_Student_Semester.Candidate_Id = CP.Candidate_Id        
            LEFT JOIN Tbl_Course_Duration_Mapping 
                ON Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id        
            LEFT JOIN Tbl_Course_Department 
                ON dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id        
            LEFT JOIN Tbl_Course_Category 
                ON Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id        
            LEFT JOIN Tbl_Course_Level 
                ON Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id        
            LEFT JOIN Tbl_Department D 
                ON Tbl_Course_Department.Department_Id = D.Department_Id           
            LEFT JOIN dbo.Tbl_Student_Health_General SG 
                ON SG.StudentId = CP.Candidate_Id                
            WHERE 
                Tbl_Student_Semester.Student_Semester_Current_Status = 1 
                AND CP.Candidate_DelStatus = 0         
            ORDER BY  
                Student_Reg_Id DESC                
        END
    ')
END

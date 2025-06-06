IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Student_Registration_Get_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Student_Registration_Get_All]                                      
        AS                                      
        BEGIN   
            SELECT                                      
                sr.Student_Reg_Id,
                ccc.Candidate_idNo,                      
                sr.Candidate_Id,  
                cpd.IDMatrixNo,                                    
                sr.Candidate_Id AS ID,                            
                SG.BloodGroup,                            
                cpd.IdentificationNo AS IdentificationNo ,              
                cpd.AdharNumber,                            
                cpd.Candidate_Gender AS Gender,
                cpd.Candidate_Nationality,                                  
                cpd.Candidate_Gender,                                      
                cpd.Candidate_Dob AS DOB,                                      
                D.Department_Name AS Class,                                      
                Tbl_Course_Category.Course_Category_Id,
                cpd.Race,                                    
                D.Department_Id,                                      
                CUR.University_Regno AS Student_Reg_No,                                  
                sr.Student_Reg_Status,                      
                cpd.Candidate_Fname,                                      
                cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname AS CandidateName,                       
                ccd.Candidate_Email,                                      
                Tbl_Course_Category.Course_Category_Id,                                      
                Tbl_Course_Category.Course_Category_Name AS [Category],                       
                NA.Batch_Id AS BatchID,                    
                Batch_Code + ''-'' + Semester_Code AS Batch,                    
                Tbl_Course_Duration_Mapping.Duration_Mapping_Id,
                Semester_Name ,                                 
                CBD.Batch_Code AS BatchCode,                       
                (CASE WHEN SR.UserId IS NULL THEN '''' ELSE ISNULL(E.Employee_FName, ''Admin'') END) AS UserName,                                     
                Tbl_Student_Semester.Student_Semester_Current_Status AS newstatus,                                 
                Tbl_Course_Duration_Mapping.Course_Department_Id,                               
                Tbl_Course_Department.Course_Category_Id,                                 
                Tbl_Course_Department.Department_Id,                                 
                D.Department_Name AS Department,                                 
                Tbl_Course_Category.Course_Category_Name,
                Visa, VisaFrom, VisaTo, Passport, PassportFrom, PassportDate                                 
            FROM Tbl_Student_Registration sr                       
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = (SELECT Employee_Id FROM dbo.Tbl_Employee_User WHERE [User_Id] = sr.UserId)                                     
            LEFT JOIN Tbl_Candidate_Personal_Det cpd ON cpd.Candidate_Id = sr.Candidate_Id                       
            INNER JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id                       
            INNER JOIN dbo.Tbl_Candidate_ContactDetails ccd ON ccd.Candidate_Id = cpd.Candidate_Id                                  
            LEFT JOIN Tbl_Course_Category cc ON cc.Course_Category_Id = sr.Course_Category_Id                                  
            LEFT JOIN Tbl_Student_Semester ON Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                  
            LEFT JOIN Tbl_Course_Duration_Mapping ON Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                     
            INNER JOIN Tbl_Course_Duration_PeriodDetails CP ON Tbl_Course_Duration_Mapping.Duration_Period_Id = CP.Duration_Period_Id                     
            INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id                    
            INNER JOIN Tbl_Course_Semester SE ON CP.Semester_Id = SE.Semester_Id                              
            LEFT JOIN Tbl_Course_Department ON dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Department_Id                                 
            LEFT JOIN Tbl_Course_Category ON Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id            
            LEFT JOIN Tbl_Course_Level ON Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id                                 
            LEFT JOIN Tbl_Department D ON Tbl_Course_Department.Department_Id = D.Department_Id                                   
            LEFT JOIN dbo.Tbl_Student_Health_General SG ON SG.StudentId = cpd.Candidate_Id                                     
            LEFT JOIN Tbl_Candidate_University_Regno CUR ON CUR.Candidate_Id = sr.Candidate_Id  
            INNER JOIN dbo.Tbl_Candidate_ContactDetails ccc ON ccc.Candidate_Id = cpd.Candidate_Id                                 
            WHERE Tbl_Student_Semester.Student_Semester_Current_Status = 1 
            AND cpd.Candidate_DelStatus = 0                                     
        END
    ')
END;

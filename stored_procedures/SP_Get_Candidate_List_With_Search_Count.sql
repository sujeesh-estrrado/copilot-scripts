IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_List_With_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_Candidate_List_With_Search_Count]     
    @SearchTerm varchar(100)                                    
    AS                                    
    BEGIN       
        SELECT 
            ROW_NUMBER() OVER (ORDER BY CPD.Candidate_Id) AS RowNumber,    
            CPD.Candidate_Id AS ID,    
            CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS [Candidate Name],   
            CPD.IdentificationNo AS [ID No],  
            SG.BloodGroup AS [Blood Group],  
            CCat.Course_Category_Name AS [Category],     
            CASE WHEN NA.Department_Id = 0 THEN ''Unspecified''  
                 ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
            END AS Department,  
            cbd.Batch_Code AS Batch,    
            CC.Candidate_ContAddress AS Address,  
            CC.Candidate_Mob1 AS [Mobile No],   
            CC.Candidate_Email AS [Email]                              
        FROM Tbl_Candidate_Personal_Det CPD                                          
        LEFT JOIN Tbl_Candidate_ContactDetails CC 
            ON CPD.Candidate_Id = CC.Candidate_Id                   
        LEFT JOIN dbo.Tbl_Student_Semester SS 
            ON SS.Candidate_Id = CPD.Candidate_Id      
            AND SS.Student_Semester_Delete_Status = 0   
            AND SS.student_semester_current_status = 1               
        LEFT JOIN Tbl_Course_Duration_Mapping cdm   
            ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id                       
        LEFT JOIN Tbl_Course_Duration_PeriodDetails cdp 
            ON cdm.Duration_Period_Id = cdp.Duration_Period_Id                          
        LEFT JOIN Tbl_Course_Batch_Duration cbd 
            ON cbd.Batch_Id = cdp.Batch_Id                           
        LEFT JOIN Tbl_Course_Semester cs 
            ON cs.Semester_Id = cdp.Semester_Id                                       
        LEFT JOIN tbl_New_Admission NA 
            ON NA.New_Admission_Id = CPD.New_Admission_Id                                                                                                   
        LEFT JOIN Tbl_Course_Level CL 
            ON CL.Course_Level_Id = NA.Course_Level_Id                                                          
        LEFT JOIN Tbl_Course_Category CCat 
            ON CCat.Course_Category_Id = NA.Course_Category_Id                                                                             
        LEFT JOIN Tbl_Student_Registration SR 
            ON CPD.Candidate_Id = SR.Candidate_Id                                         
        LEFT JOIN Tbl_Employee E 
            ON E.Employee_Id = (SELECT Employee_Id FROM dbo.Tbl_Employee_User WHERE [User_Id] = SR.UserId)                         
        LEFT JOIN dbo.Tbl_Student_Health_General SG 
            ON SG.StudentId = CPD.Candidate_Id                                   
        WHERE CPD.Candidate_DelStatus = 0     
        AND (
            CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname LIKE ''%'' + @SearchTerm + ''%''    
            OR CPD.IdentificationNo LIKE ''%'' + @SearchTerm + ''%''     
            OR SG.BloodGroup LIKE ''%'' + @SearchTerm + ''%''        
            OR CCat.Course_Category_Name LIKE ''%'' + @SearchTerm + ''%''     
            OR CAST(NA.Department_Id AS VARCHAR) LIKE ''%'' + @SearchTerm + ''%''      
            OR cbd.Batch_Code LIKE ''%'' + @SearchTerm + ''%''    
            OR CC.Candidate_ContAddress LIKE ''%'' + @SearchTerm + ''%''    
            OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''    
            OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''      
        )           
    END
    ');
END;
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[proc_Get_Cantidate_List_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[proc_Get_Cantidate_List_new] 
        AS
        BEGIN
            SELECT 
                CPD.Candidate_Id AS ID,
                SG.BloodGroup,                                                    
                CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName,                                                 
                CPD.Candidate_Fname,
                CPD.AdharNumber,                                                                
                CPD.Candidate_Dob AS DOB,                                                      
                CPD.New_Admission_Id AS AdmnID,                     
                CC.Candidate_idNo AS IdentificationNumber,                                          
                CC.Candidate_ContAddress AS Address,                                                        
                CC.Candidate_Mob1 AS MobileNumber,                                                      
                CC.Candidate_Email AS EmailID,                                               
                CCat.Course_Category_Id,                                  
                cbd.Batch_Id AS BatchID,                                              
                cbd.Batch_Code AS Batch_Code, --Batch,                      
                NA.Batch_Id,                     
                (CASE 
                    WHEN SR.UserId IS NULL THEN '''' 
                    ELSE ISNULL(E.Employee_FName, ''Admin'') 
                END) AS UserName,                                                                                                    
                NA.Course_Level_Id AS [LevelID],
                CL.Course_Level_Name AS [LevelName],                                                      
                NA.Course_Category_Id AS CategoryID,
                CCat.Course_Category_Name AS [Category],                                                
                NA.Department_Id AS DepartmentID,                                           
                CASE 
                    WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
                    ELSE (SELECT D.Department_Name 
                          FROM Tbl_Department D 
                          WHERE D.Department_Id = NA.Department_Id)  
                END AS Department,
                D.Course_Code     
            FROM 
                Tbl_Candidate_Personal_Det CPD                                                      
            LEFT JOIN  
                Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                               
            LEFT JOIN                                
                dbo.Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id   
                AND SS.Student_Semester_Delete_Status = 0                             
                AND ss.student_semester_current_status = 1                             
            LEFT JOIN                                   
                Tbl_Course_Duration_Mapping cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id                                   
            LEFT JOIN 
                Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id                                      
            LEFT JOIN 
                Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = cdp.Batch_Id                                       
            LEFT JOIN 
                Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id       
            LEFT JOIN 
                tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id                                               
            LEFT JOIN 
                Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id                                   
            LEFT JOIN 
                Tbl_Course_Category CCat ON CCat.Course_Category_Id = NA.Course_Category_Id                       
            LEFT JOIN  
                Tbl_Department D ON NA.Department_Id = D.Department_Id                                                    
            LEFT JOIN 
                Tbl_Student_Registration SR ON CPD.Candidate_Id = SR.Candidate_Id                                                     
            LEFT JOIN 
                Tbl_Employee E ON E.Employee_Id = (SELECT Employee_Id 
                                                    FROM dbo.Tbl_Employee_User 
                                                    WHERE [User_Id] = SR.UserId)                            
            LEFT JOIN 
                dbo.Tbl_Student_Health_General SG ON SG.StudentId = CPD.Candidate_Id  
            WHERE 
                CPD.Candidate_DelStatus = 0
        END
    ')
END

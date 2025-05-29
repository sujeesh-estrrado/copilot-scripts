IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_TcIssued_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_GetAll_TcIssued_List]                            
        AS                            
        BEGIN                            
            SELECT 
                sg.Tc_Remarks, 
                cdm.Duration_Mapping_Id AS ID,                              
                ISNULL(pd.Candidate_Fname, '''') + '' '' + ISNULL(pd.Candidate_Mname, '''') + '' '' + ISNULL(pd.Candidate_Lname, '''') AS CandidateName,                                    
                Batch_Code + ''-'' + Semester_Code AS Old_SemesterName,
                cdm.Course_Department_Id,            
                CONVERT(VARCHAR, sg.Tc_Date, 101) AS PromoteTo_Date,                        
                CONVERT(VARCHAR, sg.Tc_Date, 101) AS PromoteFrom_Date,
                D.Course_Code,                             
                pd.Candidate_Id,
                ss.Old_SemesterName AS BatchSemester,
                CCat.Course_Category_Name AS Category,
                d.Department_Name,         
                CASE          
                    WHEN sg.Tc_Status = 1 THEN ''Tc Issue''        
                    WHEN sg.Tc_Status = 2 THEN ''Drop''        
                    WHEN sg.Tc_Status = 3 THEN ''Defer''   
                    WHEN sg.Tc_Status = 4 THEN ''Withdraw''       
                    WHEN sg.Tc_Status = 5 THEN ''Cancel''
                    WHEN sg.Tc_Status = 6 THEN ''Transfer Institution''
                    WHEN sg.Tc_Status = 7 THEN ''Drop with Police Report''
                END AS Tc_Status                               
            FROM 
                Tbl_Candidate_Personal_Det pd                             
                INNER JOIN dbo.Tbl_Student_Semester ss 
                    ON ss.Candidate_Id = pd.Candidate_Id 
                    AND ss.Student_Semester_Current_Status = 1                            
                INNER JOIN Tbl_Course_Duration_Mapping cdm 
                    ON cdm.Duration_Mapping_Id = ss.Duration_Mapping_Id                                     
                INNER JOIN Tbl_Course_Duration_PeriodDetails cdp 
                    ON cdm.Duration_Period_Id = cdp.Duration_Period_Id                                      
                INNER JOIN Tbl_Course_Batch_Duration cbd 
                    ON cbd.Batch_Id = cdp.Batch_Id                                        
                INNER JOIN Tbl_Course_Semester cs 
                    ON cs.Semester_Id = cdp.Semester_Id                                  
                INNER JOIN dbo.Tbl_Student_Registration sg 
                    ON pd.Candidate_Id = sg.Candidate_Id                      
                LEFT JOIN tbl_New_Admission NA 
                    ON NA.New_Admission_Id = pd.New_Admission_Id                      
                LEFT JOIN Tbl_Course_Category CCat 
                    ON CCat.Course_Category_Id = NA.Course_Category_Id                      
                LEFT JOIN dbo.Tbl_Course_Department cd 
                    ON cd.Course_Department_Id = cdm.Course_Department_Id                        
                LEFT JOIN dbo.Tbl_Department d 
                    ON d.Department_Id = cd.Department_Id               
            WHERE  
                pd.Candidate_DelStatus = 1                            
            ORDER BY  
                Old_SemesterName                          
        END
    ')
END

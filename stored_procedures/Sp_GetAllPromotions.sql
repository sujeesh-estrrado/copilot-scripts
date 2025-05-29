IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllPromotions]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_GetAllPromotions]                    
    AS                    
    BEGIN                    
        SELECT DISTINCT 
            cdm.Duration_Mapping_Id AS ID,                
            pd.Candidate_Fname + '' '' + ISNULL(pd.Candidate_Mname, '''') + '' '' + pd.Candidate_Lname AS CandidateName,                      
            cbd.Batch_Code + ''-'' + cs.Semester_Code AS BatchSemester,
            d.Department_Id,
            CONVERT(VARCHAR, ss.PromoteFrom_Date, 101) AS PromoteFrom_Date,
            CONVERT(VARCHAR, ss.PromoteTo_Date, 101) AS PromoteTo_Date,                
            pd.Candidate_Id,
            ss.Old_SemesterName,
            CCat.Course_Category_Name AS Category,
            d.Department_Name,
            ''Tc_Status'' AS Tc_Status  -- Check if ''Tc_Status'' needs to be replaced with an actual column
        FROM Tbl_Course_Duration_Mapping cdm                         
        INNER JOIN Tbl_Course_Duration_PeriodDetails cdp 
            ON cdm.Duration_Period_Id = cdp.Duration_Period_Id                        
        INNER JOIN Tbl_Course_Batch_Duration cbd 
            ON cbd.Batch_Id = cdp.Batch_Id                         
        INNER JOIN Tbl_Course_Semester cs 
            ON cs.Semester_Id = cdp.Semester_Id                        
        INNER JOIN dbo.Tbl_Student_Semester ss 
            ON cdm.Duration_Mapping_Id = ss.Duration_Mapping_Id                    
        INNER JOIN dbo.Tbl_Candidate_Personal_Det pd 
            ON pd.Candidate_Id = ss.Candidate_Id 
            AND pd.Candidate_DelStatus = 0             
        INNER JOIN tbl_New_Admission NA 
            ON NA.New_Admission_Id = pd.New_Admission_Id         
        LEFT JOIN Tbl_Course_Department cd 
            ON cdm.Course_Department_Id = cd.Course_Department_Id              
        LEFT JOIN Tbl_Course_Category CCat 
            ON cd.Course_Category_Id = CCat.Course_Category_Id              
        LEFT JOIN Tbl_Course_Level cl 
            ON CCat.Course_level_Id = cl.Course_level_Id              
        LEFT JOIN Tbl_Department d 
            ON cd.Department_Id = d.Department_Id                  
        ORDER BY BatchSemester;                         
    END')
END;

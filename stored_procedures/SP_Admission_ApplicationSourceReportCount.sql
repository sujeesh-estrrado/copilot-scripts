IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_ApplicationSourceReportCount]') 
    AND type = 'P' -- Type 'P' represents a stored procedure
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Admission_ApplicationSourceReportCount]   
        @flag BIGINT = 0,        
        @SourceId BIGINT = 0,    
        @IntakeId BIGINT = 0, 
        @Intake VARCHAR(MAX) = '''',
        @DeptID BIGINT = 0  
    AS  
    BEGIN  
        IF (@flag = 1)  
        BEGIN  
            SELECT COUNT(*) AS Count 
            FROM (
                SELECT            
                    CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                    COUNT(D.Department_Name) AS Total        
                FROM         
                    Tbl_Candidate_Personal_Det pd          
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id          
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = Ad.Batch_Id          
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID          
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = Ad.Department_Id  
                    LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = D.GraduationTypeId
                    LEFT JOIN Tbl_Organzations Og ON og.Organization_Id = pd.CounselorCampus         
                WHERE           
                    (IM.id IN (SELECT CAST(Item AS BIGINT) FROM dbo.SplitString(@Intake, '','')) OR @Intake = '''')         
                    AND (@DeptID = 0 OR CL.Course_Level_Id = @DeptID)           
                GROUP BY         
                    D.Department_Name, D.Course_Code        
            ) AS SubQuery;
        END  
        ELSE IF (@flag = 2)  
        BEGIN  
            SELECT COUNT(*) AS Count
            FROM (
                SELECT       
                    DISTINCT pd.[CounselorEmployee_id] AS Employee_Id, CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name, 
                    D.Course_Code, D.Department_Name, COUNT(D.Department_Name) AS Total      
                FROM [dbo].[Tbl_Candidate_Personal_Det] pd      
                INNER JOIN Tbl_Employee E ON pd.[CounselorEmployee_id] = E.Employee_Id      
                INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id      
                INNER JOIN tbl_Role R ON R.role_Id = RA.role_id AND (R.role_Name = ''Counsellor'') AND Employee_Status = 0      
                LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id          
                LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id          
                LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID          
                LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id     
                LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = D.GraduationTypeId
                LEFT JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.CounselorCampus         
                WHERE       
                    (IM.id IN (SELECT CAST(Item AS BIGINT) FROM dbo.SplitString(@Intake, '','')) OR @Intake = '''')
                    AND (@DeptID = 0 OR CL.Course_Level_Id = @DeptID)                
                GROUP BY         
                    D.Department_Name, D.Course_Code, pd.[CounselorEmployee_id], CONCAT(Employee_FName, '' '', Employee_LName) 
            ) AS SubQuery;
        END  
        ELSE IF (@flag = 3)  
        BEGIN  
            SELECT COUNT(*) AS Count
            FROM (
                SELECT      
                    DISTINCT pd.[Candidate_Id], CONCAT(pd.[Candidate_Fname], '' '', pd.[Candidate_Lname]) AS Employee_Name,      
                    ISNULL(pd.[Passport], '''') AS Passport, ISNULL(D.Department_Name, '''') AS Department_Name      
                FROM [dbo].[Tbl_Candidate_Personal_Det] pd      
                INNER JOIN Tbl_Employee E ON pd.[CounselorEmployee_id] = E.Employee_Id      
                INNER JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id          
                INNER JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id          
                INNER JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID          
                INNER JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id 
                LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = D.GraduationTypeId
                INNER JOIN [Tbl_Organzations] Og ON og.Organization_Id = pd.CounselorCampus        
                WHERE      
                    (IM.id IN (SELECT CAST(Item AS BIGINT) FROM dbo.SplitString(@Intake, '','')) OR @Intake = '''')         
                    AND (@DeptID = 0 OR CL.Course_Level_Id = @DeptID)        
                    AND (@SourceId = 0 OR pd.[CounselorEmployee_id] = @SourceId)      
                GROUP BY         
                    pd.[Candidate_Id], D.Department_Name, D.Course_Code, pd.[CounselorEmployee_id],      
                    CONCAT(pd.[Candidate_Fname], '' '', pd.[Candidate_Lname]), pd.[Passport]  
            ) AS SubQuery;
        END  
    END;
    ');
END;
GO

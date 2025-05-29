IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_ManPowerDetails]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_ManPowerDetails] --0,1,'''',10,1                                      
    @flag BIGINT = 0,                                      
    @Manpower_Id BIGINT = 0,                                     
    @Searchkey VARCHAR(MAX),                        
    @PageSize BIGINT,                        
    @CurrentPage BIGINT                        
                                      
    AS                                       
    BEGIN                                       
        IF (@flag = 0)                                     
        BEGIN                                     
            SELECT M.Manpower_ID,
                   Document_No,    
                   (CASE WHEN M.Prepared_By = 0 THEN ''Admin'' ELSE CONCAT(EM.Employee_FName, '' '', EM.Employee_LName) END) AS EmployeeName,                                    
                   D.Course_Level_Name,
                   O.Organization_Name,
                   M.Created_Date,    
                   CASE WHEN Revision_No > 0 THEN CONVERT(VARCHAR(10), M.[Update_Date], 111) ELSE ''Not Revised'' END AS RevisionDate,    
                   CASE WHEN M.[Approved_By_Dean] = 0 THEN ''Not Approved'' ELSE ''Approved'' END AS Approved_By_DeanStatus,    
                   CASE WHEN M.[Approved_By_BoardOfManagement] = 0 THEN ''Not Approved'' ELSE ''Approved'' END AS Approved_By_BoardOfManagementStatus    
            FROM Tbl_ManPower_Details M                                     
            LEFT JOIN Tbl_Employee EM ON EM.Employee_Id = M.Prepared_By                                     
            LEFT JOIN Tbl_Course_Level D ON D.Course_Level_Id = M.Dept_Id                                     
            LEFT JOIN [Tbl_Organzations] O ON O.Organization_Id = M.Org_Id   
            WHERE Status = 0 AND M.Del_Status = 0                     
            AND ((Document_No LIKE ''%'' + @Searchkey + ''%'')                             
                OR (D.Course_Level_Name LIKE ''%'' + @Searchkey + ''%'')                              
                OR (EM.Employee_FName LIKE ''%'' + @Searchkey + ''%'')                             
                OR (D.Course_Level_Name LIKE ''%'' + @Searchkey + ''%'')                              
                OR (M.Created_Date LIKE ''%'' + @Searchkey + ''%'')                        
                OR @Searchkey = '''')                        
            ORDER BY Document_No                             
            OFFSET @PageSize * (@CurrentPage - 1) ROWS                             
            FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                            
        END                                     
                                      
        IF (@flag = 1)                                     
        BEGIN                                     
            SELECT M.Manpower_ID,
                   Document_No,
                   M.Prepared_By,
                   (CASE WHEN M.Prepared_By = 0 THEN ''Admin'' ELSE R.role_Name END) AS role_Name,      
                   (CASE WHEN M.Prepared_By = 0 THEN ''Admin'' ELSE CONCAT(EM.Employee_FName, '' '', EM.Employee_LName) END) AS EmployeeName,    
                   M.Dept_Id,
                   M.Org_Id,
                   M.Date_of_Submission,    
                   CASE WHEN Revision_No > 0 THEN CONVERT(VARCHAR(10), M.[Update_Date], 111) ELSE ''Not Revised'' END AS RevisionDate,    
                   CASE WHEN M.[Approved_By_Dean] = 0 THEN ''Not Approved'' ELSE ''Approved'' END AS Approved_By_DeanStatus,    
                   CASE WHEN M.[Approved_By_BoardOfManagement] = 0 THEN ''Not Approved'' ELSE ''Approved'' END AS Approved_By_BoardOfManagementStatus,
                   D.Course_Level_Name,
                   O.Organization_Name,
                   M.Created_Date 
            FROM Tbl_ManPower_Details M                                     
            LEFT JOIN Tbl_Employee EM ON EM.Employee_Id = M.Prepared_By                                     
            LEFT JOIN Tbl_Course_Level D ON D.Course_Level_Id = M.Dept_Id                                    
            LEFT JOIN [Tbl_Organzations] O ON O.Organization_Id = M.Org_Id                                     
            LEFT JOIN Tbl_RoleAssignment RA ON RA.employee_id = M.Prepared_By                                     
            LEFT JOIN tbl_Role R ON R.role_Id = RA.role_id                         
            WHERE M.Manpower_ID = @Manpower_Id AND Status = 0 AND M.Del_Status = 0                                     
        END                          
                                      
        IF (@flag = 2)                                     
        BEGIN                                     
            SELECT *, Department_Name 
            FROM Tbl_ManPower_Analysis M                             
            LEFT JOIN Tbl_Department D ON D.Department_Id = M.Programme_ID 
            WHERE M.Manpower_ID = @Manpower_Id AND Del_Status = 0                             
        END                              
                                      
        IF (@flag = 3)                                     
        BEGIN                                     
            SELECT *, Department_Name 
            FROM Tbl_ManPower_TeachingLoad M                             
            LEFT JOIN Tbl_Department D ON D.Department_Id = M.Programme_Id 
            WHERE M.Manpower_ID = @Manpower_Id AND Del_Status = 0                             
        END                             
                                      
        IF (@flag = 4)                              
        BEGIN                                     
            SELECT * 
            FROM Tbl_ManPower_Details M 
            WHERE M.Manpower_ID = @Manpower_Id AND Status = 0 AND M.Del_Status = 0                                     
        END                        
                                      
        IF (@flag = 5)                                      
        BEGIN                                     
            SELECT * 
            FROM Tbl_JobApplication_Deatils M 
            WHERE M.Job_Id = @Manpower_Id AND Del_status = 0                                     
        END                          
                                      
        IF (@flag = 6)                                      
        BEGIN                                     
            SELECT * 
            FROM Tbl_JobApp_Attachments M 
            WHERE M.Job_Id = @Manpower_Id AND Status = 0                                     
        END              
                                      
        IF (@flag = 7)                                      
        BEGIN                                     
            SELECT * 
            FROM [dbo].[Tbl_JobApp_Academic_Transcripts_Attachment]  
            WHERE Job_Id = @Manpower_Id AND [Del_Status] = 0                                     
        END              
                                      
        IF (@flag = 8)                                      
        BEGIN                                     
            SELECT * 
            FROM [dbo].[Tbl_JobApp_Certificate_Copies_Attachment] 
            WHERE Job_Id = @Manpower_Id AND [Del_Status] = 0                                     
        END      
                                      
        IF (@flag = 9)                                      
        BEGIN                                     
            UPDATE Tbl_ManPower_Details 
            SET Del_Status = 1 
            WHERE Manpower_ID = @Manpower_Id                                
        END   
    END 
    ')
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Agent_CommissionMappings]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_Agent_CommissionMappings]    
    (
        @Flag BIGINT = 0,    
        @Searchterm VARCHAR(MAX) = '''',    
        @FacultyId BIGINT = 0,    
        @programid BIGINT = 0,    
        @ActiveStatus BIT = NULL,    
        @Commission_GroupId BIGINT = 0    
    )                  
    AS                  
    BEGIN      
        IF (@Flag = 0)    
        BEGIN  
            SELECT DISTINCT 
                CM.Mapping_Id,
                CM.Commission_Group_Id,
                CG.GroupName,
                CM.Faculty_Id,
                CM.Programme_Id,
                CASE 
                    WHEN Type = 2 THEN ''Agent'' 
                    ELSE ''Employee'' 
                END AS Type,
                CM.Intake_Id,
                CASE 
                    WHEN Type = 2 THEN AG.Agent_Name 
                    ELSE CONCAT(EM.Employee_FName, '' '', EM.Employee_LName) 
                END AS AgentName,   
                L.Course_Level_Name AS Faculty,
                BD.Batch_Code AS Intake,
                CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Programme,
                CONVERT(VARCHAR, CG.Created_Date, 103) AS Created_Date,    
                CASE 
                    WHEN CM.ActiveStatus = 0 THEN ''Active'' 
                    ELSE ''InActive'' 
                END AS ActiveStatus,
                CG.GroupName AS CommissionGroup,   
                CASE 
                    WHEN CG.Created_By = 1 THEN ''Admin'' 
                    WHEN CG.Created_By = 0 THEN ''Admin'' 
                    ELSE CONCAT(E.Employee_Fname, '' '', E.Employee_Lname)
                END AS CreatedBy    
            FROM 
                Tbl_CommissionMapping CM
            LEFT JOIN 
                Tbl_CommissionGroup CG ON CG.Commission_GroupId = CM.Commission_Group_Id  
            LEFT JOIN 
                Tbl_Agent AG ON AG.Agent_ID = CM.Agent_Employee_Id
            LEFT JOIN 
                Tbl_Employee EM ON EM.Employee_Id = CM.Agent_Employee_Id
            LEFT JOIN 
                Tbl_Employee E ON E.Employee_Id = CM.Created_By    
            LEFT JOIN 
                Tbl_Course_Level L ON L.Course_Level_Id = CM.Faculty_Id    
            LEFT JOIN 
                Tbl_Department D ON D.Department_Id = CM.Programme_Id    
            LEFT JOIN 
                Tbl_Course_Batch_Duration BD ON BD.Batch_Id = CM.Intake_Id    
            WHERE 
                (CM.Faculty_Id = @FacultyId OR @FacultyId = 0)    
                AND (CM.Programme_Id = @programid OR @programid = 0)    
                AND (CM.ActiveStatus = @ActiveStatus OR @ActiveStatus IS NULL)    
                AND (
                    GroupName LIKE CONCAT(''%'', @Searchterm, ''%'')     
                    OR Course_Level_Name LIKE CONCAT(''%'', @Searchterm, ''%'')     
                    OR Batch_Code LIKE CONCAT(''%'', @Searchterm, ''%'')     
                    OR Course_Code LIKE CONCAT(''%'', @Searchterm, ''%'')     
                    OR Department_Name LIKE CONCAT(''%'', @Searchterm, ''%'')
                ) 
                AND CM.Delete_Status = 0;
        END    
        
        IF (@Flag = 1)    
        BEGIN    
            UPDATE Tbl_CommissionMapping 
            SET 
                ActiveStatus = @ActiveStatus,
                Updated_Date = GETDATE() 
            WHERE 
                Mapping_Id = @Commission_GroupId;    
            
            SELECT 
                ActiveStatus AS active       
            FROM 
                Tbl_CommissionMapping 
            WHERE  
                Mapping_Id = @Commission_GroupId;    
        END       
        
        IF (@Flag = 2)    
        BEGIN    
            UPDATE Tbl_CommissionMapping 
            SET 
                Delete_Status = 1,
                Updated_Date = GETDATE() 
            WHERE 
                Mapping_Id = @Commission_GroupId;    
        END      
    END    
    ')
END

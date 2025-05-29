IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Agent_CommissionGroup]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_Agent_CommissionGroup]      
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
                CG.Commission_GroupId, 
                CG.GroupName,
                CG.FacultyId,
                CG.ProgrammeId,
                CG.IntakeId,
                CG.International_Amount,
                CG.Local_Amount,      
                L.Course_Level_Name,
                BD.Batch_Code,
                CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                CONVERT(VARCHAR, CG.Created_Date, 103) AS Created_Date,      
                CASE 
                    WHEN CG.ActiveStatus = 0 THEN ''Active'' 
                    ELSE ''InActive'' 
                END AS ActiveStatus, 
                CASE 
                    WHEN GroupType = 1 THEN ''Employee'' 
                    WHEN GroupType = 2 THEN ''Agent/Partner'' 
                    ELSE ''N/A''
                END AS GroupType,  
                CASE 
                    WHEN CG.Created_By = 1 THEN ''Admin'' 
                    WHEN CG.Created_By = 0 THEN ''Admin'' 
                    ELSE CONCAT(E.Employee_Fname, '' '', E.Employee_Lname)
                END AS CreatedBy      
            FROM 
                Tbl_CommissionGroup CG      
            LEFT JOIN 
                Tbl_Employee E ON E.Employee_Id = CG.Created_By      
            LEFT JOIN 
                Tbl_Course_Level L ON L.Course_Level_Id = CG.FacultyId      
            LEFT JOIN 
                Tbl_Department D ON D.Department_Id = CG.ProgrammeId      
            LEFT JOIN 
                Tbl_Course_Batch_Duration BD ON BD.Batch_Id = CG.IntakeId      
            WHERE 
                (FacultyId = @FacultyId OR @FacultyId = 0)      
                AND (ProgrammeId = @programid OR @programid = 0)      
                AND (ActiveStatus = @ActiveStatus OR @ActiveStatus IS NULL)      
                AND (
                    GroupName LIKE CONCAT(''%'', @Searchterm, ''%'')       
                    OR Course_Level_Name LIKE CONCAT(''%'', @Searchterm, ''%'')       
                    OR Batch_Code LIKE CONCAT(''%'', @Searchterm, ''%'')       
                    OR Course_Code LIKE CONCAT(''%'', @Searchterm, ''%'')       
                    OR Department_Name LIKE CONCAT(''%'', @Searchterm, ''%'')
                ) 
                AND CG.Delete_Status = 0    
            ORDER BY 
                CG.Commission_GroupId DESC;
        END      
      
        IF (@Flag = 1)      
        BEGIN      
            UPDATE Tbl_CommissionGroup 
            SET 
                ActiveStatus = @ActiveStatus,
                Updated_Date = GETDATE() 
            WHERE 
                Commission_GroupId = @Commission_GroupId;      
            
            SELECT 
                ActiveStatus AS active      
            FROM 
                Tbl_CommissionGroup 
            WHERE  
                Commission_GroupId = @Commission_GroupId;      
        END         
      
        IF (@Flag = 2)      
        BEGIN      
            UPDATE Tbl_CommissionGroup 
            SET 
                Delete_Status = 1,
                Updated_Date = GETDATE() 
            WHERE 
                Commission_GroupId = @Commission_GroupId;      
        END        
    END      
    ')
END

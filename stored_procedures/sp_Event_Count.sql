IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Event_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Event_Count]
            @flag BIGINT = 0,        
            @Employee_Id BIGINT = 0, 
            @Searchkey VARCHAR(50) = ''''
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT COUNT(ED.Event_Id) AS Counts
                FROM Tbl_Event_Details ED          
                LEFT JOIN tbl_Employee E ON E.Employee_Id = ED.EventLeader    
                LEFT JOIN Tbl_Pso_Approval PA ON PA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_Marketing_ManangerApproval MA ON MA.Marketing_ManagerApproval_ID = ED.MarketingMangerApproval_ID    
                LEFT JOIN Tbl_Director_Approvals DA ON DA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_MD_Approval BA ON BA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_Teams T ON T.Team_Id = ED.Team_Id  
                WHERE ED.Del_Status = 0 
                AND (DA.Approval_Status != 2 OR BA.Approval_Status != 2) 
                AND ED.EventLeader = @Employee_Id 
                AND ((ED.EventName LIKE ''%'' + @Searchkey + ''%'')     
                    OR (Agent LIKE ''%'' + @Searchkey + ''%'')      
                    OR (CONCAT(Employee_FName, '' '', Employee_LName) LIKE ''%'' + @Searchkey + ''%'')    
                    OR (Ed.TypeOfEvent LIKE ''%'' + @Searchkey + ''%'')     
                    OR (International_or_Local LIKE ''%'' + @Searchkey + ''%'')    
                    OR (T.Team_Name LIKE ''%'' + @Searchkey + ''%'')      
                    OR @Searchkey = '''')
            END

            IF (@flag = 1)
            BEGIN
                SELECT COUNT(ED.Event_Id) AS Counts
                FROM Tbl_Event_Details ED    
                LEFT JOIN tbl_Employee E ON E.Employee_Id = ED.EventLeader    
                LEFT JOIN Tbl_Pso_Approval PA ON PA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_Marketing_ManangerApproval MA ON MA.Marketing_ManagerApproval_ID = ED.MarketingMangerApproval_ID    
                LEFT JOIN Tbl_Director_Approvals DA ON DA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_MD_Approval BA ON BA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_Teams T ON T.Team_Id = ED.Team_Id  
                WHERE (PA.Approval_Status = 2 OR MA.Approval_Status = 2 OR DA.Approval_Status = 2 OR BA.Approval_Status = 2) 
                AND ED.EventLeader = @Employee_Id 
                AND ((ED.EventName LIKE ''%'' + @Searchkey + ''%'')     
                    OR (Agent LIKE ''%'' + @Searchkey + ''%'')      
                    OR (CONCAT(Employee_FName, '' '', Employee_LName) LIKE ''%'' + @Searchkey + ''%'')    
                    OR (Ed.TypeOfEvent LIKE ''%'' + @Searchkey + ''%'')     
                    OR (International_or_Local LIKE ''%'' + @Searchkey + ''%'')    
                    OR (T.Team_Name LIKE ''%'' + @Searchkey + ''%'')      
                    OR @Searchkey = '''')
            END

            IF (@flag = 2)
            BEGIN
                SELECT COUNT(DISTINCT ED.Event_Id) AS Counts
                FROM Tbl_Event_Details ED          
                LEFT JOIN Tbl_User E ON E.user_Id = ED.EventLeader      
                LEFT JOIN tbl_Role r ON r.role_Id = E.role_Id
                LEFT JOIN Tbl_Pso_Approval PA ON PA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_Marketing_ManangerApproval MA ON MA.Marketing_ManagerApproval_ID = ED.MarketingMangerApproval_ID    
                LEFT JOIN Tbl_Director_Approvals DA ON DA.Event_ID = ED.Event_Id    
                LEFT JOIN Tbl_MD_Approval BA ON BA.Event_ID = ED.Event_Id     
                LEFT JOIN Tbl_Teams T ON T.Team_Id = ED.Team_Id  
                WHERE ED.Del_Status = 0 
                AND (DA.Approval_Status != 2 OR BA.Approval_Status != 2) 
                AND ED.EventLeader = @Employee_Id 
                AND ((ED.EventName LIKE ''%'' + @Searchkey + ''%'')     
                    OR (Agent LIKE ''%'' + @Searchkey + ''%'')      
                    OR (r.role_Name LIKE ''%'' + @Searchkey + ''%'')    
                    OR (Ed.TypeOfEvent LIKE ''%'' + @Searchkey + ''%'')     
                    OR (International_or_Local LIKE ''%'' + @Searchkey + ''%'')    
                    OR (T.Team_Name LIKE ''%'' + @Searchkey + ''%'')      
                    OR @Searchkey = '''')
            END
        END
    ')
END

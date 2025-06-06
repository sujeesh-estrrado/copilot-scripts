IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpcomingEvents]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_UpcomingEvents]
        (
            @Flag BIGINT = 1,
            @CurrentPage INT = 1,
            @PageSize BIGINT = 10,
            @Year BIGINT = ''''
        )        
        AS
        BEGIN
            IF (@Flag = 1)                    
            BEGIN           
                SELECT DISTINCT 
                    ED.Event_Id,
                    ED.EventName,
                    ED.Agent,
                    CONCAT(Employee_FName, '' '', Employee_LName) AS EventLead,                  
                    (CASE WHEN Ed.TypeOfEvent = ''--Select--'' THEN ''-NA-'' ELSE Ed.TypeOfEvent END) AS TypeOfEvent,                  
                    CONVERT(VARCHAR, Ed.Start_Date, 105) AS Start_Date,                  
                    CONVERT(VARCHAR, Ed.End_Date, 105) AS End_Date,
                    FORMAT(CAST(ED.Time AS DATETIME), ''hh:mm tt'') AS Time,                  
                    (CASE WHEN International_or_Local = ''--Select--'' THEN ''-NA-'' ELSE International_or_Local END) AS Location,                  
                    (SELECT COUNT(*) 
                     FROM Tbl_Candidate_Personal_Det 
                     WHERE ApplicationStatus NOT IN (''Completed'', ''rejected'', ''pending'', ''Pending'') 
                     AND Event_Id = ED.Event_id) AS Conversion_to_Sales,                
                    (SELECT COUNT(*) 
                     FROM Tbl_Candidate_Personal_Det 
                     WHERE Event_Id = ED.Event_id) AS Total_Enquiry,                  
                    CONVERT(VARCHAR, ED.CreatedDate, 105) AS CreatedDate,                  
                    (CASE 
                        WHEN DA.Approval_Status = 1 THEN ''Approved By Director'' 
                        WHEN BA.Approval_Status = 1 THEN ''Approved by MD'' 
                        WHEN MA.Approval_Status = 2 OR PA.Approval_Status = 2 THEN ''Your Event Has Been Rejected. Re-Submit'' 
                        WHEN DA.Approval_Status = 2 OR BA.Approval_Status = 2 THEN ''Rejected''  
                        ELSE ''Pending'' 
                     END) AS Status,
                    T.Team_Name,
                    ED.EventVennu,
                    ED.BoothNo,
                    ED.BoothCount,
                    S.State_Name                 
                FROM Tbl_Event_Details ED                  
                LEFT JOIN Tbl_Particulars_Detailss PD ON ED.Event_Id = PD.Event_ID                  
                LEFT JOIN Tbl_Event_Staff ES ON PD.Event_ID = ES.EventID                  
                LEFT JOIN tbl_Employee E ON E.Employee_Id = ED.EventLeader                  
                LEFT JOIN Tbl_Pso_Approval PA ON PA.Event_ID = ED.Event_Id       
                LEFT JOIN Tbl_Marketing_ManangerApproval MA ON MA.Marketing_ManagerApproval_ID = ED.MarketingMangerApproval_ID                  
                LEFT JOIN Tbl_Director_Approvals DA ON DA.Event_ID = ED.Event_Id                  
                LEFT JOIN Tbl_MD_Approval BA ON BA.Event_ID = ED.Event_Id                  
                LEFT JOIN Tbl_Teams T ON T.Team_Id = ED.Team_Id      
                LEFT JOIN Tbl_State S ON S.State_Id = ED.State      
                WHERE ED.Del_Status = 0 
                    AND (DA.Approval_Status = 1 OR BA.Approval_Status = 1)      
                    AND ED.Start_Date >= DATEADD(DAY, 30, GETDATE()) 
                ORDER BY Event_Id DESC      
                OFFSET @PageSize * (@CurrentPage - 1) ROWS          
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);          
            END        
            
            IF (@Flag = 2)          
            BEGIN         
                SELECT COUNT(*) AS TotalCount FROM (
                    SELECT DISTINCT ED.Event_Id FROM Tbl_Event_Details ED                  
                    LEFT JOIN Tbl_Particulars_Detailss PD ON ED.Event_Id = PD.Event_ID                  
                    LEFT JOIN Tbl_Event_Staff ES ON PD.Event_ID = ES.EventID                  
                    LEFT JOIN tbl_Employee E ON E.Employee_Id = ED.EventLeader                  
                    LEFT JOIN Tbl_Pso_Approval PA ON PA.Event_ID = ED.Event_Id       
                    LEFT JOIN Tbl_Marketing_ManangerApproval MA ON MA.Marketing_ManagerApproval_ID = ED.MarketingMangerApproval_ID                  
                    LEFT JOIN Tbl_Director_Approvals DA ON DA.Event_ID = ED.Event_Id                  
                    LEFT JOIN Tbl_MD_Approval BA ON BA.Event_ID = ED.Event_Id                  
                    LEFT JOIN Tbl_Teams T ON T.Team_Id = ED.Team_Id      
                    LEFT JOIN Tbl_State S ON S.State_Id = ED.State      
                    WHERE ED.Del_Status = 0 
                        AND (DA.Approval_Status = 1 OR BA.Approval_Status = 1)      
                        AND ED.Start_Date >= DATEADD(DAY, 30, GETDATE())      
                ) AS BaseData;        
            END        

            IF (@Flag = 3)                    
            BEGIN     
                SELECT 
                    CONCAT(CONVERT(CHAR(3), Start_Date, 0), ''-'', YEAR(Start_Date)) AS MonthYear,
                    EventName,    
                    (SELECT COUNT(*) 
                     FROM Tbl_Candidate_Personal_Det 
                     WHERE Event_Id = ED.Event_id) AS Total_Enquiry    
                FROM Tbl_Event_Details AS ED 
                WHERE YEAR(Start_Date) = @Year    
                GROUP BY EventName, CAST(Start_Date AS DATE), Event_id 
                ORDER BY Event_Id DESC    
                OFFSET @PageSize * (@CurrentPage - 1) ROWS          
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
            END    

            IF (@Flag = 4)                    
            BEGIN     
                SELECT COUNT(*) AS TotalCount FROM (
                    SELECT 
                        CONCAT(CONVERT(CHAR(3), Start_Date, 0), ''-'', YEAR(Start_Date)) AS MonthYear,
                        EventName,    
                        (SELECT COUNT(*) 
                         FROM Tbl_Candidate_Personal_Det 
                         WHERE Event_Id = ED.Event_id) AS Total_Enquiry    
                    FROM Tbl_Event_Details AS ED 
                    WHERE YEAR(Start_Date) = @Year    
                    GROUP BY EventName, CAST(Start_Date AS DATE), Event_id    
                ) AS BaseData;        
            END     
        END
    ')
END

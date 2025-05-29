IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_List_Agent_Details_ByCounsellor]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[sp_List_Agent_Details_ByCounsellor]  
    (    
        @Active_Status VARCHAR(MAX) = '''',    
        @PageSize BIGINT = 0,    
        @CurrentPage BIGINT = 0,    
        @SearchKeyWord VARCHAR(MAX) = '''',   
        @CounsellorId BIGINT = 0,
        @Flag BIGINT = 0
    )    
    AS     
    BEGIN    
        SET NOCOUNT ON;

        IF (@Flag = 0)
        BEGIN
            IF (@Active_Status = ''Active'')
            BEGIN
                SELECT DISTINCT 
                    A.Agent_ID, 
                    A.Counsellor_Id, 
                    A.Agent_ID AS ID, 
                    A.Agent_Category_Id, 
                    C.Category_Name, 
                    UPPER(A.Agent_Name) AS Agent_Name, 
                    A.Agent_RegNo, 
                    T.Country, 
                    A.Agent_Mob,    
                    S.State_Name AS Agent_Area, 
                    Y.City_Name AS Agent_Location, 
                    LOWER(A.Agent_Email) AS Agent_Email,  
                    ISNULL(SUM(Se.Amount), 0) AS Commission,   
                    CASE 
                        WHEN PSO_Status IS NULL THEN ''Pending'' 
                        WHEN PSO_Status = 0 THEN ''Pending'' 
                        WHEN PSO_Status = 1 THEN ''Approved'' 
                    END AS PSO_Status,  
                    A.Agent_Status, 
                    AU.User_Id 
                FROM [dbo].[Tbl_Agent] A    
                LEFT JOIN Tbl_Agent_Category C ON C.Category_Id = A.Agent_Category_Id    
                LEFT JOIN Tbl_Country T ON T.Country_Id = A.Agent_Country_Id     
                LEFT JOIN Tbl_Agent_User AU ON AU.Agent_Id = A.Agent_ID     
                LEFT JOIN Tbl_State S ON A.Agent_Area = S.State_Id    
                LEFT JOIN Tbl_City Y ON A.Agent_Location = Y.City_Id    
                LEFT JOIN Tbl_Agent_Settlement Se ON A.Agent_ID = Se.AgentId    
                WHERE A.Delete_Status = 0  
                    AND A.Counsellor_Id = @CounsellorId  
                    AND A.Agent_Status = ''Active''     
                    AND (
                        A.Agent_Name LIKE CONCAT(''%'', @SearchKeyWord, ''%'')      
                        OR C.Category_Name LIKE CONCAT(''%'', @SearchKeyWord, ''%'')    
                        OR A.Agent_Email LIKE CONCAT(''%'', @SearchKeyWord, ''%'')    
                        OR A.Agent_RegNo LIKE CONCAT(''%'', @SearchKeyWord, ''%'')    
                        OR A.Agent_Mob LIKE CONCAT(''%'', @SearchKeyWord, ''%'')    
                    )    
                GROUP BY  
                    A.Agent_ID, A.Agent_Category_Id, C.Category_Name, A.Agent_Name, A.Agent_RegNo, 
                    T.Country, A.Agent_Mob, S.State_Name, Y.City_Name, A.Agent_Email, 
                    A.Agent_Status, AU.User_Id, PSO_Status, A.Counsellor_Id  
                ORDER BY ID DESC    
                OFFSET @PageSize * (CASE WHEN @CurrentPage > 0 THEN @CurrentPage - 1 ELSE 0 END) ROWS    
                FETCH NEXT @PageSize ROWS ONLY;    
            END;
        END;
    END;');
END;

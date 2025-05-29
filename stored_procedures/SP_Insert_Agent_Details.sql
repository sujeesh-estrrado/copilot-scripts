IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Agent_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Insert_Agent_Details]    
    (    
        @Flag BIGINT = 0,    
        @Agent_Category_Id BIGINT,    
        @Agent_RegNo VARCHAR(MAX),    
        @Agent_Name VARCHAR(MAX),    
        @Agent_Home VARCHAR(200),    
        @Agent_Mob VARCHAR(200),    
        @Agent_CountryId BIGINT,    
        @Agent_Area VARCHAR(MAX),    
        @Agent_Email VARCHAR(MAX),    
        @Agent_Address VARCHAR(MAX),    
        @Agent_Location VARCHAR(MAX),    
        @Nationality VARCHAR(MAX),    
        @CounsellorId BIGINT,
        @Contract_Expiry DATETIME
    )                  
    AS                  
    BEGIN
       
        
        -- Case: Insert/Update in Tbl_Agent
        IF (@Flag = 0)  
        BEGIN  
            -- Check if the agent email already exists in active records
            IF EXISTS (SELECT 1 FROM Tbl_Agent WHERE Agent_Email = @Agent_Email AND Delete_Status = 0)     
            BEGIN      
                THROW 50000, ''Data Already Exists.'', 1;    
            END    

            -- If the agent exists but is deleted, restore and update details
            ELSE IF EXISTS (SELECT 1 FROM Tbl_Agent WHERE Agent_Email = @Agent_Email AND Delete_Status = 1)       
            BEGIN    
                UPDATE dbo.Tbl_Agent 
                SET    
                    Agent_Category_Id = @Agent_Category_Id,    
                    Agent_RegNo = @Agent_RegNo,    
                    Agent_Name = @Agent_Name,    
                    Agent_Home = @Agent_Home,    
                    Agent_Mob = @Agent_Mob,    
                    Agent_Country_Id = @Agent_CountryId,    
                    Agent_Area = @Agent_Area,    
                    Agent_Email = @Agent_Email,    
                    Agent_Address = @Agent_Address,    
                    Agent_Location = @Agent_Location,    
                    Nationality = @Nationality,    
                    Updated_Date = GETDATE(),    
                    Counsellor_Id = @CounsellorId,  
                    Contract_Expiry = @Contract_Expiry,
                    Delete_Status = 0  
                WHERE Delete_Status = 1 AND Agent_Email = @Agent_Email;
            END      

            -- If the agent does not exist, insert new record
            ELSE    
            BEGIN    
                INSERT INTO dbo.Tbl_Agent(
                    Contract_Expiry,
                    Agent_Category_Id,
                    Agent_RegNo,
                    Agent_Name,
                    Agent_Home,
                    Agent_Mob,
                    Agent_Country_Id,
                    Agent_Area,
                    Agent_Email,
                    Agent_Address,
                    Agent_Location,
                    Agent_Status,
                    Created_date,
                    Delete_Status,
                    Nationality,
                    Counsellor_Id
                )                  
                VALUES (
                    @Contract_Expiry,
                    @Agent_Category_Id,
                    @Agent_RegNo,
                    @Agent_Name,
                    @Agent_Home,
                    @Agent_Mob,
                    @Agent_CountryId,
                    @Agent_Area,
                    @Agent_Email,
                    @Agent_Address,
                    @Agent_Location,
                    ''Active'',
                    GETDATE(),
                    0,
                    @Nationality,
                    @CounsellorId
                );                   
            END    
        END  

        -- Case: Insert/Update in Tbl_Temp_Agent
        ELSE IF (@Flag = 1)  
        BEGIN  
            -- Check if the agent email already exists in active records of Tbl_Temp_Agent or Tbl_Agent
            IF EXISTS (SELECT 1 FROM Tbl_Temp_Agent WHERE Temp_Agent_Email = @Agent_Email AND Delete_Status = 0)     
                OR EXISTS (SELECT 1 FROM Tbl_Agent WHERE Agent_Email = @Agent_Email AND Delete_Status = 0)     
            BEGIN      
                THROW 50000, ''Data Already Exists.'', 1;    
            END       

            -- If the agent exists in deleted state, restore and update details
            ELSE IF EXISTS (SELECT 1 FROM Tbl_Temp_Agent WHERE Temp_Agent_Email = @Agent_Email AND Delete_Status = 1)       
            BEGIN    
                UPDATE dbo.Tbl_Temp_Agent 
                SET    
                    Temp_Agent_Category_Id = @Agent_Category_Id,    
                    Temp_Agent_RegNo = @Agent_RegNo,    
                    Temp_Agent_Name = @Agent_Name,    
                    Temp_Agent_Home = @Agent_Home,    
                    Temp_Agent_Mob = @Agent_Mob,    
                    Temp_Agent_Country_Id = @Agent_CountryId,    
                    Temp_Agent_Area = @Agent_Area,    
                    Contract_Expiry = @Contract_Expiry,
                    Temp_Agent_Email = @Agent_Email,    
                    Temp_Agent_Address = @Agent_Address,    
                    Temp_Agent_Location = @Agent_Location,  
                    Temp_Nationality = @Nationality,    
                    Updated_Date = GETDATE(),    
                    Temp_Counsellor_Id = @CounsellorId,    
                    Delete_Status = 0  
                WHERE Delete_Status = 1 AND Temp_Agent_Email = @Agent_Email;
            END      

            -- If the agent does not exist, insert new record
            ELSE    
            BEGIN    
                INSERT INTO dbo.Tbl_Temp_Agent(
                    Contract_Expiry,
                    Temp_Agent_Category_Id,
                    Temp_Agent_RegNo,
                    Temp_Agent_Name,
                    Temp_Agent_Home,
                    Temp_Agent_Mob,
                    Temp_Agent_Country_Id,
                    Temp_Agent_Area,
                    Temp_Agent_Email,
                    Temp_Agent_Address,
                    Temp_Agent_Location,
                    Temp_Agent_Status,
                    Created_date,
                    Delete_Status,
                    Temp_Nationality,
                    Temp_Counsellor_Id
                )                  
                VALUES (
                    @Contract_Expiry,
                    @Agent_Category_Id,
                    @Agent_RegNo,
                    @Agent_Name,
                    @Agent_Home,
                    @Agent_Mob,
                    @Agent_CountryId,
                    @Agent_Area,
                    @Agent_Email,
                    @Agent_Address,
                    @Agent_Location,
                    ''Active'',
                    GETDATE(),
                    0,
                    @Nationality,
                    @CounsellorId
                );                   
            END    
        END  
    END;
    ');
END;

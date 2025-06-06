IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Agent_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Update_Agent_Details]  
        (  
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
            @Agent_Id BIGINT,  
            @Nationality VARCHAR(MAX),  
            @counsellorId BIGINT,
            @Contract_Expiry DATETIME = NULL
        )                
        AS                
        BEGIN    
            IF EXISTS (SELECT Temp_Agent_ID FROM Tbl_Temp_Agent WHERE Temp_Agent_ID = @Agent_ID AND Delete_Status = 0)
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
                    Temp_Agent_Email = @Agent_Email,  
                    Temp_Agent_Address = @Agent_Address,  
                    Temp_Agent_Location = @Agent_Location,
                    Temp_Nationality = @Nationality,  
                    Updated_Date = GETDATE(),  
                    Temp_Counsellor_Id = @counsellorId,
                    Contract_Expiry = @Contract_Expiry
                WHERE Delete_Status = 0 AND Temp_Agent_ID = @Agent_Id;     
            END
            ELSE
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
                    Counsellor_Id = @counsellorId,
                    Contract_Expiry = @Contract_Expiry
                WHERE Delete_Status = 0 AND Agent_ID = @Agent_Id;     
            END               
        END
    ')
END

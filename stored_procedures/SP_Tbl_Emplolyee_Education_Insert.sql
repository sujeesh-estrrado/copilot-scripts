IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Emplolyee_Education_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Emplolyee_Education_Insert]    
            @Employee_Id BIGINT,    
            @Employee_Degree VARCHAR(250),   
            @Employee_College VARCHAR(250),   
            @Employee_University VARCHAR(250),   
            @Employee_PassOutYear VARCHAR(250),   
            @Employee_Speciality VARCHAR(250),   
            @Employee_RegNo VARCHAR(250),   
            @Employee_Education_State VARCHAR(250),
            @Employee_Highest_Qualification BIT,   
            @Employee_PassOutmonth VARCHAR(250),
            @Employee_RegDate VARCHAR(250),
            @Programme VARCHAR(MAX)
        AS
        BEGIN
            INSERT INTO [dbo].[Tbl_Employee_Education]  
                ([Employee_Degree],  
                [Employee_College],  
                [Employee_University],  
                [Employee_PassOutYear],  
                [Employee_Speciality],  
                [Employee_RegNo],  
                [Employee_Education_State],  
                [Employee_Education_Status],  
                [Employee_Id],  
                [Employee_Highest_Qualification],  
                Employee_PassOutMonth,  
                Employee_RegDate,  
                Employee_Programme)
            VALUES  
                (@Employee_Degree,  
                @Employee_College,  
                @Employee_University,  
                @Employee_PassOutYear,  
                @Employee_Speciality,  
                @Employee_RegNo,  
                @Employee_Education_State,  
                0,  
                @Employee_Id,  
                @Employee_Highest_Qualification,  
                @Employee_PassOutmonth,  
                @Employee_RegDate,  
                @Programme)
        END
    ')
END

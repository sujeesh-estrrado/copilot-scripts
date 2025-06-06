IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_DriverDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Update_DriverDetails]  
        (          
            @Employee_Id BIGINT,  
            @License_Number VARCHAR(100),  
            @CurrentAge VARCHAR(5),  
            @ReportingAuthority VARCHAR(100)  
        )  
        AS  
        BEGIN  
            UPDATE [Tbl_DriverDetails]  
            SET   
                [License_Number] = @License_Number,  
                [CurrentAge] = @CurrentAge,  
                [ReportingAuthority] = @ReportingAuthority  
            WHERE [Employee_Id] = @Employee_Id;
        END
    ')
END

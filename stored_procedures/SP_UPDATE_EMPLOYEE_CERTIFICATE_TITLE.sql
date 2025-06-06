IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UPDATE_EMPLOYEE_CERTIFICATE_TITLE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_UPDATE_EMPLOYEE_CERTIFICATE_TITLE]     
            @Certificate_Id BIGINT,    
            @Title VARCHAR(50) 
        AS    
        BEGIN   
            UPDATE Tbl_Employee_Certificates  
            SET Title = @Title
            WHERE Certificate_Id = @Certificate_Id;
        END
    ')
END

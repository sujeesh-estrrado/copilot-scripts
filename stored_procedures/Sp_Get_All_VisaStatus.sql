IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_VisaStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
Create procedure [dbo].[Sp_Get_All_VisaStatus]
    
AS
BEGIN
    select Visa_Status_Id,Status_Name  from tbl_Visa_Status
END
    ')
END

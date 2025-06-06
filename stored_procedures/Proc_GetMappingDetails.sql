-- Check if the stored procedure [dbo].[Proc_GetMappingDetails] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMappingDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetMappingDetails]  
        @Emp_Id BIGINT  
        AS  
        BEGIN  
            SELECT *  
            FROM tbl_Employee_Mapping  
            WHERE Employee_Id = @Emp_Id;  
        END
    ')
END

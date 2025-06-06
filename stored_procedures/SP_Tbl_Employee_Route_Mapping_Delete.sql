IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Route_Mapping_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Route_Mapping_Delete]  
            @RouteFeeId bigint  
        AS  
        BEGIN  
            DELETE FROM Tbl_Employee_Route_Mapping   
            WHERE RouteFeeId = @RouteFeeId  
        END
    ')
END

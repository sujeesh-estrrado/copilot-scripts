IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Route_Mapping_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Route_Mapping_Insert]  
            @RouteFeeId bigint,  
            @EmployeeId bigint  
        AS  
        BEGIN  
            INSERT INTO Tbl_Employee_Route_Mapping   
            (RouteFeeId, EmployeeId)  
            VALUES  
            (@RouteFeeId, @EmployeeId)  

            SELECT @@IDENTITY  
        END
    ')
END

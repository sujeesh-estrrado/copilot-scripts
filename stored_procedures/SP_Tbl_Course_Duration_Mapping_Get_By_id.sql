IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_Mapping_Get_By_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Duration_Mapping_Get_By_id] 
            @Duration_Period_Id bigint
        AS  
        BEGIN  
            SELECT 
                Duration_Mapping_Id,
                Duration_Period_Id,
                Course_Department_Id
            FROM Tbl_Course_Duration_Mapping
            WHERE Duration_Period_Id = @Duration_Period_Id
        END
    ')
END

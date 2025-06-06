IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_Period_Details_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Duration_Period_Details_Delete]   
            @Duration_Mapping_Id bigint    
        AS   
        BEGIN          
            UPDATE dbo.Tbl_Course_Duration_Mapping   
            SET Course_Department_Status = 1    
            WHERE Duration_Mapping_Id = @Duration_Mapping_Id  
        END
    ')
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_Mapping_Delete]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Duration_Mapping_Delete]
            @Duration_Period_Id BIGINT,
            @Course_Department_Id BIGINT
        AS
        BEGIN
            DELETE FROM Tbl_Course_Duration_Mapping
            WHERE Duration_Period_Id = @Duration_Period_Id 
              AND Course_Department_Id = @Course_Department_Id
            
            SELECT @@ERROR
        END
    ')
END

IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_PeriodDetails_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Duration_PeriodDetails_Delete]
            @Duration_Period_Id BIGINT
        AS
        DECLARE @intErrorCode INT

        BEGIN TRANSACTION

        -- Update the Tbl_Course_Duration_PeriodDetails table
        UPDATE Tbl_Course_Duration_PeriodDetails
        SET Duration_Period_Status = 1
        WHERE Duration_Period_Id = @Duration_Period_Id

        SELECT @intErrorCode = @@ERROR
        IF (@intErrorCode <> 0) GOTO PROBLEM

        -- Delete from Tbl_Course_Duration_Mapping
        DELETE FROM Tbl_Course_Duration_Mapping
        WHERE Duration_Period_Id = @Duration_Period_Id

        SELECT @intErrorCode = @@ERROR
        IF (@intErrorCode <> 0) GOTO PROBLEM

        -- Commit the transaction
        COMMIT TRANSACTION

        PROBLEM:
        IF (@intErrorCode <> 0)
        BEGIN
            PRINT ''Unexpected error occurred!''
            ROLLBACK TRANSACTION
        END
    ')
END

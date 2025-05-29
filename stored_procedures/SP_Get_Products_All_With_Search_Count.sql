IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Profile_View_control]')
    AND type = N'P'
)
BEGIN
    EXEC(
    'CREATE PROCEDURE [dbo].[Sp_Get_Profile_View_control] 
    (
        @Flag BIGINT = 0,
        @Role VARCHAR(255) = '''',
        @Module VARCHAR(255) = ''''
    )
    AS
    BEGIN
        IF (@Flag = 0)
        BEGIN
            SELECT * 
            FROM Tbl_Profile_View_control 
            WHERE Status = 1 
            AND Role COLLATE SQL_Latin1_General_CP1_CI_AS = @Role COLLATE SQL_Latin1_General_CP1_CI_AS
            AND Module = @Module
        END
    END'
    )
END
GO

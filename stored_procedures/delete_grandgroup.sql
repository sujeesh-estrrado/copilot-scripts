IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[delete_grandgroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[delete_grandgroup] 
        (
            @GrandGroupCodeId BIGINT
        )
        AS
        BEGIN
            

            UPDATE dbo.Tbl_Grand_Group
            SET delstatus = 1
            WHERE GrandGroupCodeId = @GrandGroupCodeId;
        END
    ')
END

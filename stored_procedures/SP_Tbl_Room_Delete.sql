IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Room_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Room_Delete]
            @Room_Id bigint
        AS
        BEGIN
            UPDATE [Tbl_Room]
            SET Room_Status = 1
            WHERE Room_Id = @Room_Id
        END;
    ');
END;

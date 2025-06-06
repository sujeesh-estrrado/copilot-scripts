IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Active_Inactive_Agent]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Active_Inactive_Agent]
        @Agent_ID BIGINT
        AS
        BEGIN
            DECLARE @Active_Status VARCHAR(MAX);

            IF EXISTS (SELECT Temp_Agent_ID FROM Tbl_Temp_Agent WHERE Temp_Agent_ID = @Agent_ID AND Delete_Status = 0)
            BEGIN
                SET @Active_Status = (SELECT Temp_Agent_Status FROM Tbl_Temp_Agent WHERE Temp_Agent_ID = @Agent_ID AND Delete_Status = 0);

                IF (@Active_Status = ''Active'')
                BEGIN
                    UPDATE Tbl_Temp_Agent
                    SET Temp_Agent_Status = ''InActive''
                    WHERE Temp_Agent_ID = @Agent_ID;
                END
                ELSE
                BEGIN
                    UPDATE Tbl_Temp_Agent
                    SET Temp_Agent_Status = ''Active''
                    WHERE Temp_Agent_ID = @Agent_ID;
                END
            END
            ELSE
            BEGIN
                SET @Active_Status = (SELECT Agent_Status FROM Tbl_Agent WHERE Agent_ID = @Agent_ID AND Delete_Status = 0);

                IF (@Active_Status = ''Active'')
                BEGIN
                    UPDATE [dbo].[Tbl_Agent]
                    SET Agent_Status = ''InActive''
                    WHERE Agent_ID = @Agent_ID;
                END
                ELSE
                BEGIN
                    UPDATE [dbo].[Tbl_Agent]
                    SET Agent_Status = ''Active''
                    WHERE Agent_ID = @Agent_ID;
                END
            END
        END
    ');
END

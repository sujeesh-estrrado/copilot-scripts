IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Tbl_Source_name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Tbl_Source_name] 
        @name varchar(max),
        @id bigint,
        @flag bigint
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN   
                IF NOT EXISTS(SELECT * FROM tbl_source_name WHERE Sourse_Name = @name AND delete_status = 0)
                BEGIN
                    INSERT INTO tbl_source_name (Sourse_Name, delete_status) 
                    VALUES (@name, 0);
                END
            END
            
            IF (@flag = 2)
            BEGIN   
                SELECT * 
                FROM tbl_source_name 
                WHERE delete_status = 0;
            END

            IF (@flag = 3)
            BEGIN   
                UPDATE tbl_source_name 
                SET Sourse_Name = @name 
                WHERE id = @id AND delete_status = 0;
            END
        END
    ')
END

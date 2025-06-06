IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Sponsorship_candidate_mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Sponsorship_candidate_mapping] 
        (@flag BIGINT = 0, @id BIGINT = 0, @sponsonship_name VARCHAR(MAX) = '''', @candidate_id BIGINT = 0)
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                IF NOT EXISTS (
                    SELECT * FROM Tbl_Sponsorship_candidate_mapping 
                    WHERE Sponsorship_Name = @sponsonship_name AND candidate_id = @candidate_id AND delete_status = 0
                )
                BEGIN
                    INSERT INTO Tbl_Sponsorship_candidate_mapping(Sponsorship_Name, candidate_id, delete_status, Createdate)
                    VALUES (@sponsonship_name, @candidate_id, 0, GETDATE())
                END
            END

            IF (@flag = 2) -- Get records
            BEGIN
                SELECT Sponsorship_Name, Sponsorship_Mapping_id, candidate_id 
                FROM Tbl_Sponsorship_candidate_mapping 
                WHERE (candidate_id = @candidate_id)
            END

            IF (@flag = 3) -- Delete record
            BEGIN
                DELETE FROM Tbl_Sponsorship_candidate_mapping 
                WHERE candidate_id = @candidate_id;
            END
        END
    ')
END

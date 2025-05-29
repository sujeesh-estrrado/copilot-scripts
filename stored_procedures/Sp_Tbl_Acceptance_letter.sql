IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Tbl_Acceptance_letter]')
    AND type = N'P'
)
BEGIN
    EXEC('
create PROCEDURE [dbo].[Sp_Tbl_Acceptance_letter]
    @candidate_id bigint = 0,
    @path varchar(max) = '''',
    @flag bigint = 0
AS
BEGIN
    IF (@flag = 1) --insert details
    BEGIN
        IF NOT EXISTS (SELECT * FROM Tbl_Acceptance_letter WHERE Candidate_id = @candidate_id AND Delete_Status = 0)
        BEGIN
            INSERT INTO Tbl_Acceptance_letter(Candidate_id, Letter_path, Create_date, Delete_Status)
            VALUES (@candidate_id, @path, GETDATE(), 0);
        END
        ELSE
        BEGIN
            UPDATE Tbl_Acceptance_letter 
            SET Letter_path = @path, 
                Delete_Status = 0 
            WHERE Candidate_id = @candidate_id;
        END
    END
    
    IF (@flag = 2) --select by candidate id
    BEGIN
        SELECT * 
        FROM Tbl_Acceptance_letter 
        WHERE Candidate_id = @candidate_id 
        AND Delete_Status = 0;
    END
    
    IF (@flag = 3) --delete (soft delete)
    BEGIN
        UPDATE Tbl_Acceptance_letter 
        SET Delete_Status = 1 
        WHERE Candidate_id = @candidate_id;
    END
    
    IF (@flag = 4) --count records
    BEGIN
        SELECT COUNT(*) 
        FROM Tbl_Acceptance_letter 
        WHERE Candidate_id = @candidate_id 
        AND Delete_Status = 0;
    END
END
    ')
END
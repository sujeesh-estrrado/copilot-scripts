IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_CandidateLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_CandidateLog]
            @flag BIGINT = 0,
            @ID BIGINT = 0,
            @CandidateID BIGINT = 0,
            @LogMsg VARCHAR(MAX) = '''',
            @Date DATETIME = '''',
            @DelStatus BIT = 0
        AS
        BEGIN
            IF @flag = 1  -- Insert
            BEGIN
                INSERT INTO [dbo].[Tbl_CandidateLog]([CandidateID], [LogMsg], [Date], [DelStatus])
                VALUES(@CandidateID, @LogMsg, GETDATE(), 0)
            END

            IF @flag = 2  -- Select by CandidateID
            BEGIN
                SELECT [ID], [CandidateID], [LogMsg], [Date], [DelStatus]
                FROM [dbo].[Tbl_CandidateLog]
                WHERE CandidateID = @CandidateID AND DelStatus = 0
            END
        END
    ')
END

IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Apply_For_Visa]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Apply_For_Visa]
        (
            @Candidate_Id bigint = 0,
            @Apply_date DATE,
            @Remark VARCHAR(200),
            @empid bigint
        )
        AS
        BEGIN
            INSERT INTO Tbl_Visa_ISSO
            (
                Candidate_Id, 
                Visa_Type, 
                Visa_Expiry, 
                Duration, 
                Visa_Status, 
                Expiry_Status, 
                Applied_Date, 
                Del_Status, 
                Remark
            )
            VALUES
            (
                @Candidate_Id, 
                '''', 
                NULL, 
                '''', 
                ''Applied'', 
                '''', 
                @Apply_date, 
                0, 
                @Remark
            );

            INSERT INTO Tbl_Visa_Log
            VALUES
            (
                ''Applied'',
                @Candidate_Id,
                GETDATE(),
                '''',
                '''',
                @empid
            );
        END
    ')
END

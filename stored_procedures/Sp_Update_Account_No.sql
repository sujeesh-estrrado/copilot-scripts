IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Account_No]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Update_Account_No] 
            @flag INT,
            @studentid BIGINT = 0,
            @bankid BIGINT = 0,
            @bankAcNo VARCHAR(50) = ''''
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                UPDATE [dbo].[Tbl_Candidate_Personal_Det] 
                SET bankid1 = @bankid, bankaccountno1 = @bankAcNo
                WHERE Candidate_Id = @studentid;
            END
            ELSE IF (@flag = 2)
            BEGIN
                SELECT bankid1, bankaccountno1, name
                FROM [dbo].[Tbl_Candidate_Personal_Det] p
                LEFT JOIN ref_bank B ON P.bankid1 = B.id
                WHERE Candidate_Id = @studentid;
            END
        END
    ')
END

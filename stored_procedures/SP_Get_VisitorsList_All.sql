IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Visa_Registrar_Det]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_Visa_Registrar_Det]
        @Candidate_Id BIGINT
    AS
    BEGIN
        SELECT 
            CONVERT(VARCHAR(10), Applied_Date, 20) AS Applied_Date,
            Remark,
            CASE 
                WHEN Vi.Registrar_Approval = 0 THEN ''Pending''
                WHEN Vi.Registrar_Approval = 1 THEN ''Approved''
                WHEN Vi.Registrar_Approval = 2 THEN ''Rejected''
                ELSE ''Unknown''
            END AS Approval_Status
        FROM Tbl_Visa_Renewal VI  
        WHERE Candidate_Id = @Candidate_Id 
            AND Del_Status = 0  
        ORDER BY Applied_Date DESC;
    END
    ')
END
GO

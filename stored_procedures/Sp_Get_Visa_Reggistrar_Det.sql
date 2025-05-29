IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Visa_Log]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_Visa_Log]
        @Candidate_Id BIGINT
    AS
    BEGIN
        SELECT 
            VL.Candidate_Id,
            VL.Log_Details,
            FORMAT(VL.Date, ''yyyy-MM-dd'') AS Date, -- Standard format
            VL.Old,
            VL.New,
            CASE 
                WHEN VL.Changed_By = 1 THEN ''Admin''
                ELSE CONCAT(
                    ISNULL(E.Employee_FName, ''''), '' '', 
                    ISNULL(E.Employee_LName, ''''), '' ('', 
                    ISNULL(Tr.role_Name, ''No Role''), '')''
                ) 
            END AS Changed_By
        FROM Tbl_Visa_Log VL 
        LEFT JOIN Tbl_Employee E ON VL.Changed_By = E.Employee_Id
        LEFT JOIN Tbl_RoleAssignment TRA ON TRA.Employee_Id = E.Employee_Id
        LEFT JOIN tbl_Role TR ON TR.Role_Id = TRA.Role_Id
        WHERE VL.Candidate_Id = @Candidate_Id
        ORDER BY VL.Log_Id DESC;
    END
    ')
END
GO

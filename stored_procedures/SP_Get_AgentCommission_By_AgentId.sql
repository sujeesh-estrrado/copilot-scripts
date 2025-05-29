IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_AgentCommission_By_AgentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_AgentCommission_By_AgentId]
        (
            @Agent_ID BIGINT
        )
        AS 
        BEGIN

            -- First query (Employee Commission)
            SELECT 
                ROW_NUMBER() OVER (ORDER BY C.Commission_Setting_Id DESC) AS SlNo,
                C.Commission_Setting_Id,
                E.Employee_FName + '' '' + E.Employee_LName AS EmployeeName,
                FS.Fee_Code,
                FH.Fee_Head_Name,
                C.Commission_Amount,
                C.Remarks,
                D.Course_Code,
                BD.Batch_Code
            FROM [Tbl_Commission_Settings] C
            INNER JOIN [dbo].[Tbl_Employee] E ON C.Employee_Id = E.Employee_Id
            INNER JOIN [dbo].[Tbl_Fee_Settings] FS ON C.Fee_Code_Id = FS.Fee_Settings_Id
            INNER JOIN [Tbl_Fee_Head] FH ON C.Feehead_Id = FH.Fee_Head_Id
            INNER JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = C.IntakeId
            INNER JOIN dbo.Tbl_Department D ON D.Department_Id = C.Course_Id
            WHERE C.Delete_Status = 0
            
            UNION

            -- Second query (Agent Commission)
            SELECT 
                ROW_NUMBER() OVER (ORDER BY C.Commission_Setting_Id DESC) AS SlNo,
                C.Commission_Setting_Id,
                A.Agent_Name AS EmployeeName,
                G.groupname AS Fee_Code,
                AC.name AS Fee_Head_Name,
                C.Commission_Amount,
                C.Remarks,
                D.Course_Code,
                BD.Batch_Code
            FROM [Tbl_Commission_Settings] C
            LEFT JOIN ref_accountcode AC ON C.Feehead_Id = AC.id
            LEFT JOIN fee_group G ON C.Fee_Code_Id = G.groupid
            INNER JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = C.IntakeId
            LEFT JOIN dbo.Tbl_Department D ON D.Department_Id = C.Course_Id
            LEFT JOIN [dbo].[Tbl_Agent] A ON C.Agent_ID = A.Agent_ID
            WHERE C.Delete_Status = 0 AND A.Agent_ID = @Agent_ID

        END
    ')
END
GO

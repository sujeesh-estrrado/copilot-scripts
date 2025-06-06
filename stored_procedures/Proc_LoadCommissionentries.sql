IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_LoadCommissionentries]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_LoadCommissionentries] 
        (
            @Commission_Setting_Id bigint
        )
        AS
        BEGIN
            SELECT 
                [Commission_Setting_Id],
                CONCAT([Employee_FName], '' '', [Employee_LName]) AS EmployeeName,
                CS.[Course_Id], 
                CS.[IntakeId], 
                groupname AS Fee_Code,
                CS.[EmpORAgent_Status],
                ItemDescription AS [Fee_Head_Name], 
                CAST(ROUND(Minimum_Amount, 0) AS int) AS Minimum_Amount,
                Fee_Code_Id AS groupid, 
                Feehead_Id AS accountcodeid,
                CAST(ROUND(Commission_Amount, 0) AS int) AS [Commission_Amount],
                Remarks, 
                d.Course_Code 
            FROM [Tbl_Commission_Settings] CS
            INNER JOIN [dbo].[Tbl_Employee] 
                ON CS.[Employee_Id] = [dbo].[Tbl_Employee].[Employee_Id]
            LEFT JOIN ref_accountcode AC 
                ON CS.Feehead_Id = AC.id
            LEFT JOIN fee_group G 
                ON CS.Fee_Code_Id = G.groupid
            INNER JOIN Tbl_Department d 
                ON CS.[Course_Id] = d.Department_ID
            WHERE [Commission_Setting_Id] = @Commission_Setting_Id

            UNION

            SELECT 
                [Commission_Setting_Id], 
                UPPER([Agent_Name]) AS EmployeeName,
                CS.[Course_Id], 
                CS.[IntakeId], 
                groupname AS Fee_Code,
                CS.[EmpORAgent_Status],
                ItemDescription AS [Fee_Head_Name], 
                CAST(ROUND(Minimum_Amount, 0) AS int) AS Minimum_Amount,
                Fee_Code_Id AS groupid, 
                Feehead_Id AS accountcodeid,
                CAST(ROUND(Commission_Amount, 0) AS int) AS [Commission_Amount],
                Remarks, 
                d.Course_Code 
            FROM [Tbl_Commission_Settings] CS
            LEFT JOIN ref_accountcode AC 
                ON CS.Feehead_Id = AC.id
            LEFT JOIN fee_group G 
                ON CS.Fee_Code_Id = G.groupid
            INNER JOIN dbo.Tbl_Department D 
                ON D.Department_Id = CS.[Course_Id]
            INNER JOIN [dbo].[Tbl_Agent] 
                ON CS.[Agent_ID] = [Tbl_Agent].[Agent_ID]
            WHERE [Commission_Setting_Id] = @Commission_Setting_Id
        END
    ')
END

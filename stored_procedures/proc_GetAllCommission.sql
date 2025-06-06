-- Check if the stored procedure [dbo].[proc_GetAllCommission] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetAllCommission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[proc_GetAllCommission]
        AS 
        BEGIN
            SELECT 
                [Commission_Setting_Id],
                [Employee_FName] + '' '' + [Employee_LName] AS EmployeeName,
                groupname AS Fee_Code,
                name AS Fee_Head_Name,
                Minimum_Amount,
                [Commission_Amount],
                Remarks,
                d.Course_Code,
                CASE 
                    EmpORAgent_Status 
                    WHEN ''1'' THEN ''Employee'' 
                    ELSE ''Agent'' 
                END AS EmpORAgent_Status,
                BD.Batch_Code  
            FROM [Tbl_Commission_Settings] C
            INNER JOIN [dbo].[Tbl_Employee] 
                ON C.[Employee_Id] = [dbo].[Tbl_Employee].[Employee_Id]
            LEFT JOIN ref_accountcode AC 
                ON C.Feehead_Id = AC.id
            LEFT JOIN fee_group G 
                ON C.Fee_Code_Id = G.groupid
            INNER JOIN Tbl_Course_Batch_Duration BD 
                ON BD.Batch_Id = C.IntakeId
            INNER JOIN dbo.Tbl_Department D 
                ON D.Department_Id = C.[Course_Id] 
            WHERE C.[Delete_Status] = 0
            
            UNION

            SELECT 
                [Commission_Setting_Id],
                [Agent_Name] AS EmployeeName,
                groupname AS Fee_Code,
                name AS Fee_Head_Name,
                Minimum_Amount,
                [Commission_Amount],
                Remarks,
                d.Course_Code,
                CASE 
                    EmpORAgent_Status 
                    WHEN ''1'' THEN ''Employee'' 
                    ELSE ''Agent'' 
                END AS EmpORAgent_Status,
                BD.Batch_Code 
            FROM [Tbl_Commission_Settings] C
            LEFT JOIN ref_accountcode AC 
                ON C.Feehead_Id = AC.id
            LEFT JOIN fee_group G 
                ON C.Fee_Code_Id = G.groupid
            INNER JOIN Tbl_Course_Batch_Duration BD 
                ON BD.Batch_Id = C.IntakeId
            INNER JOIN dbo.Tbl_Department D 
                ON D.Department_Id = C.[Course_Id] 
            INNER JOIN [dbo].[Tbl_Agent] 
                ON C.[Agent_ID] = [Tbl_Agent].[Agent_ID]
            WHERE C.[Delete_Status] = 0
        END
    ')
END

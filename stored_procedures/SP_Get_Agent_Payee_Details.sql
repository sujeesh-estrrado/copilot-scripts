IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Agent_Payee_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_Agent_Payee_Details]
        (
            @Flag BIGINT = 0,
            @Searchterm VARCHAR(MAX) = '''',
            @ActiveStatus BIT = NULL,
            @Details_Id BIGINT = 0,
            @Payee_Id BIGINT = 0
        )
        AS
        BEGIN
            -- Flag 0: Get Payee Details
            IF (@Flag = 0)
            BEGIN
                SELECT DISTINCT 
                    CG.Details_Id, 
                    CG.Payee_Id, 
                    CG.BankAcNo, 
                    CG.BankTelephoneNo, 
                    CG.swiftcode, 
                    CG.BankAddress, 
                    CG.Created_By, 
                    CG.Updated_By,
                    AG.Agent_Name AS Agentname, 
                    CG.PayeeName AS payeename, 
                    CONVERT(VARCHAR, CG.Created_Date, 103) AS Created_Date,
                    CASE 
                        WHEN CG.Active_Status = 0 THEN ''Active'' 
                        ELSE ''InActive'' 
                    END AS ActiveStatus,
                    CASE 
                        WHEN CG.Created_By = 1 THEN ''Admin''
                        WHEN CG.Created_By = 0 THEN ''Admin''
                        ELSE CONCAT(E.Employee_Fname, '' '', E.Employee_Lname)
                    END AS CreatedBy
                FROM Tbl_Payee_Details CG
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = CG.Created_By
                LEFT JOIN Tbl_Agent AG ON AG.Agent_ID = CG.Payee_Id
                WHERE
                    (CG.Active_Status = @ActiveStatus OR @ActiveStatus IS NULL)
                    AND (
                        CG.BankAcNo LIKE ''%'' + @Searchterm + ''%'' OR
                        CG.BankTelephoneNo LIKE ''%'' + @Searchterm + ''%'' OR
                        CG.swiftcode LIKE ''%'' + @Searchterm + ''%'' OR
                        CG.BankAddress LIKE ''%'' + @Searchterm + ''%'' OR
                        AG.Agent_Name LIKE ''%'' + @Searchterm + ''%'' OR
                        CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) LIKE ''%'' + @Searchterm + ''%''
                    )
                    AND CG.Delete_Status = 0
                ORDER BY CG.Details_Id DESC
            END

            -- Flag 1: Update Active Status
            IF (@Flag = 1)
            BEGIN
                -- Set Active Status for Payee
                UPDATE Tbl_Payee_Details
                SET Active_Status = 1
                WHERE Payee_Id = (
                    SELECT Payee_Id 
                    FROM Tbl_Payee_Details 
                    WHERE Details_Id = @Details_Id
                )

                -- Update Active Status and Updated Date
                UPDATE Tbl_Payee_Details
                SET Active_Status = @ActiveStatus, Updated_Date = GETDATE()
                WHERE Details_Id = @Details_Id

                -- Return the updated Active Status
                SELECT Active_Status AS active
                FROM Tbl_Payee_Details
                WHERE Details_Id = @Details_Id
            END

            -- Flag 2: Soft Delete Payee Details
            IF (@Flag = 2)
            BEGIN
                UPDATE Tbl_Payee_Details
                SET Delete_Status = 1, Updated_Date = GETDATE()
                WHERE Details_Id = @Details_Id
            END

            -- Flag 3: Get Payee Details by Payee ID
            IF (@Flag = 3)
            BEGIN
                SELECT DISTINCT 
                    CG.Details_Id, 
                    CG.Payee_Id, 
                    CG.BankAcNo, 
                    CG.BankTelephoneNo, 
                    CG.swiftcode, 
                    CG.BankAddress, 
                    CG.Created_By, 
                    CG.Updated_By,
                    AG.Agent_Name AS Agentname, 
                    CG.PayeeName AS payeename, 
                    CONVERT(VARCHAR, CG.Created_Date, 103) AS Created_Date,
                    CASE 
                        WHEN CG.Active_Status = 0 THEN ''Active'' 
                        ELSE ''InActive'' 
                    END AS ActiveStatus,
                    CASE 
                        WHEN CG.Created_By = 1 THEN ''Admin''
                        WHEN CG.Created_By = 0 THEN ''Admin''
                        ELSE CONCAT(E.Employee_Fname, '' '', E.Employee_Lname)
                    END AS CreatedBy
                FROM Tbl_Payee_Details CG
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = CG.Created_By
                LEFT JOIN Tbl_Agent AG ON AG.Agent_ID = CG.Payee_Id
                WHERE
                    CG.Payee_Id = @Payee_Id 
                    AND (CG.Active_Status = @ActiveStatus OR @ActiveStatus IS NULL)
                    AND (
                        CG.BankAcNo LIKE ''%'' + @Searchterm + ''%'' OR
                        CG.BankTelephoneNo LIKE ''%'' + @Searchterm + ''%'' OR
                        CG.swiftcode LIKE ''%'' + @Searchterm + ''%'' OR
                        CG.BankAddress LIKE ''%'' + @Searchterm + ''%'' OR
                        AG.Agent_Name LIKE ''%'' + @Searchterm + ''%'' OR
                        CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) LIKE ''%'' + @Searchterm + ''%''
                    )
                    AND CG.Delete_Status = 0
                ORDER BY CG.Details_Id DESC
            END

            -- Flag 4: Get Payee and Agent Name
            IF (@Flag = 4)
            BEGIN
                SELECT P.Payee_Id, P.PayeeName AS payeename, A.Agent_Name
                FROM Tbl_Payee_Details P
                INNER JOIN Tbl_Agent A ON A.Agent_ID = P.Payee_Id
                WHERE
                    P.Active_Status = 0 
                    AND P.Delete_Status = 0 
                    AND P.Payee_Id = @Payee_Id
            END
        END
    ')
END
GO

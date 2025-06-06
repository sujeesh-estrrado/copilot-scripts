-- Creating the stored procedure if it doesn't exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Agent_CommissionMapping]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Agent_CommissionMapping]
        (
            @Flag bigint = 0,
            @Mapping_Id bigint = 0,
            @Faculty_Id bigint = 0,
            @Programme_Id bigint = 0,
            @Intake_Id bigint = 0,
            @Agent_Employee_Id bigint = 0,
            @Type bigint = 0,
            @Commission_Group_Id bigint = 0,
            @Created_By bigint = 0,
            @Updated_By bigint = 0,
            @Agentid varchar(MAX) = ''''
        )
        AS
        BEGIN
            -- Logic for Flag = 0
            IF (@Flag = 0)
            BEGIN
                IF EXISTS (
                    SELECT 1
                    FROM Tbl_CommissionMapping
                    WHERE Intake_Id = @Intake_Id
                      AND Agent_Employee_Id = @Agent_Employee_Id
                      AND Type = @Type
                      AND Commission_Group_Id = @Commission_Group_Id 
                      AND ActiveStatus = 0 
                      AND Delete_Status = 0
                )
                BEGIN
                    -- Update existing commission mapping
                    UPDATE Tbl_CommissionMapping
                    SET ActiveStatus = 1
                    WHERE Intake_Id = @Intake_Id
                      AND Agent_Employee_Id = @Agent_Employee_Id
                      AND Type = @Type
                      AND Commission_Group_Id = @Commission_Group_Id
                      AND ActiveStatus = 0
                      AND Delete_Status = 0;

                    -- Insert new commission mapping
                    INSERT INTO Tbl_CommissionMapping (Faculty_Id, Programme_Id, Intake_Id, Agent_Employee_Id, Type, Commission_Group_Id, Created_By, Created_Date, Delete_Status, ActiveStatus)
                    VALUES (@Faculty_Id, @Programme_Id, @Intake_Id, @Agent_Employee_Id, @Type, @Commission_Group_Id, @Created_By, GETDATE(), 0, 0);
                END
                ELSE
                BEGIN
                    -- Insert new commission mapping
                    INSERT INTO Tbl_CommissionMapping (Faculty_Id, Programme_Id, Intake_Id, Agent_Employee_Id, Type, Commission_Group_Id, Created_By, Created_Date, Delete_Status, ActiveStatus)
                    VALUES (@Faculty_Id, @Programme_Id, @Intake_Id, @Agent_Employee_Id, @Type, @Commission_Group_Id, @Created_By, GETDATE(), 0, 0);
                END
            END

            -- Logic for Flag = 1 (update)
            IF (@Flag = 1)
            BEGIN
                UPDATE dbo.Tbl_CommissionMapping
                SET Faculty_Id = @Faculty_Id,
                    Programme_Id = @Programme_Id,
                    Intake_Id = @Intake_Id,
                    Agent_Employee_Id = @Agent_Employee_Id,
                    Type = @Type,
                    Commission_Group_Id = @Commission_Group_Id,
                    Updated_Date = GETDATE(),
                    Updated_By = @Updated_By
                WHERE Mapping_Id = @Mapping_Id;
            END

            -- Logic for Flag = 2 (select by Mapping_Id)
            IF (@Flag = 2)
            BEGIN
                SELECT Mapping_Id, Faculty_Id, Programme_Id, Intake_Id, Agent_Employee_Id, Type, Commission_Group_Id, Created_By, Updated_By
                FROM Tbl_CommissionMapping
                WHERE Mapping_Id = @Mapping_Id;
            END

            -- Logic for Flag = 3 (select by Faculty, Programme, and Intake)
            IF (@Flag = 3)
            BEGIN
                SELECT Mapping_Id, Faculty_Id, Programme_Id, Intake_Id, Agent_Employee_Id, Type, Commission_Group_Id, Created_By, Updated_By
                FROM Tbl_CommissionMapping
                WHERE Faculty_Id = @Faculty_Id 
                  AND Programme_Id = @Programme_Id 
                  AND Intake_Id = @Intake_Id;
            END

            -- Logic for Flag = 4 (select distinct agent name)
            IF (@Flag = 4)
            BEGIN
                SELECT DISTINCT 
                    CASE 
                        WHEN cm.Type = 1 THEN CONCAT(E.Employee_FName, '' '', E.Employee_LName)
                        WHEN cm.Type = 2 THEN A.Agent_Name
                        ELSE ''Unknown''
                    END AS Agent_Name
                FROM Tbl_CommissionMapping cm
                LEFT JOIN Tbl_Agent A ON A.Agent_ID = cm.Agent_Employee_Id
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = cm.Agent_Employee_Id
                WHERE cm.Agent_Employee_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Agentid, '',''))
                  AND cm.ActiveStatus = 0 
                  AND cm.Delete_Status = 0 
                  AND cm.Intake_Id = @Intake_Id;
            END
        END
    ')
END

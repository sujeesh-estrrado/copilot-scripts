IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Agent_CommissionMassGroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Agent_CommissionMassGroup] 
        (
            @Flag bigint = 0,
            @IntakeMasterID bigint = 0
        )
        AS
        BEGIN
            IF (@Flag = 0)
            BEGIN
                SELECT 
                    Batch_Id, 
                    Batch_Code, 
                    IntakeMasterID, 
                    intake_no, 
                    CBD.Duration_Id, 
                    D.Course_Code, 
                    CONCAT(D.Course_Code, '' - '', D.Department_Name) AS Department_Name
                FROM Tbl_CommissionGroup AS FG 
                JOIN Tbl_Course_Batch_Duration AS CBD ON FG.IntakeId = CBD.Batch_Id
                JOIN Tbl_Department AS D ON D.Department_Id = CBD.Duration_Id
                WHERE FG.Delete_Status = 0 
                    AND ActiveStatus = 0
                    AND (FG.IntakeId IS NOT NULL OR FG.IntakeId = 0)
                    AND IntakeMasterID = @IntakeMasterID
                ORDER BY D.Course_Code;
            END

            IF (@Flag = 1)
            BEGIN
                SELECT DISTINCT 
                    IntakeMasterID, 
                    IM.Batch_Code AS intake_no, 
                    ActiveStatus
                FROM Tbl_CommissionGroup AS FG
                JOIN Tbl_Course_Batch_Duration AS CBD ON FG.IntakeId = CBD.Batch_Id
                LEFT JOIN Tbl_IntakeMaster AS IM ON IM.id = CBD.IntakeMasterID
                WHERE FG.Delete_Status = 0 
                    AND ActiveStatus = 0
                    AND (FG.IntakeId IS NOT NULL OR FG.IntakeId = 0)
                ORDER BY IM.Batch_Code DESC;
            END

            IF (@Flag = 2) -- Get Master Intakes other than this (@IntakeMasterID)
            BEGIN
                SELECT 
                    IM.id, 
                    IM.Org_Id, 
                    IM.Batch_Code AS intake_no, 
                    IM.intake_month, 
                    IM.intake_year, 
                    IM.localdepo, 
                    IM.interdepo, 
                    IM.dateregsatart, 
                    IM.dateregend, 
                    IM.timestart, 
                    IM.timeend, 
                    IM.venue, 
                    IM.lastnumber, 
                    IM.created_by, 
                    IM.Batch_Code, 
                    IM.Batch_From, 
                    IM.Batch_To, 
                    IM.Batch_DelStatus, 
                    IM.Study_Mode, 
                    IM.Intro_Date, 
                    IM.Close_Date, 
                    IM.SyllubusCode, 
                    IM.create_date, 
                    IM.updated_by, 
                    IM.updated_date, 
                    IM.DeleteStatus, 
                    CONCAT(IM.intake_year, ''/'', IM.intake_month) AS IntakeMonth, 
                    Org.Organization_Name
                FROM dbo.Tbl_IntakeMaster AS IM 
                INNER JOIN dbo.Tbl_Organzations AS Org ON IM.Org_Id = Org.Organization_Id
                WHERE IM.id <> @IntakeMasterID 
                    AND IM.DeleteStatus = 0
                ORDER BY IM.Batch_Code DESC;
            END
        END
    ');
END

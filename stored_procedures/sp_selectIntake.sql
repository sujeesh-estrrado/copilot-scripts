IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_selectIntake]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_selectIntake]
        (
            @batchId INT,
            @orgid INT,
            @fromdate DATE,
            @enddate DATE,
            @studymode VARCHAR(50)
        )
        AS
        BEGIN
            IF EXISTS (
                SELECT * 
                FROM Tbl_Configuration_Settings 
                WHERE Config_Type = ''AdmissionFeeMapping'' 
                AND Config_Status = ''true''
            )
            BEGIN
                SELECT DISTINCT 
                    dbo.Tbl_Course_Batch_Duration.Duration_Id AS DurationID,
                    dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchCode,
                    dbo.Tbl_Course_Batch_Duration.Batch_From, 
                    dbo.Tbl_Course_Batch_Duration.Batch_To, 
                    dbo.Tbl_Department.Department_Id,
                    dbo.Tbl_Department.Department_Name,
                    CONCAT(dbo.Tbl_Department.Course_Code, '' - '', dbo.Tbl_Department.Department_Name) AS CategoryName,
                    dbo.Tbl_Course_Batch_Duration.Study_Mode,
                    dbo.Tbl_Course_Batch_Duration.Batch_Id,
                    dbo.Tbl_Course_Batch_Duration.Org_Id,
                    dbo.Tbl_Course_Category.Course_Category_Id,
                    dbo.Tbl_Course_Category.Course_Category_Name,
                    CONCAT(dbo.Tbl_Department.Department_Id, ''#'', dbo.Tbl_Course_Batch_Duration.Batch_Id) AS PgmBatch,
                    f.Promotional, 
                    f.active, 
                    f.deleteStatus
                FROM dbo.Tbl_Course_Batch_Duration
                INNER JOIN fee_group f ON f.programIntakeID = Tbl_Course_Batch_Duration.Batch_Id
                INNER JOIN dbo.Tbl_Program_Duration ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Program_Duration.Duration_Id
                INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Program_Duration.Program_Category_Id
                INNER JOIN dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id
                INNER JOIN dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id
                WHERE dbo.Tbl_Course_Category.Course_Category_Id = @batchId
                AND dbo.Tbl_Course_Batch_Duration.Org_Id = @orgid
                AND Tbl_Course_Batch_Duration.Batch_From BETWEEN @fromdate AND @enddate
                AND Tbl_Course_Batch_Duration.Study_Mode = @studymode
                AND Batch_DelStatus = 0
                AND Tbl_Course_Batch_Duration.Close_Date > DATEADD(DAY, 1, GETDATE())
                AND f.Promotional = 0 
                AND f.active = 1 
                AND f.deleteStatus = 0
            END
            ELSE
            BEGIN
                SELECT DISTINCT 
                    dbo.Tbl_Course_Batch_Duration.Duration_Id AS DurationID,
                    dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchCode,
                    dbo.Tbl_Course_Batch_Duration.Batch_From, 
                    dbo.Tbl_Course_Batch_Duration.Batch_To, 
                    dbo.Tbl_Department.Department_Id,
                    dbo.Tbl_Department.Department_Name,
                    CONCAT(dbo.Tbl_Department.Course_Code, '' - '', dbo.Tbl_Department.Department_Name) AS CategoryName,
                    dbo.Tbl_Course_Batch_Duration.Study_Mode,
                    dbo.Tbl_Course_Batch_Duration.Batch_Id,
                    dbo.Tbl_Course_Batch_Duration.Org_Id,
                    dbo.Tbl_Course_Category.Course_Category_Id,
                    dbo.Tbl_Course_Category.Course_Category_Name,
                    CONCAT(dbo.Tbl_Department.Department_Id, ''#'', dbo.Tbl_Course_Batch_Duration.Batch_Id) AS PgmBatch,
                    f.Promotional, 
                    f.active, 
                    f.deleteStatus
                FROM dbo.Tbl_Course_Batch_Duration
                LEFT JOIN fee_group f ON f.programIntakeID = Tbl_Course_Batch_Duration.Batch_Id
                INNER JOIN dbo.Tbl_Program_Duration ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Program_Duration.Duration_Id
                INNER JOIN dbo.Tbl_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Program_Duration.Program_Category_Id
                INNER JOIN dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id
                INNER JOIN dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id
                WHERE dbo.Tbl_Course_Category.Course_Category_Id = @batchId
                AND dbo.Tbl_Course_Batch_Duration.Org_Id = @orgid
                AND Tbl_Course_Batch_Duration.Batch_From BETWEEN @fromdate AND @enddate
                AND Tbl_Course_Batch_Duration.Study_Mode = @studymode
                AND Batch_DelStatus = 0
                AND Tbl_Course_Batch_Duration.Close_Date > DATEADD(DAY, 1, GETDATE())
            END
        END
    ')
END

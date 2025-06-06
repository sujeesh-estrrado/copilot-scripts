IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_Mapping_Insert]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Duration_Mapping_Insert]
            @Org_Id BIGINT,
            @Duration_Period_Id BIGINT,
            @Course_Department_Id BIGINT
        AS

        IF NOT EXISTS (
            SELECT * 
            FROM Tbl_Course_Duration_Mapping 
            WHERE Duration_Period_Id = @Duration_Period_Id 
              AND Course_Department_Id = @Course_Department_Id 
              AND Delete_Status = 0
        )
        BEGIN
            INSERT INTO Tbl_Course_Duration_Mapping
                (Org_Id, Duration_Period_Id, Course_Department_Id, Course_Department_Status, Created_Date, Updated_Date, Delete_Status)
            VALUES
                (@Org_Id, @Duration_Period_Id, @Course_Department_Id, 0, GETDATE(), GETDATE(), 0)
        END
    ')
END

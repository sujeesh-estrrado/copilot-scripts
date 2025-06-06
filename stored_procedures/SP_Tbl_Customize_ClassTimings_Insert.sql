IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Customize_ClassTimings_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[SP_Tbl_Customize_ClassTimings_Insert]
    @Hour_Name VARCHAR(150),
    @Start_Time DATETIME,
    @End_Time DATETIME,
    @Is_BreakTime BIT,
    @Location_Id BIGINT = 0,
    @Department_Id BIGINT,
    @Batch_Id BIGINT,
    @Days VARCHAR(100),
    @ClassTiming_GroupName VARCHAR(MAX),
    @Day_Id VARCHAR(MAX),
    @Ret_Id BIGINT OUTPUT  
AS
BEGIN 
    SET NOCOUNT ON;

    -- Always insert a new record in Tbl_Customize_ClassTiming to ensure a unique ID
    INSERT INTO Tbl_Customize_ClassTiming (Hour_Name, Start_Time, End_Time, Is_BreakTime, Location_Id)
    VALUES (@Hour_Name, @Start_Time, @End_Time, @Is_BreakTime, @Location_Id);

    -- Retrieve the newly inserted ID
    SET @Ret_Id = SCOPE_IDENTITY();

    -- Declare variables for processing Day_Id
    DECLARE @DayValue VARCHAR(100);
    DECLARE @Pos INT = 1;

    -- Process each Day_Id from the @Day_Id string
    WHILE CHARINDEX('','', @Day_Id + '','', @Pos) > 0
    BEGIN
        -- Extract individual Day_Id from the comma-separated list
        SET @DayValue = LTRIM(RTRIM(SUBSTRING(@Day_Id, @Pos, CHARINDEX('','', @Day_Id + '','', @Pos) - @Pos)));
        SET @Pos = CHARINDEX('','', @Day_Id + '','', @Pos) + 1;

        -- Skip empty Day_Id values
        IF (@DayValue IS NOT NULL AND @DayValue <> '''')
        BEGIN
            -- Check if the mapping already exists in Tbl_Customize_ClassTimingMapping
            IF NOT EXISTS (
                SELECT 1
                FROM Tbl_Customize_ClassTimingMapping
                WHERE Customize_ClassTimingId = @Ret_Id AND Days_Id = @DayValue
                    AND Department_Id = @Department_Id AND Batch_Id = @Batch_Id
                    AND Group_Name = @ClassTiming_GroupName
            )
            BEGIN
                -- Insert a new mapping record into Tbl_Customize_ClassTimingMapping
                INSERT INTO Tbl_Customize_ClassTimingMapping (
                    Customize_ClassTimingId, Days_Id, Department_Id, Batch_Id, Location_Id, Group_Name, Group_Id
                )
                VALUES (
                    @Ret_Id, @DayValue, @Department_Id, @Batch_Id, @Location_Id, @ClassTiming_GroupName, 0
                );
            END
        END
    END
END;

    ')
END

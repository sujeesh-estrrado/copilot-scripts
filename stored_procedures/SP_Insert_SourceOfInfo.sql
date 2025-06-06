IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_SourceOfInfo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[SP_Insert_SourceOfInfo]
    @SourceName VARCHAR(255) = '''',
    @ShowcaseInOnlineApp VARCHAR(255) = '''',
    @flag BIGINT = 0,
    @SourceID INT = '''',
    @SourceInfoTrue BIT = 0
AS
BEGIN
    -- Flag 0: Insert new record
    IF (@flag = 0)
    BEGIN
        INSERT INTO Tbl_SourceInfo (SourceName, ShowcaseInOnlineApp, DeleteStatus)
        VALUES (@SourceName, @ShowcaseInOnlineApp, 0);
    END

    -- Flag 1: Select all records
    IF (@flag = 1)
    BEGIN
        SELECT SourceID, SourceName,
               CASE 
                   WHEN ShowcaseInOnlineApp = ''true'' THEN ''Yes''
                   ELSE ''No''
               END AS ShowcaseInOnlineApp,
               DeleteStatus
        FROM Tbl_SourceInfo 
        WHERE DeleteStatus = 0;
    END

    -- Flag 2: Soft delete a record
    IF (@flag = 2)
    BEGIN
        UPDATE Tbl_SourceInfo
        SET DeleteStatus = 1
        WHERE SourceID = @SourceID;
    END

    -- Flag 3: Select a specific record by SourceID
    IF (@flag = 3)
    BEGIN
        SELECT *
        FROM Tbl_SourceInfo
        WHERE DeleteStatus = 0 AND SourceID = @SourceID;
    END

    -- Flag 4: Select records based on @SourceInfoTrue
    IF (@flag = 4)
    BEGIN
        IF @SourceInfoTrue = 1
        BEGIN 
            -- Filter based on normalized SourceName values
            SELECT SourceID, SourceName
            FROM Tbl_SourceInfo
            WHERE LOWER(REPLACE(SourceName, '' '', '''')) IN (
                ''callin'', ''walkin'', ''event'', ''educationfair'', ''roadshow'', 
                ''socialmediaenquiry'', ''online/websiteenquiry'', ''openday'', 
                ''schoolfair/schoolvisit'', ''agent/referal/alumini''
            )
            AND DeleteStatus = 0;
        END
        ELSE
        BEGIN 
            -- Select records where ShowcaseInOnlineApp is ''True''
            SELECT *
            FROM Tbl_SourceInfo
            WHERE DeleteStatus = 0 AND ShowcaseInOnlineApp = ''True'';
        END
    END

    -- Flag 5: Update a record
    IF (@flag = 5)
    BEGIN
        UPDATE Tbl_SourceInfo
        SET SourceName = @SourceName,
            ShowcaseInOnlineApp = @ShowcaseInOnlineApp,
            DeleteStatus = 0
        WHERE SourceID = @SourceID;
    END
END;
    ')
END

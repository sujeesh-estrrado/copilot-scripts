IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_FollowupStatusMaster]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE PROCEDURE [dbo].[SP_Insert_FollowupStatusMaster]
    @FollowupstatusName VARCHAR(255) = '''',
    --@ShowcaseInOnlineApp VARCHAR(255) = '''',
    @flag BIGINT = 0,
    @Followup_ID INT = '''',
    @FollowupTrue BIT = 0
AS
BEGIN
    -- Flag 0: Insert new record
    IF (@flag = 0)
    BEGIN
        INSERT INTO Tbl_FollowupStatus_Master (Followup_Name, Followup_DelStatus,Foolowup_CreatedDate)
        VALUES (@FollowupstatusName,0,GETDATE());
    END

    -- Flag 1: Select all records
    IF (@flag = 1)
    BEGIN
        SELECT Followp_Id, Followup_Name
              
        FROM Tbl_FollowupStatus_Master 
        WHERE Followup_DelStatus = 0;
    END

    -- Flag 2: Soft delete a record
    IF (@flag = 2)
    BEGIN
        UPDATE Tbl_FollowupStatus_Master
        SET Followup_DelStatus = 1
        WHERE Followp_Id = @Followup_ID;
    END

    -- Flag 3: Select a specific record by SourceID
    IF (@flag = 3)
    BEGIN
        SELECT *
        FROM Tbl_FollowupStatus_Master
        WHERE Followup_DelStatus = 0 AND Followp_Id = @Followup_ID;
    END

    -- Flag 4: Select records based on @SourceInfoTrue
    --IF (@flag = 4)
    --BEGIN
    --    IF @SourceInfoTrue = 1
    --    BEGIN 
           
    --        SELECT SourceID, SourceName
    --        FROM Tbl_SourceInfo
    --        WHERE LOWER(REPLACE(SourceName, '' '', '''')) IN (
    --            ''callin'', ''walkin'', ''event'', ''educationfair'', ''roadshow'', 
    --            ''socialmediaenquiry'', ''online/websiteenquiry'', ''openday'', 
    --            ''schoolfair/schoolvisit'', ''agent/referal/alumini''
    --        )
    --        AND DeleteStatus = 0;
    --    END
    --    ELSE
    --    BEGIN 
    --        -- Select records where ShowcaseInOnlineApp is ''True''
    --        SELECT *
    --        FROM Tbl_SourceInfo
    --        WHERE DeleteStatus = 0 AND ShowcaseInOnlineApp = ''True'';
    --    END
    --END

    -- Flag 5: Update a record
    IF (@flag = 5)
    BEGIN
        UPDATE Tbl_FollowupStatus_Master
        SET Followup_Name = @FollowupstatusName,
        Followup_UpdatedDate=getdate()
            
        WHERE Followp_Id = @Followup_ID;
    END
END;
    ');
END;
GO
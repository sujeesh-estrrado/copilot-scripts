IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_LeadStatus_Master]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            CREATE PROCEDURE [dbo].[SP_Insert_LeadStatus_Master]
    @leadstatusName VARCHAR(255) = '''',  
    @flag BIGINT = 0,
    @leadstatusId INT = '''',
    @leadstatusTrue BIT = 0
AS          
BEGIN
DECLARE @MappedInterestId bigint;
DECLARE @mappedpipelineid bigint;

    -- Flag 0: Insert new record
    IF (@flag = 0)
    BEGIN
        INSERT INTO Tbl_Lead_Status_Master (Lead_Status_Name,Lead_Status_DelStatus,Lead_Status_CreatedDate)
        VALUES (@leadstatusName,0,GETDATE());
    END

    -- Flag 1: Select all records
    IF (@flag = 1)
    BEGIN
        SELECT Lead_Status_Id,Lead_Status_Name
              
        FROM Tbl_Lead_Status_Master 
        WHERE Lead_Status_DelStatus = 0 and (Lead_Status_Id = @leadstatusId OR @leadstatusId = '''')
    END

    -- Flag 2: Soft delete a record
    IF (@flag = 2)
    BEGIN
         UPDATE Tbl_Lead_Status_Master
        SET Lead_Status_DelStatus = 1
        WHERE Lead_Status_Id = @leadstatusId;

		--DELETE FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = @leadstatusId
		DELETE FROM tbl_Lead_Status_Maping WHERE Lead_Satus_Id = @leadstatusId
		select @MappedInterestId= InterestLevel_ID from Tbl_Interest_level_Mapping where Lead_Status_Id = @leadstatusId
		  UPDATE Tbl_Interest_level_Master
        SET Interest_level_DelStatus = 1
        WHERE InterestLevel_ID = @MappedInterestId;
		select @mappedpipelineid=Pipeline_Id from tbl_Lead_Status_Maping where Lead_Satus_Id=@leadstatusId
		update Tbl_Pipeline_Settings set Delete_Status=1
		where Pipeline_Id=@mappedpipelineid

    END

    -- Flag 3: Select a specific record by SourceID
    IF (@flag = 3)
    BEGIN
       SELECT *
        FROM Tbl_Lead_Status_Master
        WHERE Lead_Status_DelStatus = 0 AND Lead_Status_Id = @leadstatusId;
    END


    -- Flag 4: Select records based on @SourceInfoTrue
    --IF (@flag = 4)
    --BEGIN
    --    IF @SourceInfoTrue = 1
    --    BEGIN 
    --        -- Filter based on normalized SourceName values
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
       UPDATE Tbl_Lead_Status_Master
        SET Lead_Status_Name = @leadstatusName,
		Lead_Status_UpdatedDate=GETDATE()
            
        WHERE Lead_Status_Id = @leadstatusId;
    END
END;');
END;

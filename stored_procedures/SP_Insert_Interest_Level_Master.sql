IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Interest_Level_Master]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            CREATE PROCEDURE [dbo].[SP_Insert_Interest_Level_Master]
    @InterestLevelName VARCHAR(255) = '''',  
    @flag BIGINT = 0,
    @InterestlevelId INT = '''',
    @InterestLevelTrue BIT = 0
	--@leadstatusName VARCHAR(255) = ''''
AS          
BEGIN
    -- Flag 0: Insert new record
    IF (@flag = 0)
    BEGIN
        INSERT INTO Tbl_Interest_level_Master (Interest_level_Name,Interest_level_DelStatus,Interest_level_CreatedDate)
        VALUES (@InterestLevelName,0,GETDATE());

		select SCOPE_IDENTITY();



    END


	  IF (@flag = 1)
    BEGIN
SELECT 
    IM.InterestLevel_ID,
    IM.Interest_level_Name,
    STRING_AGG(LSM.Lead_Status_Id, '', '') AS Lead_Status_Id,
    STRING_AGG(LSM.Lead_Status_Name, '', '') AS Lead_Status_Names
FROM Tbl_Interest_level_Master IM
INNER JOIN Tbl_Interest_level_Mapping ILM 
    ON ILM.InterestLevel_ID = IM.InterestLevel_ID
INNER JOIN Tbl_Lead_Status_Master LSM 
    ON LSM.Lead_Status_Id = ILM.Lead_Status_Id 
    AND LSM.Lead_Status_DelStatus = 0
WHERE IM.Interest_level_DelStatus = 0
-- If @InterestlevelId is not empty, avoid the matching InterestLevel_ID
AND ((IM.InterestLevel_ID = @InterestlevelId AND IM.InterestLevel_ID IS NOT NULL) OR @InterestlevelId=0)
GROUP BY IM.InterestLevel_ID, IM.Interest_level_Name
ORDER BY IM.InterestLevel_ID DESC;




    END

    -- Flag 2: Soft delete a record
    IF (@flag = 2)
    BEGIN
         UPDATE Tbl_Interest_level_Master
        SET Interest_level_DelStatus = 1
        WHERE InterestLevel_ID = @InterestlevelId;
		
    END

    -- Flag 3: Select a specific record by SourceID
    IF (@flag = 3)
    BEGIN
       SELECT *
        FROM Tbl_Interest_level_Master
        WHERE Interest_level_DelStatus = 0 AND InterestLevel_ID = @InterestlevelId;
    END

    IF (@flag = 5)
    BEGIN
       UPDATE Tbl_Interest_level_Master
        SET Interest_level_Name = @InterestLevelName,
		Ineterest_level_UpdatedDate=GETDATE()
            
        WHERE InterestLevel_ID = @InterestlevelId;
    END

	IF(@flag = 6 )
	BEGIN
	SELECT 
    IM.InterestLevel_ID,
    IM.Interest_level_Name,
    STRING_AGG(LSM.Lead_Status_Id, '', '') AS Lead_Status_Id,
    STRING_AGG(LSM.Lead_Status_Name, '', '') AS Lead_Status_Names
FROM Tbl_Interest_level_Master IM
INNER JOIN Tbl_Interest_level_Mapping ILM 
    ON ILM.InterestLevel_ID = IM.InterestLevel_ID
INNER JOIN Tbl_Lead_Status_Master LSM 
    ON LSM.Lead_Status_Id = ILM.Lead_Status_Id 
    AND LSM.Lead_Status_DelStatus = 0
WHERE IM.Interest_level_DelStatus = 0
-- If @InterestlevelId is not empty, avoid the matching InterestLevel_ID
AND ((IM.InterestLevel_ID ! = @InterestlevelId AND IM.InterestLevel_ID IS NOT NULL) OR @InterestlevelId=0)
GROUP BY IM.InterestLevel_ID, IM.Interest_level_Name
ORDER BY IM.InterestLevel_ID DESC;
END
	
END
');
END;

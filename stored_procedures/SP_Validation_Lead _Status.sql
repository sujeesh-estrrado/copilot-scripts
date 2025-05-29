IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Validation_Lead _Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          CREATE PROCEDURE [dbo].[SP_Validation_Lead _Status] 
    @InterestlevelId INT = NULL,
    @flag INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @leadstatusid bigint;
    -- Case when @flag = 1
    IF (@flag = 1)  
    BEGIN

    select Lead_Status_Id,Lead_Status_Name from Tbl_Lead_Status_Master LM
WHERE Lead_Status_Id NOT IN 
(select Lead_Status_Id from Tbl_Interest_level_Master IM 
 inner join Tbl_Interest_level_Mapping ILM ON im.InterestLevel_ID=ILM.InterestLevel_ID and IM.Interest_level_DelStatus=0)
 and LM.Lead_Status_DelStatus=0


--       SELECT LSM.Lead_Status_Name, LSM.Lead_Status_Id 
--FROM Tbl_Lead_Status_Master LSM
--WHERE LSM.Lead_Status_DelStatus = 0
--AND (
--    NOT EXISTS (
--        SELECT 1 
--        FROM Tbl_Interest_level_Mapping ILM
--        WHERE ILM.Lead_Status_Id = LSM.Lead_Status_Id
--    )
--    OR EXISTS (
--        SELECT 1 
--        FROM Tbl_Interest_level_Mapping ILM 
--        WHERE ILM.Lead_Status_Id = LSM.Lead_Status_Id
--        AND ILM.Interest_Level_Mp_ID = (
--            SELECT MAX(Interest_Level_Mp_ID) 
--            FROM Tbl_Interest_level_Mapping 
--            WHERE Lead_Status_Id = LSM.Lead_Status_Id
--        )
--    )
--)
--AND LSM.Lead_Status_Id NOT IN (
--    -- Exclude Lead Status IDs already selected in the repeater
--    SELECT Lead_Status_Id 
--    FROM Tbl_Interest_level_Mapping 
--    WHERE InterestLevel_ID IN (SELECT InterestLevel_ID FROM Tbl_Interest_level_Master)
--);

    END

    -- Case when @flag = 2
    ELSE IF (@flag = 2)
    BEGIN

--    select Lead_Status_Id,Lead_Status_Name from Tbl_Lead_Status_Master LM
--WHERE Lead_Status_Id NOT IN 
--(select Lead_Status_Id from Tbl_Interest_level_Master IM 
-- inner join Tbl_Interest_level_Mapping ILM ON im.InterestLevel_ID=ILM.InterestLevel_ID 
-- and IM.Interest_level_DelStatus=0
--  and ILM.InterestLevel_ID IN (@InterestlevelId)
--  )
-- and LM.Lead_Status_DelStatus=0
--------------------------------------------
--select @leadstatusid= Lead_Status_Id from Tbl_Interest_level_Mapping where InterestLevel_ID=@InterestlevelId
    
SELECT Lead_Status_Id, Lead_Status_Name
FROM Tbl_Lead_Status_Master LM
WHERE Lead_Status_Id NOT IN 
(
    SELECT Lead_Status_Id 
    FROM Tbl_Interest_level_Master IM 
    INNER JOIN Tbl_Interest_level_Mapping ILM 
        ON IM.InterestLevel_ID = ILM.InterestLevel_ID 
        AND IM.Interest_level_DelStatus = 0
) 
AND LM.Lead_Status_DelStatus = 0

UNION ALL

SELECT LM.Lead_Status_Id, LM.Lead_Status_Name  -- Include Lead_Status_Name
FROM Tbl_Lead_Status_Master LM
INNER JOIN Tbl_Interest_level_Mapping ILM 
    ON ILM.Lead_Status_Id = LM.Lead_Status_Id
--WHERE LM.Lead_Status_Id =@leadstatusid;
WHERE ilm.InterestLevel_ID=@InterestlevelId
-----------------------------End-------------------------------
    END
    IF(@flag = 3)
    BEGIN
        SELECT Interest_level_Name AS Interest_Name,
        InterestLevel_ID AS Interest_Id
        FROM Tbl_Interest_level_Master where Interest_level_DelStatus = 0
        

        select * from Tbl_Interest_level_Master
    END
END
');
END;

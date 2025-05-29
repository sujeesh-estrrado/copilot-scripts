IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Display_pipeline]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            CREATE PROCEDURE [dbo].[SP_Display_pipeline]   
    @flag INT = 0 ,
	@Pipeline_Id int ='''',
	@pipelinename bigint='''',
	@priority bigint=''''
AS
BEGIN
 IF (@flag = 1)
BEGIN
 SELECT 
    ROW_NUMBER() OVER (ORDER BY ps.Pipeline_Id ASC) AS SlNo, 
    ps.Pipeline_Id,
    ps.Pipeline_Name,
    ps.priority,
    ''<span class="colorstyle" style="background-color:'' + ps.Colour + ''"></span>'' AS Colour,
    STRING_AGG(Lead_Status_Name, '', '') AS Lead_Status_Names,
	STRING_AGG(Lead_Status_Id,'','') as Lead_Status_Id
FROM 
    Tbl_Pipeline_Settings ps
INNER JOIN 
    tbl_Lead_Status_Maping lsm_map 
    ON ps.Pipeline_Id = lsm_map.Pipeline_Id AND ISNULL(lsm_map.Lead_Status_Del,0) = 0
LEFT JOIN 
    Tbl_Lead_Status_Master ms
    ON lsm_map.Lead_Satus_Id = ms.Lead_Status_Id
WHERE 
    ps.Delete_Status = 0 AND ms.Lead_Status_DelStatus = 0
GROUP BY 
    ps.Pipeline_Id, ps.Pipeline_Name, ps.priority, ps.Colour
ORDER BY 
    ps.Pipeline_Id ASC;

END

	  IF (@flag = 2)
    BEGIN
 
UPDATE Tbl_Pipeline_Settings
SET Delete_Status = 1
WHERE Pipeline_Id = @Pipeline_Id;

UPDATE tbl_Lead_Status_Maping
SET Lead_Status_Del = 1
WHERE Pipeline_Id = @Pipeline_Id;
    END
	IF (@flag=3)
	begin
	 SELECT 
    ps.Pipeline_Id,  -- Added Pipeline_Id for reference
    ps.Pipeline_Name, 
    ps.priority, 
    ps.Colour, 
    STRING_AGG(ms.Lead_Status_Name, '', '') AS Lead_Status_Names,STRING_AGG(ms.Lead_Status_Id, '', '') AS Lead_Status_Id
FROM 
    Tbl_Pipeline_Settings ps
LEFT JOIN 
    tbl_Lead_Status_Maping lsm_map 
    ON ps.Pipeline_Id = lsm_map.Pipeline_Id
LEFT JOIN 
    Tbl_Lead_Status_Master ms 
    ON lsm_map.Lead_Satus_Id = ms.Lead_Status_Id
WHERE 
    ps.Delete_Status = 0
    AND (@Pipeline_Id IS NULL OR ps.Pipeline_Id = @Pipeline_Id)  -- Filter by Pipeline_Id if provided
GROUP BY 
    ps.Pipeline_Id, ps.Pipeline_Name, ps.priority, ps.Colour;

	end
	IF (@flag = 4)

    BEGIN
       UPDATE Tbl_Pipeline_Settings
    SET Pipeline_Name = @pipelinename,
        priority = @priority,
        Delete_Status = 0
    WHERE Pipeline_Id = @Pipeline_Id;

    -- Return the updated Pipeline_Id
    SELECT @Pipeline_Id AS Pipeline_Id;
    END
    ---- Update tbl_Lead_Status_Maping
    --UPDATE tbl_Lead_Status_Maping
    --SET Lead_Satus_Id = @Leadstatus
    --WHERE Pipeline_Id = @Pipeline_Id;  -- Fixed parameter usage


END;
');
END;

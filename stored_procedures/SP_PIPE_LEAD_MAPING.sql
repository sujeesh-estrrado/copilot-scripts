IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_PIPE_LEAD_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_PIPE_LEAD_MAPING]   
    @Leadstatus VARCHAR(255)='''',
    @Pipeid BIGINT,
    @flag INT ,
    @pipilinename int=''''
AS
BEGIN
    SET NOCOUNT ON;

    IF @flag = 1 
    BEGIN
        INSERT INTO tbl_Lead_Status_Maping (Pipeline_Id, Lead_Satus_Id)
        VALUES (@Pipeid, @Leadstatus);
    END
  IF @flag = 2 
BEGIN
    
    DELETE FROM tbl_Lead_Status_Maping
    WHERE Pipeline_Id = @Pipeid;

  
    INSERT INTO tbl_Lead_Status_Maping (Pipeline_Id, Lead_Satus_Id)
    VALUES (@Pipeid, @Leadstatus);
END
   else if @flag=3
   begin
INSERT INTO tbl_Lead_Status_Maping (Lead_Satus_Id, Pipeline_Id)
SELECT Lead_Satus_Id, @pipilinename
FROM tbl_Lead_Status_Maping
WHERE Pipeline_Id = @Pipeid;

-- Step 2: Delete records where Pipeline_Id = 3
DELETE FROM tbl_Lead_Status_Maping
WHERE Pipeline_Id = @Pipeid
END
end
'
)
END;

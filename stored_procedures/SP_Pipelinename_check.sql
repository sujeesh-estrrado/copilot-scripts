IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Pipelinename_check]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Pipelinename_check]
@pipeid int ='''',
    @pipelinename VARCHAR(255) = '''',
    @priority BIGINT='''',
    @leadstatus BIGINT='''',
  @createid bigint='''',
  @flag int =0,
  @color varchar(10)=''''
AS
BEGIN
IF (@flag=1)
begin
      DECLARE @PipelineNameExist INT;
SELECT @PipelineNameExist = COUNT(*)
FROM Tbl_Pipeline_Settings
WHERE Pipeline_Name = @pipelinename and Delete_Status=0;
IF @PipelineNameExist > 0
BEGIN
    SELECT 1 AS PipelinenameExists;
END
end

IF (@flag=2)
begin
      
SELECT COUNT(*) AS priorityexist
FROM Tbl_Pipeline_Settings P
LEFT JOIN Tbl_Lead_Status_Master ms
    ON P.Linked_Lead_Status = ms.Lead_Status_Id
WHERE Priority = @priority
  AND P.Delete_Status = 0
  AND ms.Lead_Status_DelStatus = 0;


end


IF (@flag=3)
begin
SELECT COUNT(*) AS priorityexist
FROM Tbl_Pipeline_Settings P
LEFT JOIN Tbl_Lead_Status_Master ms
    ON P.Linked_Lead_Status = ms.Lead_Status_Id
WHERE Priority = @priority 
  AND P.Delete_Status = 0
  AND ms.Lead_Status_DelStatus = 0
  AND P.Pipeline_Id != @pipeid;

  end

  IF (@flag=4)
begin
SELECT COUNT(*) AS nameexist
FROM Tbl_Pipeline_Settings P
LEFT JOIN Tbl_Lead_Status_Master ms
    ON P.Linked_Lead_Status = ms.Lead_Status_Id
WHERE Pipeline_Name = @pipelinename  
  AND P.Delete_Status = 0
  AND P.Pipeline_Id != @pipeid;

  end
  IF (@flag=5)
  begin
  SELECT COUNT(*) as colorexust
FROM Tbl_Pipeline_Settings
WHERE Colour = @color and Delete_Status=0;
end
  IF (@flag=6)
  begin
  SELECT COUNT(*) as colorexustid
FROM Tbl_Pipeline_Settings
WHERE Colour = @color and Delete_Status=0 AND Pipeline_Id != @pipeid;;
end
end');
END;

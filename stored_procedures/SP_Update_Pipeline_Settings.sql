IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Pipeline_Settings]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Update_Pipeline_Settings]
@Pipeline_Id int,
    @pipelinename VARCHAR(255) = '''',
    @priority BIGINT=0,
    @leadstatus BIGINT=0,
  @createid bigint =0,
  @color varchar(10)
AS
BEGIN
      UPDATE Tbl_Pipeline_Settings    SET Pipeline_Name = @pipelinename,        priority = @priority,        Delete_Status = 0,		Created_By=@createid,		Created_date = getdate(),		Colour=@color    WHERE Pipeline_Id = @Pipeline_Id;	select SCOPE_IDENTITY()

  

END;


');
END;

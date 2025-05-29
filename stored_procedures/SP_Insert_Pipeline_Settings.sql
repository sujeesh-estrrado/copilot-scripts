IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Pipeline_Settings]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Insert_Pipeline_Settings]
    @pipelinename VARCHAR(255) = '''',
    @priority BIGINT,
    @leadstatus BIGINT,
  @createid bigint,
  @color varchar(10)
AS
BEGIN
        INSERT INTO Tbl_Pipeline_Settings (Pipeline_Name, Linked_Lead_Status, Priority, Delete_Status,Created_By,Created_date,Colour)
        VALUES (@pipelinename, @leadstatus, @priority, 0,@createid,getdate(),@color);

		select SCOPE_IDENTITY()

  

END;


');
END;

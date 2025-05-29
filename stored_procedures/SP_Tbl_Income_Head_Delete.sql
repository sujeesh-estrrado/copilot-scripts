IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Income_Head_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Income_Head_Delete]
 @Income_Id bigint
AS
BEGIN
UPDATE dbo.Tbl_Income_Head
   SET 
    Income_Status= 1
 WHERE Income_Id=@Income_Id
END

   ')
END;

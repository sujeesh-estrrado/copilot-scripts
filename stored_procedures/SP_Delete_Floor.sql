IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Floor]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Delete_Floor](@Floor_Id bigint)
AS
BEGIN
UPDATE Tbl_Floor
SET
Floor_DelStatus=1

WHERE Floor_Id=@Floor_Id 
    
END
    ')
END

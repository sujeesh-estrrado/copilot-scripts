IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_FloorByID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_FloorByID](@Floor_Id bigint)
AS
BEGIN

SELECT Floor_Id as ID,Floor_Name as FloorName,Floor_Code as FloorCode

FROM dbo.Tbl_Floor

WHERE Floor_Id=@Floor_Id and Floor_DelStatus=0
	
END
    ')
END

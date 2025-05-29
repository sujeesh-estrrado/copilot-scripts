IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Floor]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Floor]  
AS  
BEGIN  
  
SELECT Floor_Id as ID,Floor_Name as FloorName,Floor_Code as FloorCode  
  
FROM dbo.Tbl_Floor  
  
WHERE  Floor_DelStatus=0  
order by FloorName
   
END
');
END;
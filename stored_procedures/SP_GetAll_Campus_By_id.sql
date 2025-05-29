IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Campus_By_id]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Campus_By_id] (@Campus_Id bigint)  
  
AS  
  
BEGIN  
  
 SELECT Organization_Id as  Campus_Id,Organization_Name as  Campus_Name,Organization_Code Campus_Code  
  FROM [dbo].[Tbl_Organzations ] where Organization_DelStatus=0 and Organization_Id= @Campus_Id;  
     
END  
  
    ')
END
GO
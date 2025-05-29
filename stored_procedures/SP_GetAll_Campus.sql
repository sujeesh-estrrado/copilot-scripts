IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Campus]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GetAll_Campus]      
      
AS      
      
BEGIN      
      
-- SELECT  Campus_Id,Campus_Name,Campus_Code      
--  FROM [dbo].[Tbl_Campus] where Campus_DelStatus=0    
--order by Campus_Name     
         select Organization_Id,Organization_Code,Organization_Name from [Tbl_Organzations ]
         where Organization_DelStatus=0
         order by Organization_Name
END   
  
    ')
END
GO
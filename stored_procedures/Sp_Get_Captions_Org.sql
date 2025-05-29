IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Captions_Org]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Captions_Org]  
   
AS    
BEGIN    
     
 SELECT  * from Tbl_Title ;   
    
END
    ');
END;

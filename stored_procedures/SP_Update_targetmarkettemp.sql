IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_targetmarkettemp]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Update_targetmarkettemp]  
     
(@markettype varchar(50),    
@marketid int)    
     
AS BEGIN    
     
UPDATE Target_market_temp  SET Target_MarketType=@markettype WHERE Target_MarketID=@marketid    
 SELECT SCOPE_IDENTITY()    
end

    ')
END;

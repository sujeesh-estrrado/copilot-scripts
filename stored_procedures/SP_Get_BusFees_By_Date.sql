IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_BusFees_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_BusFees_By_Date]  
@Month datetime,
@RouteStopId bigint  
AS  
BEGIN  
SELECT   
RouteFeeId,  
Amount   
From Tbl_Transport_Route_Fee  
Where RouteStopId=@RouteStopId and @Month between FromDate and ToDate  
END
   ')
END;

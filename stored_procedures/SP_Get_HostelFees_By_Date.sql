IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_HostelFees_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_HostelFees_By_Date]    
@Month datetime,  
@HostelId bigint    
AS    
BEGIN    
SELECT     
HostelFeeId,    
Amount     
From Tbl_Hostel_Fee    
Where HostelId=@HostelId and Date=@Month   
END
   ')
END;

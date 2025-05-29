IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_RoomsBy_BlockId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_RoomsBy_BlockId] 
@Block_Id bigint  
--@StartDateTime datetime,  
--@EndDateTime datetime  
AS  
BEGIN  
 SELECT Room_Id,Room_Name FROM [Tbl_Room] R  
 LEFT JOIN [dbo].[tbl_RoomBooking] RB ON RB.Room=R.Room_Id  
 LEFT JOIN [dbo].[Tbl_Room_Type] RT ON RT.Room_type_id=R.Room_Type  
 where Room_Status = 0 and Block_Id = @Block_Id  and (RB.Room NOT IN (SELECT [Room] FROM [dbo].[tbl_RoomBooking] WHERE [ApprovalStatus]=1))  
 --((@StartDateTime between RB.StartDateTime and RB.EndDateTime) and @StartDateTime !=RB.EndDateTime) or  
 --( (@EndDateTime between RB.StartDateTime and RB.EndDateTime) and @EndDateTime != RB.StartDateTime ) or  
 --(RB.StartDateTime>=@StartDateTime and RB.EndDateTime<=@EndDateTime)    
 and R.Room_Type!=1  
   
END

						 ');
END;

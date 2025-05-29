IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_RoomBooking]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Update_RoomBooking]
@ID bigint =0,
@refid bigint=0
as
 begin
 update tbl_RoomBooking set Room=@ID where RefID=@refid
 end
    ')
END;

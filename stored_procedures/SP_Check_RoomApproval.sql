IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_RoomApproval]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Check_RoomApproval](@masterId bigint=0)  
as  
begin  
  
  
select * from Tbl_Exam_Master Em left join   
Tbl_Exam_Schedule ES on ES.Exam_Master_Id=Em.Exam_Master_id  
left join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id  
 inner join Tbl_Room R on R.Room_Id=ESD.Venue       
 left join  tbl_RoomBooking RB on RB.Room=R.Room_Id     and RB.RefID=ESD.Exam_Schedule_Details_Id
      
       
     
where Em.Exam_Master_id=@masterId and  RB.ApprovalStatus=0  
and Em.delete_status=0 and ES.Exam_Schedule_Status=0 and ESD.Exam_Schedule_Details_Status=0  
  
end
    ')
END

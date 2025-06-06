IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteAllMapping_By_Schedule_Details_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE Procedure [dbo].[sp_DeleteAllMapping_By_Schedule_Details_Id](@ScheduleDet_Id bigint=0)  
as  
begin  
  
Update Tbl_Exam_Schedule_Details set Exam_Schedule_Details_Status=1 where Exam_Schedule_Details_Id=@ScheduleDet_Id  
Update Invigilator_Mapping set delete_status=1 where Exam_Schedule_Details_Id=@ScheduleDet_Id  
Update Tbl_Employee_Allocations set Status=1 where Reference_id in (select InvigilatorMapping_id from Invigilator_Mapping  
where Exam_Schedule_Details_Id=@ScheduleDet_Id and delete_status=1)  
  
update tbl_RoomBooking set ApprovalStatus=3 where RefID=@ScheduleDet_Id  
update tbl_RoomBookingSessionLog set Status=3 where BookingID in (select ID from tbl_RoomBooking where RefID=@ScheduleDet_Id)  
end 
    ')
END

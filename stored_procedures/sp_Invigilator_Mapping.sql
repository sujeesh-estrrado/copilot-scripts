IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Invigilator_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Invigilator_Mapping](@flag bigint=0,@emplyeeid bigint=0,@schedule_id bigint=0)
as
begin
 if(@flag=1)
  begin
   if not exists (select * from Invigilator_Mapping where Exam_Schedule_Details_Id=@schedule_id and Employee_id=@emplyeeid and delete_status=0)
   begin
    insert into Invigilator_Mapping (Exam_Schedule_Details_Id,Employee_id,delete_status) values
	(@schedule_id,@emplyeeid,0)
   end
   end
   if(@flag=2)
    begin
	 update Invigilator_Mapping set delete_status=1 where Exam_Schedule_Details_Id=@schedule_id;
	end
 
   if(@flag=3)
    begin
	 select * from Invigilator_Mapping where Exam_Schedule_Details_Id=@schedule_id and delete_status=0;
	end
   end
');
END;
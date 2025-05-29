IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_Invigilator_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Insert_Invigilator_Mapping](@schedule_detailsid bigint=0,@employeeid bigint=0,@flag bigint=0)  
as  
begin  
if(@flag=1)
begin
if not exists (select * from Invigilator_Mapping where Exam_Schedule_Details_Id=@schedule_detailsid and Employee_id=@employeeid and delete_status=0)  
begin  
insert into Invigilator_Mapping(Exam_Schedule_Details_Id,Employee_id,delete_status)
values(@schedule_detailsid,@employeeid,0)  
SELECT @@IDENTITY    
end  
 end
 if(@flag=2)
 begin

 delete from Invigilator_Mapping where Exam_Schedule_Details_Id=@schedule_detailsid
 end
end
    ');
END;

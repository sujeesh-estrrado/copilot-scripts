IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Exam_List_ByID]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[Sp_Get_Exam_List_ByID](@flag bigint=0,@id bigint=0)  
as  
begin  
if(@flag=1)--get all shedule by master id  
begin  
  
select ES.* from Tbl_Exam_Master EM  
left join Tbl_Exam_Schedule  
ES on ES.Exam_Master_Id=EM.Exam_Master_id and ES.Exam_Schedule_Status=0 and EM.delete_status=0  
where EM.Exam_Master_id=@id  
end  
  
if(@flag=2)-- get all shedule details by shedule id  
begin  
  
select ESD.* from Tbl_Exam_Master EM  
left join Tbl_Exam_Schedule  
ES on ES.Exam_Master_Id=EM.Exam_Master_id and ES.Exam_Schedule_Status=0 and EM.delete_status=0  
left join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id and  
ESD.Exam_Schedule_Details_Status=0  
where ESD.Exam_Schedule_Id=@id  
end  
end  
  

    ')
END

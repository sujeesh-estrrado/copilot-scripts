IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Exam_Schedule]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Update_Exam_Schedule](@Schedule_Id bigint=0)  
as  
begin  
  
update Tbl_Exam_Schedule set Exam_Date=null,Exam_Time_From=null,Exam_Time_To=null,Is__Published=0  
where Exam_Schedule_Id=@Schedule_Id and Exam_Schedule_Status=0  
  
select top 1 Exam_Schedule_Details_Id from Tbl_Exam_Schedule_Details where Exam_Schedule_Id=@Schedule_Id  
end
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Result_All_percentage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Exam_Result_All_percentage]                                                                             
(                                                                          
@flag bigint=0,                                                
@Exam_Master_id bigint=0    
)                                                                               
AS                                                                                
                                                                                
BEGIN       
--if(@flag=0)      
--begin      
  
--end      
if(@flag=1)      
begin      
 select isnull(count(distinct EA.Student_Id),0)as totstudents      
  from Tbl_Exam_Master EXM       
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
 inner  join Tbl_Exam_Attendance_Master EM on EM.Exam_Schedule_Id=Es.Exam_Schedule_Id and EM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id      
 inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EM.Attendance_Master_Id                     
                    
  where     EXM.Exam_Master_id=@Exam_Master_id    
end      
if(@flag=2)      
begin      
 select isnull(count(distinct EA.Student_Id),0)as Presentstudents      
  from Tbl_Exam_Master EXM       
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
 inner  join Tbl_Exam_Attendance_Master EM on EM.Exam_Schedule_Id=Es.Exam_Schedule_Id and EM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id      
 inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EM.Attendance_Master_Id                     
                    
  where     EXM.Exam_Master_id=@Exam_Master_id     
end      
if(@flag=3)      
begin      
  select  isnull(count(distinct MA.Student_Id),0)as passstudents      
  from Tbl_Exam_Master EXM       
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                  
                    
  where  (Result_status not in(''I'',''Y'',''Z'',''Academic Disciplinary – Pardoned'',''Academic Disciplinary – Not Pardoned'',''F'',''X'') and Result_status is not null)      
  and   EXM.Exam_Master_id=@Exam_Master_id       
end   
if(@flag=4)      
begin      
  select  isnull(count(distinct MA.Student_Id),0)as failedstudents      
  from Tbl_Exam_Master EXM       
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                  
                    
  where  (Result_status=''F'')and   EXM.Exam_Master_id=@Exam_Master_id        
end    
if(@flag=5)      
begin      
  select  isnull(count(distinct MA.Student_Id),0)as Barredstudents      
  from Tbl_Exam_Master EXM       
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                  
                    
  where  (Result_status=''X'')and   EXM.Exam_Master_id=@Exam_Master_id        
end    
--if(@flag=3)      
--begin      
--  select isnull(count(distinct MA.Student_Id),0)as absentstudents      
--  from Tbl_Exam_Master EXM       
--  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
-- inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
-- inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                  
                    
--  where  (Result_status=''Y''or Result_status=''Z'')and   EXM.Exam_Master_id=@Exam_Master_id  and MA.Course_id=@Course_id  and EntryType=@EntryType       
--end      
--if(@flag=4)      
--begin      
-- select  isnull(count(distinct EA.Student_Id),0)as Misconductstudents      
--  from Tbl_Exam_Master EXM       
--  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
-- inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
-- inner  join Tbl_Exam_Attendance_Master EM on EM.Exam_Schedule_Id=Es.Exam_Schedule_Id and EM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id      
-- inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EM.Attendance_Master_Id                     
                    
--  where     EXM.Exam_Master_id=@Exam_Master_id  and ES.Course_id=@Course_id               
-- and EM.Approval_Status=1 and Publish_status=2  and Misconduct=1       
--end      
    
    
--if(@flag=7)      
--begin      
--  select  isnull(count(distinct MA.Student_Id),0)as Incompletestudents      
--  from Tbl_Exam_Master EXM       
--  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                    
-- inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id       
-- inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                  
                    
--  where  (Result_status=''I'')and   EXM.Exam_Master_id=@Exam_Master_id  and MA.Course_id=@Course_id  and EntryType=@EntryType       
--end      
  
END 
    ')
END

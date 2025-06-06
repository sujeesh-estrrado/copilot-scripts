IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Examtimetableprint]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Examtimetableprint] --3,60950                                            
(                                                       
@Exam_Master_id bigint=0 ,                            
@flag bigint=0                 
                        
)                                           
AS                                            
                                            
BEGIN                                      
if(@flag=0)                                      
 begin                                 
                          
      select distinct  ES.Course_id,NC.Course_Name,NC.Course_code, CONVERT(varchar,ES.Exam_Date, 106) as Exam_Date,                       
 CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,--DocketView_Status,                      
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To,                    
CONCAT(b.Block_Name,'' , '',R. Room_Name) AS Room_Name  ,                    
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as examtime                      
                        
    --from Tbl_ExamDocket  ED                        
     from  Tbl_Exam_Master EM                       
  inner join Tbl_Exam_Schedule ES on ES.Exam_Master_id=EM.Exam_Master_id                      
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                       
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                      
 inner join Tbl_ExamseatLayout SL on SL.Exam_Id=ES.Exam_Schedule_Id --and SL.StudentId=ED.Student_Id                      
inner join tbl_Room R on R.Room_Id=ESD.Venue and SL.Venue=R.Room_Id  and ESD.Venue=SL.Venue                    
INNER JOIN Tbl_Block b ON b.Block_Id=r.Block_Id  where EM.Exam_Master_id=@Exam_Master_id    
 end                                      
                                   
if(@flag=1)                                      
begin       
  select distinct  ES.Course_id,NC.Course_Name,NC.Course_code, CONVERT(varchar,ES.Exam_Date, 106) as Exam_Date,                       
 CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,DocketView_Status,                      
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To, ''Online Exam''AS Room_Name  ,                   
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as examtime         
    from Tbl_ExamDocket  ED                        
     inner join Tbl_Exam_Master EM on EM.Exam_Master_id=TimeTable_Id                      
  inner join Tbl_Exam_Schedule ES on ES.Exam_Master_id=EM.Exam_Master_id                      
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                       
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                      
-- inner join Tbl_ExamseatLayout SL on SL.Exam_Id=ES.Exam_Schedule_Id and SL.StudentId=ED.Student_Id                      
--inner join tbl_Room R on R.Room_Id=ESD.Venue and SL.Venue=R.Room_Id  and ESD.Venue=SL.Venue                    
--INNER JOIN Tbl_Block b ON b.Block_Id=r.Block_Id                    
  where EM.Exam_Master_id=@Exam_Master_id    
      
End      
     
   if(@flag=2)                                      
begin      
select EM.Final_Exam_status from      
  Tbl_Exam_Master as EM where EM.Exam_Master_id=@Exam_Master_id  
end  
End 
    ')
END

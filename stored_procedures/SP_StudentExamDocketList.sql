IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_StudentExamDocketList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_StudentExamDocketList] --3,60950                                
(                          
@flag bigint=0,                          
@DocketId  bigint=0,              
@Docketnumber  varchar(Max)='''',               
@TimeTableId  bigint=0,               
@StudentId  bigint=0,               
@DocketPrintCount bigint=0 ,              
@Docket_SerialNumber bigint=0 ,            
@Programme bigint=0,               
@Intake bigint=0,               
@Semester bigint=0              
            
)                               
AS                                
                                
BEGIN                          
if(@flag=0)                          
 begin                     
              
    select distinct Docket_Id ,Docket_number,TimeTable_Id,Student_Id,DocketPrintCount,Docket_SerialNumber,convert(varchar(50),ED.Created_Date,103)as Created_Date,            
    convert(varchar(50),EM.Publish_date,103)as Publish_date,DocketView_Status,            
    convert(varchar(50),EM.Exam_start_date,103)as Exam_start_date,            
    convert(varchar(50),EM.Exam_end_date,103)as Exam_end_date,            
    CBD.Duration_Id,CPD.Batch_Id,CPD.Semester_Id,D.Department_Name,CBD.intake_no,S.Semester_Name            
            
    from Tbl_ExamDocket  ED            
    inner join Tbl_Exam_Schedule ES on Es.Exam_Schedule_Id=TimeTable_Id            
    inner join Tbl_Exam_Master EM on EM.Exam_Master_id=ES.Exam_Master_Id            
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id            
   -- left join tbl_Room R on R.Room_Id=ESD.Venue            
    left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EM.Duration_Period_id            
    inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                      
    CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                      
    inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                    
    inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                    
    inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0               
   where CBD.Duration_Id=@Programme and CPD.Batch_Id=@Intake and (CPD.Semester_Id=@Semester  or @Semester=0)        
     and ED.Student_Id=@StudentId          
   order by Docket_Id desc           
              
 end                          
                  
              
if(@flag=3)                          
begin                          
                
select distinct   ED.Student_Id,ES.Course_id,NC.Course_Name,NC.Course_code, CONVERT(varchar,ES.Exam_Date, 106) as Exam_Date,           
 CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,DocketView_Status ,         
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To,        
CONCAT(b.Block_Name,'' , '',R. Room_Name) AS Room_Name  ,        
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as examtime          
            
    from Tbl_ExamDocket  ED            
     inner join Tbl_Exam_Master EM on EM.Exam_Master_id=TimeTable_Id          
  inner join Tbl_Exam_Schedule ES on ES.Exam_Master_id=EM.Exam_Master_id          
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id           
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id          
 inner join Tbl_ExamseatLayout SL on SL.Exam_Id=ES.Exam_Schedule_Id and SL.StudentId=ED.Student_Id          
inner join tbl_Room R on R.Room_Id=ESD.Venue and SL.Venue=R.Room_Id  and ESD.Venue=SL.Venue        
INNER JOIN Tbl_Block b ON b.Block_Id=r.Block_Id        
  where ED.Student_Id=@StudentId     and Docket_Id=@DocketId        
     
  order by Exam_Date           
                      
end               
 if(@flag=4)                          
begin                                        
select distinct ES.Exam_Name        
    from Tbl_ExamDocket  ED            
     inner join Tbl_Exam_Master EM on EM.Exam_Master_id=TimeTable_Id          
  inner join Tbl_Exam_Schedule ES on ES.Exam_Master_id=EM.Exam_Master_id          
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id           
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id          
 inner join Tbl_ExamseatLayout SL on SL.Exam_Id=ES.Exam_Schedule_Id and SL.StudentId=ED.Student_Id          
inner join tbl_Room R on R.Room_Id=ESD.Venue and SL.Venue=R.Room_Id  and ESD.Venue=SL.Venue        
  where ED.Student_Id=@StudentId      and Docket_Id=@DocketId       
        
                      
end                 
End 
    ')
END

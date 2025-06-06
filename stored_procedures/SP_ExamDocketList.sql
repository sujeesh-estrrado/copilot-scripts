IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ExamDocketList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_ExamDocketList] --3,60950                                          
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
@Semester bigint=0,                
@DocketView_Status bigint=0                
                      
)                                         
AS                                          
                                          
BEGIN                                    
if(@flag=0)                                    
 begin                               
                        
    select distinct Docket_Id ,Docket_number,TimeTable_Id,Student_Id,DocketPrintCount,Docket_SerialNumber,convert(varchar(50),ED.Created_Date,103)as Created_Date,                      
    convert(varchar(50),EM.Publish_date,103)as Publish_date, DocketView_Status,                     
    convert(varchar(50),EM.Exam_start_date,103)as Exam_start_date,                      
    convert(varchar(50),EM.Exam_end_date,103)as Exam_end_date,                      
    CBD.Duration_Id,CPD.Batch_Id,CPD.Semester_Id,D.Department_Name,
  ISNULL(CBD.intake_no,CBD.Batch_Code)as intake_no,
  S.Semester_Name                      
                      
        from Tbl_ExamDocket  ED                      
    inner join Tbl_Exam_Master EM on EM.Exam_Master_Id=TimeTable_Id                      
    inner join Tbl_Exam_Schedule ES on EM.Exam_Master_id=ES.Exam_Master_Id                      
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                               
    left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EM.Duration_Period_id                      
    inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                                
    CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                
    inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                              
    inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                              
    inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                             
    where CBD.Duration_Id=@Programme and CPD.Batch_Id=@Intake and CPD.Semester_Id=@Semester                      
     and ED.Student_Id=@StudentId  and EM.Publish_status=2                    
   order by Docket_Id desc                     
 end                                    
                                  
                          
if(@flag=1)                                    
begin                                    
   if not exists (select * from Tbl_ExamDocket where TimeTable_Id=@TimeTableId and Student_Id=@StudentId )                        
                           
   begin                        
  Insert into Tbl_ExamDocket (Docket_number,TimeTable_Id,Student_Id,DocketPrintCount,Docket_SerialNumber,DocketView_Status,Created_Date,Delete_Status)                                
  values(@Docketnumber, @TimeTableId,@StudentId,@DocketPrintCount,@Docket_SerialNumber,@DocketView_Status,GETDATE(),0)                          
  select   SCOPE_IDENTITY()             
 end                        
                                
end                          
                
                          
if(@flag=2)                                    
begin       
                          
 select REPLICATE(''0'',7-LEN(RTRIM(isnull(max(Docket_SerialNumber)+1,1)))) + RTRIM(isnull(max(Docket_SerialNumber)+1,1))                        
 as  Max_Docket_SerialNumber from   Tbl_ExamDocket                        
         
end                         
                        
if(@flag=3)                                    
begin                                    
                          
select distinct  ES.Course_id,NC.Course_Name,NC.Course_code, CONVERT(varchar,ES.Exam_Date, 106) as Exam_Date,                     
 CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,DocketView_Status,                    
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To,                  
CONCAT(b.Block_Name,'' , '',R. Room_Name) AS Room_Name  ,                  
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as examtime,
  DATENAME(WEEKDAY, ES.Exam_Date) AS ExamDayName,
   Format(ES.Exam_Date,''MMMM yyyy'') as ExamDateHead,
   UPPER(TCC.Course_Category_Name) as CourseCat
                      
    from Tbl_ExamDocket  ED                      
     left join Tbl_Exam_Master EM on EM.Exam_Master_id=TimeTable_Id                    
  left join Tbl_Exam_Schedule ES on ES.Exam_Master_id=EM.Exam_Master_id                    
    left join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                     
 left join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                    
 left join Tbl_ExamseatLayout SL on SL.Exam_Id=ES.Exam_Schedule_Id and SL.StudentId=ED.Student_Id                    
left join tbl_Room R on R.Room_Id=ESD.Venue 
--and SL.Venue=R.Room_Id  and ESD.Venue=SL.Venue                  
left JOIN Tbl_Block b ON b.Block_Id=r.Block_Id    
 LEFT JOIN Tbl_Department TD ON TD.Department_Id  = ED.TimeTable_Id
LEFT OUTER JOIN  dbo.Tbl_Course_Category AS TCC ON TCC.Course_Category_Id = TD.Program_Type_Id
  where ED.Student_Id=@StudentId   and Docket_Id=@DocketId     and EM.Publish_status=2             
                     
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
-- inner join Tbl_ExamseatLayout SL on SL.Exam_Id=ES.Exam_Schedule_Id and SL.StudentId=ED.Student_Id                    
--inner join tbl_Room R on R.Room_Id=ESD.Venue and SL.Venue=R.Room_Id  and ESD.Venue=SL.Venue                  
  where ED.Student_Id=@StudentId     and Docket_Id=@DocketId     and EM.Publish_status=2             
                  
                                
end                   
if(@flag=5)                
begin                
Update Tbl_ExamDocket set DocketView_Status=2 where DocketView_Status=1 and Student_Id=@StudentId                
end                
if(@flag=6)                
begin                
Update Tbl_ExamDocket set DocketView_Status=2 where DocketView_Status=1 and Student_Id=@StudentId   and Docket_Id=@DocketId             
end       
if(@flag=7)                                    
begin                                    
                          
 select REPLICATE(''0'',3-LEN(RTRIM(isnull(max(Exam_Master_id)+1,1)))) + RTRIM(isnull(max(Exam_Master_id)+1,1))                        
 as  Max_name_SerialNumber from   Tbl_Exam_Master                        
         
end      
if(@flag=8)                                    
begin     
  select Docket_Id,TimeTable_Id,Student_Id,EM.Final_Exam_status from Tbl_ExamDocket as ED inner join     
  Tbl_Exam_Master as EM on  ED.TimeTable_Id=EM.Exam_Master_id where Student_Id=@StudentId and Docket_Id=@DocketId    
    
End    
if(@flag=9)                                    
begin     
  select distinct  ES.Course_id,NC.Course_Name,NC.Course_code, CONVERT(varchar,ES.Exam_Date, 106) as Exam_Date,                     
 CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,DocketView_Status,                    
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To, ''Final Exam''AS Room_Name  ,                 
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as examtime ,  
 DATENAME(WEEKDAY, ES.Exam_Date) AS ExamDayName,
 Format(ES.Exam_Date,''MMMM yyyy'') as ExamDateHead,
 UPPER(TCC.Course_Category_Name) as CourseCat
    from Tbl_ExamDocket  ED                      
     inner join Tbl_Exam_Master EM on EM.Exam_Master_id=TimeTable_Id                    
  inner join Tbl_Exam_Schedule ES on ES.Exam_Master_id=EM.Exam_Master_id                    
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                     
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id             
 LEFT JOIN Tbl_Department TD ON TD.Department_Id  = ED.TimeTable_Id
LEFT OUTER JOIN  dbo.Tbl_Course_Category AS TCC ON TCC.Course_Category_Id = TD.Program_Type_Id
  where ED.Student_Id=@StudentId   and Docket_Id=@DocketId     and EM.Publish_status=2     
    
End    
    
End
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ExamSeatLayoutprint]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_ExamSeatLayoutprint]                                
(                                    
@flag bigint=0,                                    
@Exam_Master_id  bigint=0    
)                                         
AS                                          
                                          
BEGIN                                    
if(@flag=0)                                    
 begin                               
                        
    select distinct EM.Exam_Master_id,RePublish_status, P.Batch_Id,D.Department_Id,C.Course_Level_Id,P.Semester_Id,ES.Exam_Type_Id,EM.Publish_status ,      
 EM.Exam_Name,convert(varchar(Max),EM.Create_date,103)as exam_createddate                
 ,Em.Duration_Period_id,Final_Exam_status,D.Department_Name,B.Batch_Code as Intake,    
 CONVERT(varchar,ES.Exam_Date, 106) as Exam_Date,    
  CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,                   
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To,                  
CONCAT(BL.Block_Name,'' , '',R. Room_Name) AS Room_Name  ,                  
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as examtime,ES.Exam_Schedule_Id   ,Concat(D.Course_Code,''  '', fORMAT( ES.Exam_Date,''MMMM'') ,'' '',fORMAT( ES.Exam_Date,''yyyy''),''  ''
,''EXAMINATION'' ) as Ename       from                                    
 Tbl_Exam_Master EM left join                                     
 Tbl_Exam_Schedule ES on ES.Exam_Master_Id=Em.Exam_Master_id                                      
inner join  Tbl_Course_Duration_PeriodDetails P on P.Duration_Period_Id=Em.Duration_Period_id inner join                                       
Tbl_Course_Batch_Duration B on B.Batch_Id=P.Batch_Id                                      
inner join Tbl_Department D on D.Department_Id=B.Duration_Id                                      
inner join Tbl_Course_Level C on C.Course_Level_Id=D.GraduationTypeId    
inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id     
inner join tbl_Room R on R.Room_Id=ESD.Venue     
INNER JOIN Tbl_Block BL ON BL.Block_Id=r.Block_Id      
where EM.Exam_Master_id=@Exam_Master_id     
 end                                    
                                  
                          
if(@flag=1)                                    
begin                                    
 select EL.Exam_Id,EL.Venue,El.Seat_Arrange_Id,ESN.SeatNo,El.StudentId,CPD.AdharNumber,EL.FromTime,El.ToTime from Tbl_ExamseatLayout as EL     
inner join Tbl_ExamseatNumber as ESN on ESN.SeatNoId=EL.SeatNo     
inner join Tbl_Exam_Schedule As ESL on ESL.Exam_Schedule_Id=EL.Exam_Id     
inner join Tbl_Exam_Master As EM on EM.Exam_Master_id=ESL.Exam_Master_Id    
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=EL.StudentId    
where  EM.Exam_Master_id=@Exam_Master_id                      
                                
end                 
       
End 
    ')
END

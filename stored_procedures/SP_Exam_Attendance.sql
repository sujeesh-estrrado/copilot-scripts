IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Attendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Exam_Attendance] --3,60950                                                                  
(                                                            
@flag bigint=0,                                  
@Attendance_Id bigint=0,                                  
@Exam_Master_id bigint=0,                                  
@Exam_Schedule_Id bigint=0,                                
@Attendance_Master_Id bigint=0,                              
@Exam_Schedule_Details_Id bigint=0,                                   
@Student_Id bigint=0,                                   
@Present bigint=0,                                   
@Misconduct bigint=0,                                   
@Misconduct_Remarks varchar(MAX)='''',                                   
@Absent_Remarks varchar(MAX)='''',                                   
@Approval_Status bigint=0,                                   
@Marked_By bigint=0,                                   
@Approved_By bigint=0,                                   
@Exam_start_date datetime=null,                                  
@Exam_end_date datetime=null,                                
@Course_Id bigint=0,                                
@Invigilator bigint=0 ,                               
@Attendance_SheetNo varchar(MAX)='''',                                   
@Attendance_Slno bigint=0,                              
@Programme bigint=0,                            
@IntakeID bigint=0,                            
@SemesterId bigint=0                            
)                                                                 
AS                                                                  
                                                                  
BEGIN                                                            
if(@flag=0)                                                            
 begin                                                       
                                                
   select distinct EM.Attendance_Master_Id,Attendance_SheetNo,convert(varchar(50),EM.Created_Date,103)as Created_Date,ES.Course_id,EXM.Exam_Master_id,                              
concat(NC.Course_Name,'' - '',NC.Course_code)as Coursename,concat(E.Employee_Fname,'' '',E.Employee_LName)as Invigilator,                              
D.Department_Id,D.Department_Name,CBD.Batch_Id,ISNULL(CBD.intake_no,CBD.Batch_Code)AS intake_no,S.Semester_Id,S.Semester_Name,Case when EM.Approval_Status=0 then ''Submited'' when EM.Approval_Status=1 then                              
''Approved'' when EM.Approval_Status=2 then ''Rejected'' else ''Pending'' end as Attendancestatus,ChiefInvigilator                              
from Tbl_Exam_Attendance_Master EM                               
inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EM.Attendance_Master_Id                              
inner join Tbl_Exam_Schedule ES on Es.Exam_Schedule_Id=EM.Exam_Schedule_Id                              
inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Details_Id=EM.Exam_Schedule_Details_Id                              
inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                              
inner join Tbl_Employee E on E.Employee_Id=EM.Marked_By                              
inner join Tbl_Exam_Master EXM on EXM.Exam_Master_id=ES.Exam_Master_Id                              
left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EXM.Duration_Period_id                                              
    inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and       
    CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                                        
    inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                                             
    inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                                      
  inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0               
  inner join Invigilator_Mapping IM on IM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id                
  where(@Programme=0 or D.Department_Id=@Programme)     and (@IntakeID=0 or CBD.Batch_Code=@IntakeID)                   
  and (@SemesterId=0 or S.Semester_Id=@SemesterId) and (@Course_Id=0 or ES.Course_id=@Course_Id)                 
  and( ChiefInvigilator=@Invigilator or IM.Employee_id=@Invigilator) and Publish_status=2                          
 end                                                 
                                                          
                                                  
if(@flag=1)                                                    
begin                                                            
 if not exists(select * from Tbl_Exam_Attendance where Attendance_Master_Id=@Attendance_Master_Id                                  
    and Student_Id=@Student_Id and Delete_Status=0)                                         
begin                                  
                                  
   INSERT INTO [dbo].[Tbl_Exam_Attendance]                                  
      (Attendance_Master_Id                                  
      ,Student_Id                                  
      ,Present                                  
      ,Misconduct                                  
      ,Misconduct_Remarks                                  
      ,Absent_Remarks                                  
      ,Approval_Status                                  
      ,Marked_By                                  
      ,Approved_By                                  
                                        
   ,Created_Date                                  
      ,Delete_Status)                                  
   VALUES                                  
      (@Attendance_Master_Id,                                  
      @Student_Id,                                  
      @Present,                                  
      @Misconduct,                                  
      @Misconduct_Remarks,                                  
      @Absent_Remarks,                                  
      @Approval_Status,                                  
      @Marked_By,                                  
      @Approved_By,                                  
      getdate(),0)                     
  Select SCOPE_IDENTITY()                    
 end                                 
 else                              
  begin                              
  RAISERROR (''Data Already Exists.'', -- Message text.                              
               16, -- Severity.                              
               1 -- State.                              
               );                              
  end                              
end                                                  
 if(@flag=2)                                                            
 begin                                                       
                                  
     select distinct EM.Exam_Master_id,EM.Exam_Name,EM.Exam_start_date,EM.Exam_end_date                                   
  from  Tbl_Exam_Master EM                    
   inner join Tbl_Exam_Schedule ES on ES.Exam_Master_Id=EM.Exam_Master_id                                  
 inner Join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                                
   inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                                 
   inner join Invigilator_Mapping IM on IM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id                     
  where Publish_status=2  and EM.delete_status=0                        
  and( ChiefInvigilator=@Invigilator or IM.Employee_id=@Invigilator)                     
 --(                                            
 --   ( (CONVERT(date, @Exam_start_date) between CONVERT(date, Exam_start_date) and CONVERT(date, Exam_end_date)) and CONVERT(date, @Exam_start_date) !=CONVERT(date, Exam_end_date))  or                                          
 --   ( (CONVERT(date, @Exam_end_date) between CONVERT(date, Exam_start_date) and CONVERT(date, Exam_end_date)) and CONVERT(date, @Exam_end_date) != CONVERT(date, Exam_start_date) )  or                                          
 --   (CONVERT(date, Exam_start_date)>=CONVERT(date, @Exam_start_date) and CONVERT(date, Exam_end_date)<=CONVERT(date, @Exam_end_date))                                             
 --)                                  
                                   
                                    
 end                                       
 if(@flag=3)                                                            
 begin                                                     
                                  
     select Exam_Master_id,Exam_Name,Exam_start_date,Exam_end_date                                   
  from  Tbl_Exam_Master where Publish_status=2  and delete_status=0                           
 end                                      
                                   
  if(@flag=4)                                                            
 begin                                                       
                                  
    select EM.Exam_Master_id,EM.Exam_Name,D.Department_Name,ISNULL(CBD.intake_no,CBD.Batch_Code)AS intake_no,L.Course_Level_Name,S.Semester_Name                               
 from  Tbl_Exam_Master EM                                  
   left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EM.Duration_Period_id                                              
    inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                                                        
    CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                                        
    inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                                             
    inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                                      
    inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                                     
  where EM.Publish_status=2  and EM.delete_status=0 and Exam_Master_id=@Exam_Master_id                                  
 end                                   
   if(@flag=5)                                                            
 begin                                                       
                                  
    select distinct  NC.Course_Id,Concat(NC.course_Name, '' - '',NC.Course_code) as CourseName,ES.* from  Tbl_Exam_Master EM                                  
 inner join Tbl_Exam_Schedule ES on ES.Exam_Master_Id=EM.Exam_Master_id                                  
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                                 
    inner Join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                                
   inner join Invigilator_Mapping IM on IM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id                                
  where EM.Publish_status=2  and EM.delete_status=0 and EM.Exam_Master_id=@Exam_Master_id                      
  and NC.Course_Id not in (  select NC.Course_Id from                     
  Tbl_Exam_Master EM                                  
 inner join Tbl_Exam_Schedule ES on ES.Exam_Master_Id=EM.Exam_Master_id                                  
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                                     inner Join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                     
 inner Join Tbl_Exam_Attendance_Master EAM on  EAM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id                     
 and ES.Exam_Schedule_Id=EAM.Exam_Schedule_Id and EM.Exam_Master_id=@Exam_Master_id)                    
  and( ChiefInvigilator=@Invigilator or IM.Employee_id=@Invigilator)                                
and IM.delete_status=0                                
  order by CourseName                                  
 end                                 
 if(@flag=6)                    
 begin                                
 select * from Tbl_Exam_Master Em                                
left join                                
Tbl_Exam_Schedule ES on ES.Exam_Master_Id=Em.Exam_Master_id and delete_status=0                                
left join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=Es.Exam_Schedule_Id and Exam_Schedule_Status=0                                
left join Tbl_Exam_Attendance_Master MA on MA.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id and MA.Exam_Schedule_Id=ES.Exam_Schedule_Id                                
left join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=MA.Attendance_Master_Id                              
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=EA.Student_Id                               
where EA.Student_Id=@Student_Id and EM.Exam_Master_id=@Exam_Master_id  and ES.Course_id=@Course_Id                              
 end                                
  if(@flag=7)                                
 begin                                
    select distinct NC.Course_Id,R.Room_Name,ES.Exam_Schedule_Id,ESD.Exam_Schedule_Details_Id,ChiefInvigilator,                                
 CONVERT(varchar,ES.Exam_Date, 103) as Exam_Date,                                             
 CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,                                       
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To ,                                
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as Examtime                                
 from  Tbl_Exam_Master EM                                  
 inner join Tbl_Exam_Schedule ES on ES.Exam_Master_Id=EM.Exam_Master_id                                  
 inner Join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                                
   inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                                 
   inner join Invigilator_Mapping IM on IM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id                                
   Inner join Tbl_Room R on R.Room_Id=ESD.Venue                                
  where EM.Publish_status=2  
  and EM.delete_status=0 and                                
  EM.Exam_Master_id=@Exam_Master_id 
and  NC.Course_Id=@Course_Id 
and( ChiefInvigilator=@Invigilator or IM.Employee_id=@Invigilator)                                
and IM.delete_status=0                                
                              
 --   select Employee_Mail,* from Invigilator_Mapping M inner join tbl_Employee E on E.Employee_Id=M.Employee_id where Employee_Mail is not Null                              
                              
                                
 end                                
 if(@flag=8)                                
 begin                                
 select distinct ED.Student_Id,concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname)as Studentname,                              
 AdharNumber,IDMatrixNo                              
 from Tbl_ExamDocket  ED                                          
    inner join Tbl_Exam_Schedule ES on Es.Exam_Master_Id=TimeTable_Id                                          
    inner join Tbl_Exam_Master EM on EM.Exam_Master_id=ES.Exam_Master_Id                    
    inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                                
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                                 
    inner join Invigilator_Mapping IM on IM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id      
 inner join Tbl_Candidate_Personal_Det CPD on  ED.Student_Id=CPD.Candidate_Id                               
 where EM.Publish_status=2  and EM.delete_status=0 and  EM.Exam_Master_id=@Exam_Master_id and  NC.Course_Id=@Course_Id                               
  and( ChiefInvigilator=@Invigilator or IM.Employee_id=@Invigilator) and IM.delete_status=0                                
 -- and ED.DocketView_Status=2                     
  order by Studentname                              
 end                              
 if(@flag=9)                                
begin                                 
 if not exists(select * from Tbl_Exam_Attendance_Master where Exam_Schedule_Id=@Exam_Schedule_Id and                                   
     Exam_Schedule_Details_Id=@Exam_Schedule_Details_Id and Marked_By=@Marked_By and Delete_Status=0)                    
 begin                                  
                                  
   INSERT INTO [dbo].[Tbl_Exam_Attendance_Master]                                  
      (Exam_Schedule_Id                                
   ,Exam_Schedule_Details_Id                              
      ,Marked_By                              
   ,Attendance_SheetNo                              
   ,Attnce_SerialNumber                              
   ,Approval_Status                              
      ,Created_Date                                  
     ,Delete_Status)                                  
   VALUES                                  
      (@Exam_Schedule_Id,                                  
      @Exam_Schedule_Details_Id,                              
      @Marked_By,                               
   @Attendance_SheetNo,                              
   @Attendance_Slno,                              
      0,getdate(),0)                                 
                              
  Select SCOPE_IDENTITY()                              
 end                
 else                           
  begin                              
  RAISERROR (''Data Already Exists.'', -- Message text.                              
               16, -- Severity.                              
               1 -- State.                              
               );                              
  end                              
end                                  
if(@flag=10)                              
begin                              
 select REPLICATE(''0'',6-LEN(RTRIM(isnull(max(Attnce_SerialNumber)+1,1)))) + RTRIM(isnull(max(Attnce_SerialNumber)+1,1))                                            
 as  Attnce_SerialNumber from   Tbl_Exam_Attendance_Master                              
end                              
if(@flag=11)                              
begin                              
 Update  Tbl_Exam_Attendance_Master set Approval_Status=@Approval_Status,Approved_By=@Approved_By,Approval_Date=getdate()                              
 where Attendance_Master_Id=@Attendance_Master_Id                
    Select Approval_Status from Tbl_Exam_Attendance_Master where Attendance_Master_Id=@Attendance_Master_Id          
end                          
                          
if(@flag=12)                          
begin                          
    select distinct  ChiefInvigilator,ES.* from                           
 Tbl_Exam_Attendance_Master EM                               
inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EM.Attendance_Master_Id                              
inner join Tbl_Exam_Schedule ES on Es.Exam_Schedule_Id=EM.Exam_Schedule_Id                              
inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Details_Id=EM.Exam_Schedule_Details_Id     
inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                              
inner join Tbl_Employee E on E.Employee_Id=EM.Marked_By                              
inner join Tbl_Exam_Master EXM on EXM.Exam_Master_id=ES.Exam_Master_Id                              
left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EXM.Duration_Period_id                                              
    inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                                                        
    CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                                        
    inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                       
    inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                                      
    inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                            
  inner join Invigilator_Mapping IM on IM.Exam_Schedule_Details_Id=ESD.Exam_Schedule_Details_Id                          
                              
  where Publish_status=2  and EM.delete_status=0 and                               
  (@Programme=0 or D.Department_Id=@Programme)     and (@IntakeID=0 or CBD.Batch_Id=@IntakeID)                            
  and (@SemesterId=0 or S.Semester_Id=@SemesterId) and (@Course_Id=0 or ES.Course_id=@Course_Id)                               
  and( ChiefInvigilator=@Invigilator)                           
and IM.delete_status=0                             
end                          
if(@flag=13)                          
begin                          
 select EA.Student_Id,concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname)as studentname,                          
 Case when Present=0 then ''Absent'' when Present=1 then ''Present'' end as  Presentstatus,                          
 Case when Misconduct=0 then ''No'' when Misconduct=1 then ''Yes'' end as  Misconductstatus,                          
 Misconduct_Remarks,concat(E.Employee_FName,'' '',E.Employee_LName) as Markedby                          
 from Tbl_Exam_Attendance_Master EAM                          
 inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EAM.Attendance_Master_Id                          
 inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=EA.Student_Id                          
 inner join Tbl_Employee E on E.Employee_Id=EA.Marked_By                          
 where EA.Attendance_Master_Id=@Attendance_Master_Id                            
end                          
if(@flag=14)                          
begin                          
  select Attendance_SheetNo,EM.Exam_Name , EM.Exam_Master_id,EM.Exam_Name,concat(NC.Course_Name,'' -'',NC.Course_code) as course,                        
 D.Department_Name,ISNULL(CBD.intake_no,CBD.Batch_Code)AS intake_no,L.Course_Level_Name,S.Semester_Name,                        
 NC.Course_Id,R.Room_Name,ES.Exam_Schedule_Id,ESD.Exam_Schedule_Details_Id,                                
 CONVERT(varchar,ES.Exam_Date, 103) as Exam_Date,CONVERT(varchar,EAM.Created_Date, 103) as Entereddate,                                                   
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as Examtime                        
 from Tbl_Exam_Attendance_Master EAM                          
 inner join Tbl_Exam_Schedule ES on Es.Exam_Schedule_Id=EAM.Exam_Schedule_Id                              
inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Details_Id=EAM.Exam_Schedule_Details_Id                              
inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id                             
inner join Tbl_Employee E on E.Employee_Id=EAM.Marked_By                         
Inner join Tbl_Room R on R.Room_Id=ESD.Venue                          
inner join Tbl_Exam_Master EM   on    EM. Exam_Master_id=ES.Exam_Master_Id                           
   left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EM.Duration_Period_id                                              
    inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                                 
    CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                                        
    inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                                             
    inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                 
    inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                                     
  where EM.Publish_status=2  and EM.delete_status=0                        
 and EAM.Attendance_Master_Id=@Attendance_Master_Id                            
end           
if(@flag=15)                          
begin                          
 select         
  COUNT(CASE WHEN Present=0 THEN 1 END) AS Absent,      
  COUNT(CASE WHEN Present=1 THEN 1 END) AS Present,      
  COUNT(CASE WHEN Misconduct=0 THEN 1 END) AS MisconductNo,      
  COUNT(CASE WHEN Misconduct=1 THEN 1 END) AS MisconductYes        
                        
 from Tbl_Exam_Attendance_Master EAM                          
 inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EAM.Attendance_Master_Id                          
 inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=EA.Student_Id                          
 inner join Tbl_Employee E on E.Employee_Id=EA.Marked_By                          
 where EA.Attendance_Master_Id=@Attendance_Master_Id                            
end      
if(@flag=16)                          
begin                          
 select EA.Student_Id ,convert(varchar(50),EA.Created_Date,103)as txtexamdate,                       
 Case when Misconduct=0 then ''No'' when Misconduct=1 then ''Yes'' end as  Misconductstatus,                          
 Misconduct_Remarks,concat(E.Employee_FName,'' '',E.Employee_LName) as Markedby                          
 from Tbl_Exam_Attendance_Master EAM                          
 inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EAM.Attendance_Master_Id                          
 inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=EA.Student_Id                          
 inner join Tbl_Employee E on E.Employee_Id=EA.Marked_By                          
 where EA.Attendance_Master_Id=@Attendance_Master_Id     and Misconduct=1                       
end    
End
    ')
END

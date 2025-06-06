IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_DisciplinaryHearing]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Exam_DisciplinaryHearing] --3,60950                                                                    
(                                                              
@flag bigint=0,                                    
@Attendance_Id bigint=0,                                    
@Exam_Master_id bigint=0,                                    
@Exam_Schedule_Id bigint=0,                                  
@Attendance_Master_Id bigint=0,                                
@Exam_Schedule_Details_Id bigint=0,                                     
@Student_Id bigint=0,                                                       
@Course_Id bigint=0,                                  
@Invigilator bigint=0 ,                                                  
@Programme bigint=0,                              
@IntakeID bigint=0,                              
@SemesterId bigint=0                              
)                                                                   
AS                                                                    
                                                                    
BEGIN                                                              
if(@flag=0)             
 begin                                                         
                                                  
  select distinct EM.Attendance_Master_Id,EXM.Exam_Name,convert(varchar(50),EM.Created_Date,103)as Created_Date,ES.Course_id,                                
 concat(NC.Course_Name,'' - '',NC.Course_code)as Coursename,concat(E.Employee_Fname,'' '',E.Employee_LName)as Invigilator,Publish_status,                                
 D.Department_Id,D.Department_Name,CBD.Batch_Id,CBD.intake_no,S.Semester_Id,S.Semester_Name,ChiefInvigilator,case when Hearing_Status is null then            
 ''Pending'' when Hearing_Status=0  then ''Pending'' else ''Approved'' end as  Hearing_Status ,0 as numberofstudents                               
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
 where            
 (@Programme=0 or D.Department_Id=@Programme)     and (@IntakeID=0 or CBD.Batch_Id=@IntakeID)                     
 and (@SemesterId=0 or S.Semester_Id=@SemesterId) and (@Course_Id=0 or ES.Course_id=@Course_Id)            
 and Misconduct=1 and EM.Approval_Status=1 and Publish_status=2                          
 end                            
                                                            
if(@flag=1)             
 begin                                               
                                                  
  select distinct PD.AdharNumber,EM.Attendance_Master_Id, EA.Attendance_Id ,concat(PD.Candidate_Fname,'' '',PD.Candidate_Lname)as studentname,EA.Student_Id,PD.IDMatrixNo,Misconduct_Remarks                     
  ,DH.Hearing_Id,DH.DateofHearing,DH.DecisionTaken,DH.Decision_Remarks,DH.Pardoned        
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
 inner join Tbl_Candidate_Personal_Det PD on PD.Candidate_Id=EA.Student_Id           
 left join Tbl_Disciplinary_Hearing DH on DH.Attendance_Id=EM.Attendance_Master_Id        
 where            
 (@Programme=0 or D.Department_Id=@Programme)     and (@IntakeID=0 or CBD.Batch_Id=@IntakeID)                     
 and (@SemesterId=0 or S.Semester_Id=@SemesterId) and (@Course_Id=0 or ES.Course_id=@Course_Id)            
 and Misconduct=1 and EM.Approval_Status=1 and Publish_status=2    order by studentname                      
 end                                                      
 if(@flag=2)             
 begin                                                         
                                                  
  select distinct EXM.Exam_Master_id,EXM.Exam_Name,D.Department_Name,CBD.intake_no,L.Course_Level_Name,S.Semester_Name,concat(NC.Course_Name,'' - '',NC.Course_code)as Coursename    ,            
  NC.Course_Id,R.Room_Name,ES.Exam_Schedule_Id,ESD.Exam_Schedule_Details_Id,ChiefInvigilator,                                    
 CONVERT(varchar,ES.Exam_Date, 103) as Exam_Date,                                                 
 CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100)as Exam_Time_From,                                           
 CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100)as Exam_Time_To ,                                    
 concat(CONVERT(varchar(15),CAST(ES.Exam_Time_From AS TIME),100),'' - '',CONVERT(varchar(15),CAST(ES.Exam_Time_To AS TIME),100))as Examtime             
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
 inner join Tbl_Candidate_Personal_Det PD on PD.Candidate_Id=EA.Student_Id            
  Inner join Tbl_Room R on R.Room_Id=ESD.Venue                
 where            
 (@Programme=0 or D.Department_Id=@Programme)     and (@IntakeID=0 or CBD.Batch_Id=@IntakeID)                     
 and (@SemesterId=0 or S.Semester_Id=@SemesterId) and (@Course_Id=0 or ES.Course_id=@Course_Id)            
 and Misconduct=1 and EM.Approval_Status=1 and Publish_status=2                          
 end               
 if(@flag=3)             
 begin                                               
                                                  
  select distinct AM.Attendance_Master_Id, AD.Attendance_Id ,Misconduct_Remarks                     
  ,DH.Hearing_Id,convert(varchar, DH.DateofHearing, 23) as DateofHearing,DH.DecisionTaken,DH.Decision_Remarks,DH.Pardoned        
  from Tbl_Disciplinary_Hearing DH         
inner join Tbl_Exam_Attendance AD on AD.Attendance_Id=DH.Attendance_Id        
inner join Tbl_Exam_Attendance_Master AM on AM.Attendance_Master_Id=AD.Attendance_Master_Id        
 inner join Tbl_Exam_Schedule ES on Es.Exam_Schedule_Id=AM.Exam_Schedule_Id                                
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Details_Id=AM.Exam_Schedule_Details_Id                                
 inner join Tbl_New_Course NC on NC.Course_Id=ES.Course_id           
 inner join Tbl_Exam_Master EXM on EXM.Exam_Master_id=ES.Exam_Master_Id                                
 left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EXM.Duration_Period_id                                                
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                                                          
  CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                                          
 inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                                               
 inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                                        
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0        
 where            
 (@Programme=0 or D.Department_Id=@Programme)     and (@IntakeID=0 or CBD.Batch_Id=@IntakeID)                     
 and (@SemesterId=0 or S.Semester_Id=@SemesterId) and (@Course_Id=0 or ES.Course_id=@Course_Id)         
 and DH.Student_Id=@Student_Id          
 and Misconduct=1 and AM.Approval_Status=1 and Publish_status=2            
 end             
  if(@flag=4)        
  begin        
 select  count( distinct EA.Student_Id)as counts        
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
 inner join Tbl_Candidate_Personal_Det PD on PD.Candidate_Id=EA.Student_Id           
 left join Tbl_Disciplinary_Hearing DH on DH.Attendance_Id=EM.Attendance_Master_Id        
 where            
 (@Programme=0 or D.Department_Id=@Programme)     and (@IntakeID=0 or CBD.Batch_Id=@IntakeID)                     
 and (@SemesterId=0 or S.Semester_Id=@SemesterId) and (@Course_Id=0 or ES.Course_id=@Course_Id)            
 and Misconduct=1 and EM.Approval_Status=1 and Publish_status=2          
end       
 if(@flag=5)        
  begin        
 Update Tbl_Exam_Attendance_Master set  Hearing_Status=1    
  where Attendance_Master_Id=@Attendance_Master_Id   and Approval_Status=1    
end     
if(@flag=6)  
begin  
select distinct EXM.Exam_Master_id,EXM.Exam_Name,D.Department_Name,CBD.intake_no,L.Course_Level_Name,S.Semester_Name,            
case when EXM.Exam_Type=1 then ''Internal'' when EXM.Exam_Type=2 then ''Regular'' when EXM.Exam_Type=3 then ''Resit''           
when EXM.Exam_Type=4 then ''Repeat'' end as Exam_Type          
 from Tbl_Exam_Attendance_Master EM                                 
 inner join Tbl_Exam_Attendance EA on EA.Attendance_Master_Id=EM.Attendance_Master_Id                                
 inner join Tbl_Exam_Schedule ES on Es.Exam_Schedule_Id=EM.Exam_Schedule_Id                                
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Details_Id=EM.Exam_Schedule_Details_Id                                   
 inner join Tbl_Employee E on E.Employee_Id=EM.Marked_By                                
 inner join Tbl_Exam_Master EXM on EXM.Exam_Master_id=ES.Exam_Master_Id                                
 left join Tbl_Course_Duration_PeriodDetails CPD on CPD.Duration_Period_Id=EXM.Duration_Period_id                                                
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                             
  CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                                          
 inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                                               
 inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                                        
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                 
                
 where     EXM.Exam_Master_id=@Exam_Master_id          
and EM.Approval_Status=1 and Publish_status=2     
end  
End 
    ')
END

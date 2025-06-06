IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Subject_Attendance_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Subject_Attendance_Report] --268,''11/05/2017'',''12/11/2017''-- 6,''05/22/2017'',''07/18/2017''
                        
(@SemesterSubjectId bigint,                      
@Fromdate datetime, @Todate datetime,@TypeOfStudent varchar(50),@Duration_Mapping_Id bigint)             
                        
as begin             
      
                         
insert  into TBL_attendance1 ([date],[datetype]) select Student_Holiday_FromDate as date,''holiday'' as datetype       
from dbo.Tbl_Student_Holidays where Student_Holiday_FromDate not in              
(select Absent_Date from dbo.Tbl_Student_Absence where Absent_Date>=@FromDate and Absent_Date<=@Todate ) and              
Student_Holiday_FromDate>=@FromDate and Student_Holiday_FromDate<=@Todate              
              
union              
              
select Absent_Date as date ,''Normal''as datetype from Tbl_Student_Absence where Absent_Date>=@FromDate and Absent_Date<=@Todate            
   
INSERT into TBL_attendance2 ([Candidate_Id],[CandidateName],[AdharNumber],[Intake],[Semester_Code],[Department_Name],[Duration_Mapping_Id],[Subject_Id],
[Department_Id],[Semester_Subject_Id],[Subject_Name],[Absent_Type],[Study_Mode],[TypeOfStudent],[AbsentType],[Absent_Date],[Weekday_Code],[ClassTimings])                        
select distinct  CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+                                    
CPD.Candidate_Lname as [CandidateName],CPD.AdharNumber,D.Course_Code+'' ''+CBD.Batch_Code as Intake,CS.Semester_Code,D.Department_Name,                                    
CDM.Duration_Mapping_Id,S.Subject_Id,D.Department_Id,SS.Semester_Subject_Id,S.Subject_Name,SA.Absent_Type,CBD.Study_Mode,TypeOfStudent,                              
--WS.WeekDay_Name,                              
case SA.Absent_Type                              
when ''absent'' then ''N''                              
else ''Y''                              
end as AbsentType,                              
convert(varchar(50),SA.Absent_Date,103) as Absent_Date ,datename(weekday,Absent_Date)as Weekday_Code,                             
(select Hour_Name+''-''+convert(char(5),Start_Time,108)+''-''+convert(char(5),End_Time,108) from dbo.Tbl_ClassTimings where Class_Timings_Id=SA.Class_Timings_Id)as ClassTimings                             
                             
--select S.Subject_Name,S.Subject_Id                                    
from dbo.Tbl_Semester_Subjects SS inner join dbo.Tbl_Department_Subjects DS                                    
on DS.Department_Subject_Id=SS.Department_Subjects_Id                                    
inner join dbo.Tbl_Subject S on S.Subject_Id=DS.Subject_Id                                    
                                    
--where SS.Semester_Subject_Id=22                                    
                                    
inner join dbo.Tbl_Student_Subject_Child SSC on SSC.Subject_Id=S.Subject_Id                                    
inner join dbo.Tbl_Student_Subject_Master SSM on SSM.Student_Subject_Map_Master=SSC.Student_Subject_Map_Master                                    
inner join dbo.Tbl_Student_Semester SSe on SSe.Candidate_Id=SSM.Candidate_Id and SSe.Student_Semester_Current_Status=1                                   
inner join dbo.Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SSM.Candidate_Id                                    
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SSM.Duration_Mapping_Id                                    
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                                    
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id                                    
inner join dbo.Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id                                    
inner join dbo.Tbl_Department D on D.Department_Id = SSM.Department_Id                      
inner join dbo.Tbl_Class_TimeTable CT on CT.Duration_Mapping_Id=CDM.Duration_Mapping_Id                       
--on CT.Semster_Subject_Id=SS.Semester_Subject_Id                             
--inner join  dbo.Tbl_ClassTimings CTi on CTi.Class_Timings_Id=CT.Class_Timings_Id                            
--CT.Semster_Subject_Id=SS.Semester_Subject_Id                                  
inner join dbo.Tbl_WeekDay_Batch_Mapping WBM on WBM.WeekDay_Batch_Mapping_Id =CT.WeekDay_Settings_Id                                  
inner join dbo.Tbl_WeekDay_Settings WS on WS.WeekDay_Settings_Id=WBM.WeekDay_Settings_Id                              
inner join  dbo.Tbl_Student_Absence SA on SA.Candidate_Id=CPD.Candidate_Id 
and SA.Class_Timings_Id=CT.Class_Timings_Id and S.Subject_Id=SA.Subject_Id
and SA.Absent_Date>=@FromDate AND  SA.Absent_Date<=@Todate                                                                                                       
where SS.Semester_Subject_Id=@SemesterSubjectId    and  TypeOfStudent=@TypeOfStudent and CDM.Duration_Mapping_Id=@Duration_Mapping_Id       
            
select * from TBL_attendance2   

select Absent_Date,WeekDay_Code,ClassTimings      
from(                   
select distinct Absent_Date,WeekDay_Code,ClassTimings from TBL_attendance2  --order by  Absent_Date  desc           
union              
select distinct convert(varchar(50),date,103)as date,datename(weekday,date)as Weekday_Code,''holiday'' as ClassTimings
from TBL_attendance1 where datetype=''holiday''      
)ad order by  ClassTimings 

select distinct Candidate_Id,CandidateName,AdharNumber,Study_Mode,Intake from TBL_attendance2 

insert into  A (totalpossibleattendance,ClassTimings,Absent_Date)    
select count(AbsentType) as totalpossibleattendance,ClassTimings,Absent_Date  from  TBL_attendance2 
group by ClassTimings,Absent_Date            
--select distinct Candidate_Id,CandidateName,AdharNumber,Study_Mode,Intake from TBL_attendance2 
--group by ClassTimings,Absent_Date                    
--select count(AbsentType) as totalpossibleattendance,ClassTimings,Absent_Date into A from  TBL_attendance2 
--group by ClassTimings,Absent_Date  

insert into  B ([totalpresent],ClassTimings,Absent_Date)   
select isnull(count(AbsentType),0) as totalpresent ,ClassTimings,Absent_Date from TBL_attendance2 where AbsentType=''Y''                  
group by ClassTimings,Absent_Date                 
--select isnull(count(AbsentType),0) as totalpresent ,ClassTimings,Absent_Date into B from TBL_attendance2 where AbsentType=''Y''                  
--group by ClassTimings,Absent_Date                   
                  
select A.totalpossibleattendance,B.totalpresent,A.ClassTimings,A.Absent_Date,
isnull((A.totalpossibleattendance-B.totalpresent),A.totalpossibleattendance) as totalabsence                  
 from A left join B on A.ClassTimings=B.ClassTimings and A.Absent_Date=B.Absent_Date              
left join TBL_attendance1 t2 on convert(varchar(50),t2.date,103)=A.Absent_Date              
select convert(varchar(50),date,103)as date,datetype from TBL_attendance1               
                 
DELETE FROM  A                  
DELETE FROM  B               
DELETE FROM TBL_attendance1                                
DELETE FROM TBL_attendance2         
                  
end   
    ');
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GET_MARKS_BYCANDIDATE_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[PROC_GET_MARKS_BYCANDIDATE_ID]  --5,21         
@Batch_Id bigint,            
@Subject_Id bigint            
AS          
declare @Candidate_Id bigint      
declare @count bigint      
declare @totalcount bigint         
       
create table #temp (id int primary key identity(1,1),Exam_Mark_Enrty_Child_Id bigint,Course_Code varchar(50),      
Intake_Numer varchar(50),sem_number varchar(50),Study_Mode varchar(50),IC_Passport varchar(50),Name varchar(100),Marks decimal(18,2),      
Actual_Marks decimal(18,2),Grade varchar(50),Paa_Fail varchar(50),Marker varchar(50),Exam_Mark_Entry_Id bigint,Candidate_Id bigint,Exam_Code varchar(50),      
Assesment_Type varchar(50),Department_Id varchar(50),Batch_Id bigint,Subject_Name varchar(50),Subject_Id BIGINT,SUBJECT_CODE VARCHAR(50))      
      
create table #temp1 (id int primary key identity(1,1),pid BIGINT,Exam_Mark_Enrty_Child_Id bigint,Course_Code varchar(50),      
Intake_Numer varchar(50),sem_number varchar(50),Study_Mode varchar(50),IC_Passport varchar(50),Name varchar(100),Marks decimal(18,2),      
Actual_Marks decimal(18,2),Grade varchar(50),Paa_Fail varchar(50),Marker varchar(50),Exam_Mark_Entry_Id bigint,Candidate_Id bigint,Exam_Code varchar(50),      
Assesment_Type varchar(50),Department_Id varchar(50),Batch_Id bigint,Subject_Name varchar(50),Subject_Id BIGINT,SUBJECT_CODE VARCHAR(50))      
      
BEGIN              
             
             
insert into #temp(Exam_Mark_Enrty_Child_Id,Course_Code,Intake_Numer,sem_number,Study_Mode,IC_Passport,      
Name,Marks,Actual_Marks ,Grade,Paa_Fail,Marker,Exam_Mark_Entry_Id,Candidate_Id,Exam_Code,Assesment_Type,Department_Id,      
Batch_Id,Subject_Name,Subject_Id,SUBJECT_CODE)      
select distinct A.*,B.AssesmentType,D.Department_Id,CBD.Batch_Id,s.Subject_Name,s.Subject_Id,S.SUBJECT_CODE            
from Tbl_Exam_Mark_Entry_Child A                        
inner join Tbl_Exam_Code_Child B on B.Exam_Code_final=A.ExamCode              
INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.AdharNumber=A.IC_Passport              
inner join dbo.Tbl_StudentExamSubjectMaster SEM ON CPD.Candidate_Id=SEM.Candidate_Id                      
INNER JOIN dbo.Tbl_StudentExamSubjectsChild SEC ON SEM.StudentExamSubjectMasterId=SEC.StudentExamSubjectMasterId                      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id =SEM.Department_Id                      
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id=SEM.Duration_Mapping_Id                      
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id=CDM.Duration_Period_Id                      
INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id=CDP.Batch_Id                      
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id                      
INNER JOIN dbo.Tbl_Exam_Code_Child ECC ON ECC.Exam_Code_final=SEC.ExamCode                      
INNER JOIN dbo.Tbl_Exam_Code_Master ECM ON ECM.Exam_Code_Master_Id=ECC.Exam_Code_Master_Id                      
INNER JOIN dbo.Tbl_GroupChangeExamDates GC ON GC.ExamCode=ECC.Exam_Code_final                      
INNER JOIN dbo.Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id=CPD.Candidate_Id               
inner join Tbl_Department_Subjects DS ON DS.Course_Department_Id=D.Department_Id            
inner join  tbl_Subject s on s.Subject_Id=SEC.SubjectId             
where s.Subject_Id=@Subject_Id and CBD.Batch_Id=@Batch_Id                  
               
      
set @count=1      
set @totalcount=(select count(ID) FROM #temp)      
print @totalcount      
while(@count<=@totalcount)      
begin      
set @Candidate_Id=(select Candidate_Id from #temp where ID=@count)      
if not exists(select * from #temp1 where Candidate_Id=@Candidate_Id)      
begin      
print ''1''      
      
insert into #temp1(pid,Exam_Mark_Enrty_Child_Id,Course_Code,Intake_Numer,sem_number,Study_Mode,IC_Passport,      
Name,Marks,Actual_Marks ,Grade,Paa_Fail,Marker,Exam_Mark_Entry_Id,Candidate_Id,Exam_Code,Assesment_Type,Department_Id,      
Batch_Id,Subject_Name,Subject_Id,SUBJECT_CODE)      
select * from #temp where id=@count      
end      
else      
begin      
print ''2''      
      
end      
      
set @count=@count+1      
end      
      
select * from #temp1        
      
      
      
select Study_Mode,Semester_Code from Tbl_Course_Batch_Duration cdm            
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Batch_Id=CDM.Batch_Id                
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id            
where cdm.Batch_Id=@Batch_Id           
        
SELECT Assesment_Type,CAST(ROUND(ACD.Assessment_Perc,2) AS NUMERIC(12,0)) Assessment_PercMarks--,Candidate_Id         
FROM Tbl_Assessment_Code_Child ACD        
inner join Tbl_Assessment_Code_Master ACM ON ACD.Assessment_Code_Id=ACM.Assessment_Code_Id         
INNER JOIN  tbl_Subject S ON ACM.Assessment_Code= S.Assessment_Code        
INNER JOIN dbo.Tbl_Assessment_Type AT  ON AT.Assessment_Type_Id=ACD.Assessment_Type_Id      
--inner join Tbl_Student_Subject_Child ssc on ssc.Subject_Id=s.subject_id      
--inner join Tbl_Student_Subject_Master ssm on ssm.Student_Subject_Map_Master=ssc.Student_Subject_Map_Master      
        
WHERE S.Subject_Id =@Subject_Id        
        
        
END 
    ');
END

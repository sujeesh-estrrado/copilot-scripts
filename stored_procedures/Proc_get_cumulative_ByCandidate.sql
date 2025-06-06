IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_get_cumulative_ByCandidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Proc_get_cumulative_ByCandidate]  
(@Candidate_Id bigint)         
as      
begin    
  

delete from  tbl_Exam_Report 
delete from   tbl_exam_report_certificate   
--truncate table tbl_Exam_Report 
--truncate table tbl_exam_report_certificate   
  
--drop table tbl_exam_report_certificate
--drop table tbl_Exam_Report
declare @count int
declare @total_count int 
declare @total_credit decimal(18,2)
declare @total_gradepoint decimal(18,2) 
declare @total_gradevalue decimal(18,2) 
declare @credit decimal(18,2)
declare @gradepoint decimal(18,2) 
declare @gradevalue decimal(18,2) 
declare @rowcount int
declare @avggrade  decimal(18,2)
--create table tbl_exam_report_certificate (id int primary key identity(1,1),SubjectName varchar(100),Credit_point decimal(18,2),gradepoint decimal(18,2),gradevalue decimal(18,2))
--create table tbl_Exam_Report (id int primarykey identity(1,1),total_credit decimal(18,2),total_gradevalue decimal(18,2),
--avg_gradepoint decimal(18,2),creditpoint decimal(18,2),gradevalue decimal(18,2),gradepoint decimal(18,2))
insert into tbl_exam_report_certificate(SubjectName,Credit_point,gradepoint,gradevalue)
select distinct SC.SubjectName,Credit_Points,GSS.GradePoint,(S.Credit_Points)*(GSS.GradePoint) GradeValue                                                             
from  Tbl_Exam_Mark_Entry_Child EC                              
inner join Tbl_StudentExamSubjectsChild SC on EC.ExamCode=SC.ExamCode                                
inner join Tbl_GradingScheme GS on GS.Grade_Scheme=SC.GradingScherme                                
inner join Tbl_GradeSchemeSetup GSS on GSS.Grade_Scheme_Id=GS.Grade_Scheme_Id and EC.Grade=GSS.Grade                                
inner join Tbl_GroupChangeExamDates GD on GD.ExamCode=EC.ExamCode                              
inner join Tbl_Subject S on SC.SubjectId=S.Subject_Id                 
inner join Tbl_Student_Semester ss on ss.candidate_id=EC.candidate_id              
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                          
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                           
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id --and cs.Semester_Code =ec.Sem_Number                            
--left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                    
left join Tbl_Course_Department on cdm.Course_Department_Id = Tbl_Course_Department.Course_Department_Id                    
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id                    
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id                    
left join Tbl_Department on   Tbl_Course_Department.Department_Id =  Tbl_Department.Department_Id                    
INNER JOIN dbo.Tbl_Exam_Code_Child  ECC  ON GD.ExamCode=ECC.Exam_Code_Final                       
INNER JOIN dbo.Tbl_Assessment_Type AT  ON AT.Assesment_Type=ECC.AssesmentType      
INNER JOIN Tbl_Assessment_Code_Child ACC ON ACC.Assessment_Type_Id=AT.Assessment_Type_Id      
        
where EC.Candidate_Id=@Candidate_Id and ss.Student_Semester_Current_Status=1           
AND SC.CurrentStatus<>''--Select--'' and LAST=1 --and  EC.ExamCode like ''%FE%''            
set @total_credit=0
set @total_gradepoint=0;
set @total_gradevalue=0
set @credit=0
set @gradepoint=0;
set @gradevalue=0

set @count=(select top 1 id from tbl_exam_report_certificate)
set @total_count=(select max(id) from tbl_exam_report_certificate)
set @rowcount=(select count(id) from tbl_exam_report_certificate)
while(@count<=@total_count)
begin
print @count
if exists(select * from tbl_exam_report_certificate where id=@count)
begin
 set @total_credit=(select Credit_point from tbl_exam_report_certificate where id=@count)
 set @credit=@credit+@total_credit
 set @total_gradepoint=(select gradepoint from tbl_exam_report_certificate where id=@count)
 set @gradepoint=@gradepoint+@total_gradepoint

 set @total_gradevalue=(select GradeValue from tbl_exam_report_certificate where id=@count)
 set @gradevalue=@gradevalue+@total_gradevalue
 end
set @count=@count+1
end
 set @avggrade=@gradepoint/@rowcount

insert into tbl_Exam_Report(total_credit,total_gradevalue,avg_gradepoint,creditpoint,gradevalue,gradepoint)  
values(@credit,@gradevalue,@avggrade,0,0,0)
------------------------
-------------------
  
select  ISNULL(total_credit,0) AS total_credit,ISNULL(total_gradevalue,0) AS total_gradevalue,ISNULL([avg_gradepoint],0) AS avg_gradepoint,
ISNULL([creditpoint],0) AS [creditpoint],ISNULL([gradevalue],0)AS [gradevalue],ISNULL([gradepoint],0)AS [gradepoint]
FROM [dbo].[tbl_Exam_Report]

end  
    ')
END

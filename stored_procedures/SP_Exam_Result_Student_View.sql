IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Result_Student_View]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Exam_Result_Student_View] --3,60950                                                                                            
(                                                                                      
@flag bigint=0,                                                            
@Exam_Master_id bigint=0  ,                  
@Course_id bigint=0,                  
@EntryType varchar(Max)=''R2'',                  
@Student_Id bigint=0                  
)                                                                                           
AS                                                                                            
                                                                                            
BEGIN                   
if(@flag=0)                  
begin                  
 select distinct MA.Student_Id,concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname)as Studentname,                  
AdharNumber,IDMatrixNo,S.SEMESTER_NO, cs.Semester_Name                
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                     
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                                
  inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=MA.Student_Id                 
  inner join Tbl_Student_Semester S on S.Candidate_Id=MA.Student_Id             
  left join Tbl_Course_Semester cs on cs.Semester_Id=s.SEMESTER_NO        
  where     EXM.Exam_Master_id=@Exam_Master_id                      
                    
 order by Studentname                     
end                  
if(@flag=1)                  
begin                  
 select  isnull(Sum(distinct G.GradePoint),0)as TotalGradepoints                  
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                     
      inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                               
  inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=MA.Student_Id                      
  left join Tbl_Mark_Entry_Acessset ASS on ASS.Master_Mark_ID=MA.ExamMarkEntryId           
   inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id  and NC.Course_id=MA.Course_Id          
   left join Tbl_GradingScheme GS on NC.Grade_Id=GS.Grade_Scheme_Id            
  left join Tbl_GradeSchemeSetup G on G.Grade_Scheme_Id=GS.Grade_Scheme_Id   and G.Grade=MA.Result_status                  
  where     EXM.Exam_Master_id=@Exam_Master_id   and Student_Id=@Student_Id and MA.EntryType=@EntryType                  
                      
end                  
if(@flag=2)                  
begin                  
 select   isnull(sum((cast(Course_credit AS bigint))*G.GradePoint),0) as creditvalue                  
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                     
      inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                               
  inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=MA.Student_Id                      
  left join Tbl_Mark_Entry_Acessset ASS on ASS.Master_Mark_ID=MA.ExamMarkEntryId           
   inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id  and NC.Course_id=MA.Course_Id          
   left join Tbl_GradingScheme GS on NC.Grade_Id=GS.Grade_Scheme_Id            
  left join Tbl_GradeSchemeSetup G on G.Grade_Scheme_Id=GS.Grade_Scheme_Id   and G.Grade=MA.Result_status                   
  where     EXM.Exam_Master_id=@Exam_Master_id   and Student_Id=@Student_Id and MA.EntryType=@EntryType                  
                      
end                  
if(@flag=3)                  
begin                  
                  
    select   sum(cast(Course_credit AS bigint)) as totalcreditunit                  
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                              
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                    
      inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                               
  inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=MA.Student_Id                      
  left join Tbl_Mark_Entry_Acessset ASS on ASS.Master_Mark_ID=MA.ExamMarkEntryId           
   inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id  and NC.Course_id=MA.Course_Id          
   left join Tbl_GradingScheme GS on NC.Grade_Id=GS.Grade_Scheme_Id            
  left join Tbl_GradeSchemeSetup G on G.Grade_Scheme_Id=GS.Grade_Scheme_Id   and G.Grade=MA.Result_status         
                
  where     EXM.Exam_Master_id=@Exam_Master_id and MA.EntryType=@EntryType                  
end                  
if(@flag=4)                
begin                
 select distinct NC.Course_Id,Concat(NC.Course_Name,''-'',NC.Course_code)as Coursename                
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                 
 inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id                
  where     EXM.Exam_Master_id=@Exam_Master_id                
end                
if(@flag=5)                
begin                
  select distinct MA.Student_Id, NC.Course_Id,Concat(NC.Course_Name,''-'',NC.Course_code)as Coursename  ,   
 NC.Course_Name as subjectame,NC.Course_code,NC.ContactHours        
 --,case when ASS.AssesmentSetup is null then ''0'' else   ASS.AssesmentSetup  end as AssesmentSetup,              
 --case when ASS.Mark is null then ''0'' else ASS.Mark end as Mark,              
 --case when G.GradePoint is null then ''0'' else G.GradePoint end as GradePoint,              
 --case when G.Pass  is null then ''Fail'' else  G.Pass end as PasStatus  ,,MA.Result_status          
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id            
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                 
  left join Tbl_Mark_Entry_Acessset ASS on ASS.Master_Mark_ID=MA.ExamMarkEntryId           
   inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id  --and NC.Course_id=MA.Course_Id          
   left join Tbl_GradingScheme GS on NC.Grade_Id=GS.Grade_Scheme_Id            
  left join Tbl_GradeSchemeSetup G on G.Grade_Scheme_Id=GS.Grade_Scheme_Id   and G.Grade=MA.Result_status               
              
  where     EXM.Exam_Master_id=@Exam_Master_id  and Student_Id=@Student_Id and MA.EntryType=@EntryType              
end          
if(@flag=6)                  
begin                  
 select distinct MA.Student_Id,concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname)as Studentname,                  
AdharNumber,IDMatrixNo,S.SEMESTER_NO, cs.Semester_Name                
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id                     
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                                
  inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=MA.Student_Id                 
  inner join Tbl_Student_Semester S on S.Candidate_Id=MA.Student_Id             
  left join Tbl_Course_Semester cs on cs.Semester_Id=s.SEMESTER_NO        
  where     EXM.Exam_Master_id=@Exam_Master_id    and MA.Student_Id=@Student_Id                  
                    
 order by Studentname                     
end         
if(@flag=7)        
begin        
 select sum(isnull(G.GradePoint,0)) as totalgp             
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id            
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                 
  left join Tbl_Mark_Entry_Acessset ASS on ASS.Master_Mark_ID=MA.ExamMarkEntryId           
   inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id  and NC.Course_id=MA.Course_Id          
   left join Tbl_GradingScheme GS on NC.Grade_Id=GS.Grade_Scheme_Id            
  left join Tbl_GradeSchemeSetup G on G.Grade_Scheme_Id=GS.Grade_Scheme_Id   and G.Grade=MA.Result_status               
              
  where     EXM.Exam_Master_id=@Exam_Master_id  and Student_Id=@Student_Id and MA.EntryType=@EntryType         
end        
if(@flag=8)                
begin                
 with level1 as(  select         sum( ASS.Mark) as Mark,G.Grade_Sheme_Setup_Id  
-- case when G.GradePoint is null then ''0'' else G.GradePoint end as GradePoint,                    
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id            
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                 
  left join Tbl_Mark_Entry_Acessset ASS on ASS.Master_Mark_ID=MA.ExamMarkEntryId           
   inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id  and NC.Course_id=MA.Course_Id          
   left join Tbl_GradingScheme GS on NC.Grade_Id=GS.Grade_Scheme_Id            
  left join Tbl_GradeSchemeSetup G on G.Grade_Scheme_Id=GS.Grade_Scheme_Id   and G.Grade=MA.Result_status               
              
  where    EXM.Exam_Master_id=@Exam_Master_id  and Student_Id=@Student_Id and MA.EntryType=@EntryType and MA.Course_Id=@Course_id   
  group by Grade_Sheme_Setup_Id)  
  select * from level1 as a  
  left join Tbl_GradeSchemeSetup G on G.Grade_Sheme_Setup_Id=a.Grade_Sheme_Setup_Id          
end    
if(@flag=9)                
begin                
 with level1 as(  select         sum( ASS.Mark) as Mark,G.Grade_Sheme_Setup_Id  
-- case when G.GradePoint is null then ''0'' else G.GradePoint end as GradePoint,                    
  from Tbl_Exam_Master EXM                     
  inner join Tbl_Exam_Schedule ES on Es.Exam_Master_id=EXM.Exam_Master_id                                                  
 inner join Tbl_Exam_Schedule_Details ESD on ESD.Exam_Schedule_Id=ES.Exam_Schedule_Id            
 inner join  Tbl_MarkEntryMaster   MA on MA.Exam_Id=EXM.Exam_Master_id                 
  left join Tbl_Mark_Entry_Acessset ASS on ASS.Master_Mark_ID=MA.ExamMarkEntryId   
   inner join Tbl_New_Course NC on Nc.Course_Id=ES.Course_id  and NC.Course_id=MA.Course_Id          
   left join Tbl_GradingScheme GS on NC.Grade_Id=GS.Grade_Scheme_Id            
  left join Tbl_GradeSchemeSetup G on G.Grade_Scheme_Id=GS.Grade_Scheme_Id   and G.Grade=MA.Result_status               
              
  where    EXM.Exam_Master_id=@Exam_Master_id  and Student_Id=@Student_Id and MA.EntryType=@EntryType and MA.Course_Id=@Course_id   
  group by Grade_Sheme_Setup_Id)  
  select * from level1 as a  
  left join Tbl_GradeSchemeSetup G on G.Grade_Sheme_Setup_Id=a.Grade_Sheme_Setup_Id            
end  
END 
    ')
END

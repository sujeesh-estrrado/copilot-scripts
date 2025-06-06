IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SelectCGPA]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_SelectCGPA]  
(@Candidate_Id bigint)       
as      
begin      
truncate table TempTerm      
truncate table tempMain      
truncate table TempCredithrs      
truncate table tempCGP      
      
insert into  tempMain  select EC.ExamCode,SC.SubjectName,SC.CurrentStatus,SC.Term Exam_Term,EC.Candidate_Id,
S.Contact_Hours timing,      
  EC.Grade,GSS.GradePoint,S.Contact_Hours*GSS.GradePoint TotalGP,GSS.Pass,      
  (select top 1 ExamDate from  dbo.Tbl_Exam_Code_Master EE  inner join       
  Tbl_Exam_Code_Child EX on EE.Exam_Code_Master_Id=EX.Exam_Code_Master_Id      
   where EX.Exam_Code_final=EC.ExamCode ) as [Exam_date]      
         
 from  Tbl_Exam_Mark_Entry_Child EC        
inner join Tbl_StudentExamSubjectsChild SC on EC.ExamCode=SC.ExamCode        
inner join Tbl_GradingScheme GS on GS.Grade_Scheme=SC.GradingScherme        
inner join Tbl_GradeSchemeSetup GSS on GSS.Grade_Scheme_Id=GS.Grade_Scheme_Id-- and EC.Grade=GSS.Grade        
inner join Tbl_GroupChangeExamDates GD on GD.ExamCode=EC.ExamCode      
inner join Tbl_Subject S on  SC.SubjectId=S.Subject_Id       
where EC.Candidate_Id=@Candidate_Id      
      
insert into tempCGP select sum(TotalGP) as TotalGp,Sum(timing) as CreditHrs,sum(TotalGP)/Sum(timing) as GPA,Exam_term   from  tempMain group by Exam_term       
      
insert into TempCredithrs select Sum(timing)as TotCreditHrs,Exam_term   from  tempMain where Pass=''PASS'' group by Exam_term       
      
      
insert into TempTerm      
(Term)      
select Exam_term from(select distinct(Exam_term),[Exam_date] from tempMain) a order by [Exam_date] asc      
      
declare @count int      
declare @iCount int      
declare @TotalCredithrs decimal(18,2)      
declare @TotalCGPA decimal(18,2)      
declare @TotalCGPAhrs int      
declare @TotalCGPATothrs int      
declare @CumTotalCredithrs decimal(18,2)      
declare @CumTotalCGPA decimal(18,2)      
declare @CurrentRow varchar(50)      
set @iCount=0      
set @CurrentRow=0      
set @TotalCredithrs=0      
set @TotalCGPA=0      
set @CumTotalCGPA=0      
set @CumTotalCredithrs=0      
set @TotalCGPAhrs=0      
set @TotalCGPATothrs=0      
      
Select @count =count(RID)from TempTerm      
      
while @iCount<@count      
begin      
select @CurrentRow=Term from TempTerm where RID=@iCount+1      
select @TotalCredithrs=TotCreditHrs from TempCredithrs where Exam_term=@CurrentRow      
      
select @TotalCGPA=TotalGP,@TotalCGPAhrs=Credithrs from tempCGP where Exam_term=@CurrentRow      
set @CumTotalCredithrs=@CumTotalCredithrs+@TotalCredithrs      
set @CumTotalCGPA=@CumTotalCGPA+@TotalCGPA      
set @TotalCGPATothrs=@TotalCGPATothrs+@TotalCGPAhrs      
      
update TempTerm set TotalCreditHours=@CumTotalCredithrs,CGPA=@CumTotalCGPA/@TotalCGPATothrs where RID=@iCount+1      
      
set @iCount=@iCount+1      
      
end      
      
      
select T1.*,T2.TotalCreditHours,T2.CGPA,T3.GPA from tempMain T1 inner join TempTerm T2 on T1.Exam_Term=T2.Term        
inner join tempCGP T3 ON T1.Exam_Term=T3.Exam_Term      
      
END
    ')
END

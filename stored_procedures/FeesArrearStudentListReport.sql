IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FeesArrearStudentListReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[FeesArrearStudentListReport]    
      
AS    
BEGIN    
declare @TotalCount  int    
declare @LoopCount int    
declare @CandidateId bigint    
declare @IntakeId bigint    
set @LoopCount=1    
delete from Get_Fee_Arrear_Student_Report    
create table #temptable(Id int identity(1,1) primary key,Candidate_Id bigint,Intake_Id bigint)    
Create table #FeeCategorys (Cat_ID int IDENTITY(1,1) primary key,FeeCategory varchar(100))--- Temporary Table Fee Category Creation    
Create table #FeeCategoryTable(Id int identity(1,1) primary key,DueDate varchar(50),Balence decimal(18,2),Paid decimal(18,2),Amount decimal(18,2),    
Intake_id bigint,Course_Code varchar(100),OldICPassport varchar(100),Candidate_Name varchar(100),    
Candidate_Mob bigint,Candidate_Id bigint)--- Temporary Table All Fee Categorys Creation    
--create table #FinalCandidateView(Id int identity(1,1) primary key,Candidate_Id bigint)---Temporary Table All FeeDetails(less than current day)    
--create table SP_Get_Fee_Arrear_Student_Report(DueDate varchar(50),Balence decimal(18,2),Paid decimal(18,2),Amount decimal(18,2),    
--Intake_id bigint,Course_Code varchar(100),OldICPassport varchar(100),Candidate_Name varchar(100),    
--Candidate_Mob bigint,Candidate_Id bigint)    
--create table #Final    
--create table #FeeCategoryTable1(DueDate varchar(50),Balance decimal(18,2),Amount decimal(18,2))---Temporary Table(Get Total_Fee_Arrear Current)    
insert into #temptable(Candidate_Id,Intake_Id)    
select distinct CPD.Candidate_Id,NA.Batch_Id from Tbl_Candidate_Personal_Det CPD     
inner join tbl_New_Admission NA on CPD.New_Admission_Id=NA.New_Admission_Id    
set @TotalCount =(select count(id) from #temptable)    
    
while(@LoopCount<=@TotalCount)    
begin    
set @CandidateId=(select T.Candidate_Id from #temptable as T where T.Id=@LoopCount)    
set @IntakeId=(select T.Intake_Id from #temptable as T where T.Id=@LoopCount)    
------------------------    
    
    
declare @Counts int    
declare @LoopCount1 int   ----For While loop Itration    
Declare @Category_Name varchar(100)    
set @LoopCount1=1     
set @Counts=(select  Count ( DISTINCT FC.FeeCategory) from dbo.Tbl_IntakeFeecodeMap IFM  ---Count Generation for Fee Category       
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=IFM.FeeCode          
inner join dbo.Tbl_Feecategory FC on FC.FeeCategoryId=FS.Fee_Category           
inner join dbo.Tbl_FeecodeStudentMap FSM on FSM.Feecode=FS.Scheme_Code          
where IFM.IntakeId=@IntakeId and FSM.Candidate_Id=@CandidateId)          
          
insert into #FeeCategorys (FeeCategory)select DISTINCT FC.FeeCategory from dbo.Tbl_IntakeFeecodeMap IFM ----  insertion to Temporary Table Fee Category      
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=IFM.FeeCode          
inner join dbo.Tbl_Feecategory FC on FC.FeeCategoryId=FS.Fee_Category           
inner join dbo.Tbl_FeecodeStudentMap FSM on FSM.Feecode=FS.Scheme_Code          
where IFM.IntakeId=@IntakeId and FSM.Candidate_Id=@CandidateId    
    
    
while(@LoopCount1<=@Counts)---- Begin While Loop     
begin    
set @Category_Name=(select T.FeeCategory from #FeeCategorys as T where T.Cat_ID=@LoopCount)    
print @Category_Name    
------------------------------------------------------------------------------BEGIN    
    
    
--due date for PTPN fees category          
if(@Category_Name=''PTPTN FEES'')          
begin          
insert into #FeeCategoryTable (DueDate,Balence,Paid,Amount,Intake_id,Course_Code,OldICPassport,Candidate_Name,Candidate_Mob,Candidate_Id) select --'''' as ItemDescription,'''' as FeeHeadId,          
--insert into #FeeCategoryTable1 (DueDate,Balance,Amount)    
distinct convert(varchar(50),PP.Payment_Due_Date,103) as duedate,       
--CASE FEM.typ WHEN ''MISC'' THEN  Miscellaneous_due_date        
 (select Balance from dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and    
 IntakeId=@IntakeId and FeeHeadId=FSD.Feehead_Id and ItemDescription=FSD.ItemDescription)as balance,    
  (select Paid from dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and    
 IntakeId=@IntakeId and FeeHeadId=FSD.Feehead_Id and ItemDescription=FSD.ItemDescription)as Paid,       
FSD.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id                    from dbo.Tbl_PTPN_Payment PP          
inner join dbo.Tbl_PTPN_Child PC on PC.PTPN_Setting_Id=PP.PTPN_Setting_Id          
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=PC.Batch_Id          
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=IFM.FeeCode          
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code     
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id       
inner join Tbl_Department D on D.Department_Id=NA.Department_Id        
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id        
where PC.Batch_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId           
      
      
UNION       
      
SELECT DISTINCT       
convert(varchar(50),(FEM.Miscellaneous_due_date),103) as duedate,        
FEM.Balance as balance,FEM.Paid as Paid,FEM.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id                       
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC              
on FC.CourseId=FSMP.Course_Id    
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id       
inner join Tbl_Department D on D.Department_Id=NA.Department_Id              
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId               
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id              
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id             
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId  and FEM.Miscellaneous_due_date is not null       
        
union      
              
select distinct  --FEM.ItemDescription,FEM.FeeHeadId,          
convert(varchar(50),dateadd(day,FCD.PeriodInDays,CBD.Batch_From),103) as duedate,              
FEM.Balance as balance,FEM.Paid as Paid,FCD.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id              
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC              
on FC.CourseId=FSMP.Course_Id      
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id    
inner join Tbl_Department D on D.Department_Id=NA.Department_Id            
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId               
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id              
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id             
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId           
        
 END      
      
          
--due date for semester wise fee collection          
else if(@Category_Name=''SEMESTER FEES'')              
begin          
insert into #FeeCategoryTable (DueDate,Balence,Paid,Amount,Intake_id,Course_Code,OldICPassport,Candidate_Name,Candidate_Mob,Candidate_Id) select convert(varchar(50),cdp.Duration_Period_To,103) as duedate,          
(select Balance from dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and     
IntakeId=@IntakeId and FeeHeadId=FSD.Feehead_Id and ItemDescription=FSD.ItemDescription)as balance,    
(select Paid from dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and     
IntakeId=@IntakeId and FeeHeadId=FSD.Feehead_Id and ItemDescription=FSD.ItemDescription)as Paid,        
FSD.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id          
from dbo.Tbl_Course_Duration_PeriodDetails cdp          
inner join dbo.Tbl_Course_Semester cs on cs.Semester_Id=cdp.Semester_Id          
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=cdp.Batch_Id          
inner join dbo.Tbl_Fee_Settings fs on fs.Scheme_Code=IFM.FeeCode          
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id and FSD.SemesterCode=cs.Semester_Code          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code    
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id    
inner join Tbl_Department D on D.Department_Id=NA.Department_Id        
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id      
where cdp.Batch_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId          
         
      
UNION      
        
SELECT DISTINCT       
convert(varchar(50),(FEM.Miscellaneous_due_date),103) as duedate,        
FEM.Balance as balance,FEM.Paid as Paid,FEM.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id                
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC              
on FC.CourseId=FSMP.Course_Id     
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id    
inner join Tbl_Department D on D.Department_Id=NA.Department_Id              
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId               
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id              
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id             
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId and FEM.Miscellaneous_due_date is not null          
          
union      
               
select distinct  --FEM.ItemDescription,FEM.FeeHeadId,          
convert(varchar(50),dateadd(day,FCD.PeriodInDays,CBD.Batch_From),103) as duedate,              
FEM.Balance as balance,FEM.Paid as Paid,FCD.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id               
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC              
on FC.CourseId=FSMP.Course_Id       
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id    
inner join Tbl_Department D on D.Department_Id=NA.Department_Id           
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId               
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id              
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id             
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId         
      
      
end          
          
--due date for all other category of fees          
else           
begin          
insert into #FeeCategoryTable(DueDate,Balence,Paid,Amount,Intake_id,Course_Code,OldICPassport,Candidate_Name,Candidate_Mob,Candidate_Id) --select distinct --FEM.ItemDescription,FEM.FeeHeadId,            
select distinct --FEM.ItemDescription,FEM.FeeHeadId,            
convert(varchar(50),dateadd(day,FSD.Period_In_Days,CBD.Batch_From),103) as duedate,              
FEM.Balance as balance,FEM.Paid as Paid, FSD.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id              
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Settings FS              
on FS.Scheme_Code=FSMP.Feecode        
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id    
inner join Tbl_Department D on D.Department_Id=NA.Department_Id                    
inner join dbo.TBL_FeeSettingsDetails FSD on FS.Fee_Settings_Id=FSD.Fee_Settings_Id               
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id              
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id              
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId            
          
UNION      
     
SELECT DISTINCT       
convert(varchar(50),(FEM.Miscellaneous_due_date),103) as duedate,        
FEM.Balance as balance,FEM.Paid as Paid,FEM.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id             
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC              
on FC.CourseId=FSMP.Course_Id    
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id    
inner join Tbl_Department D on D.Department_Id=NA.Department_Id              
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId               
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id              
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id             
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId  and FEM.Miscellaneous_due_date is not null          
       
union              
              
select distinct --FEM.ItemDescription,FEM.FeeHeadId,          
convert(varchar(50),dateadd(day,FCD.PeriodInDays,CBD.Batch_From),103) as duedate,              
FEM.Balance as balance,FEM.Paid as Paid,FCD.Amount,CBD.Batch_Code,D.Course_Code,CPD.AdharNumber,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as FullName,CCD.Candidate_Mob1,CPD.Candidate_Id             
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC              
on FC.CourseId=FSMP.Course_Id           
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=FSMP.Candidate_Id      
inner join Tbl_Candidate_ContactDetails CCD on CCD.Candidate_Id=FSMP.Candidate_Id    
inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id    
inner join Tbl_Department D on D.Department_Id=NA.Department_Id    
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId               
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id              
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id      
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId            
      
 END      
    
---------------------------------------------------------------------------------END    
    
set @LoopCount1=@LoopCount1+1    
End            ----End While     
--select * from #FeeCategoryTable    
    
----------------    
set @LoopCount=@LoopCount+1    
End    
--select * from #temptable    
    
    
--declare @totcount bigint    
--declare @delete decimal(18,2)    
--declare @loopcou bigint    
--declare @id bigint    
--declare @TotBal decimal(18,2)    
----select * from #FeeCategoryTable    
--insert into #FinalCandidateView(Candidate_Id)    
--select Candidate_Id from #FeeCategoryTable    
--set @totcount =(select count(Candidate_Id) from #FinalCandidateView)    
--set @loopcou=1    
--while(@loopcou<=@totcount)    
--begin    
----set @id=(select Id from #FinalCandidateView where Id=@loopcou)    
--set @TotBal=(select sum(Amount)-sum(Paid) from #FeeCategoryTable where Id= @loopcou)    
--if(@TotBal>0)    
--begin    
--insert into #FinalResult(DueDate,Balence,Paid,Amount,Intake_id,Course_Code,OldICPassport,Candidate_Name,Candidate_Mob,Candidate_Id)    
--select DueDate,Balence,Paid,Amount,Intake_id,Course_Code,OldICPassport,Candidate_Name,Candidate_Mob,Candidate_Id from #FeeCategoryTable    
--End    
--set @loopcou=@loopcou+1    
    
--End    
    
    
    
    
--select * from #FeeCategoryTable    
declare @totcou bigint    
declare @delete decimal(18,2)    
declare @loopcou bigint    
declare @id bigint    
declare @TotBal decimal(18,2)    
set @loopcou=1    
set @totcou=(select count(Candidate_Id) from #FeeCategoryTable)    
while(@loopcou<=@totcou)    
begin     
set @TotBal=(select sum(Amount)-ISNULL(sum(Paid),0) from #FeeCategoryTable where Id= @loopcou)    
if(@TotBal>0)    
begin     
insert into Get_Fee_Arrear_Student_Report(DueDate,Balence,Paid,Amount,Intake_id,Course_Code,OldICPassport,Candidate_Name,Candidate_Mob,Candidate_Id)    
select DueDate,Balence,Paid,Amount,Intake_id,Course_Code,OldICPassport,Candidate_Name,Candidate_Mob,Candidate_Id from #FeeCategoryTable where Id=@loopcou    
    
end    
set @loopcou=@loopcou+1    
end    
    
select * from #FeeCategoryTable    
--select * from Get_Fee_Arrear_Student_Report    
--select T.Intake_id,T.Course_Code,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id,    
--sum(T.Paid)as Paid,Sum(T.Amount)as Amount,(Sum(T.Amount)-isnull(sum(T.Paid),0)) as Total from SP_Get_Fee_Arrear_Student_Report T group by T.Intake_id,T.Course_Code,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id    
--insert into #FinalCandidateView(Candidate_Id)    
--select * from #FeeCategoryTable    
    
--select T.Intake_id,T.Course_Code,Sum(T.Paid)as Paid,sum(T.Amount) as Amount,(sum(T.Amount)-isnull(sum(T.Paid),0))as Total,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id from SP_Get_Fee_Arrear_Student_Report as T    
--where datepart(dd,convert(datetime,(DueDate),103))<=datepart(dd,dateadd(dd,0,getdate())) and datepart(yyyy,convert(datetime,(DueDate),103))<=datepart(year,dateadd(year,0,getdate()))    
--group by T.Intake_id,T.Course_Code,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id    
    
--select T.Intake_id,T.Course_Code,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id,sum(T.Amount),Sum(T.Balence),(sum(T.Amount)-isnull(sum(T.Balence),0))as Total from #FeeCategoryTable as T    
--where datepart(dd,convert(datetime,(Duedate),103))<=datepart(dd,dateadd(dd,0,getdate())) and datepart(yyyy,convert(datetime,(Duedate),103))<=datepart(year,dateadd(year,0,getdate()))    
--group by T.Intake_id,T.Course_Code,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id    
    
--  select T.Intake_id,T.Course_Code,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id,    
--sum(T.Paid)as Paid,Sum(T.Amount)as Amount,(Sum(T.Amount)-isnull(sum(T.Paid),0)) as Total from Get_Fee_Arrear_Student_Report T    
--where convert(datetime,(T.DueDate),103)<= convert(varchar(10), getdate(), 120)    
-- group by T.Intake_id,T.Course_Code,T.OldICPassport,T.Candidate_Name,T.Candidate_Mob,T.Candidate_Id,T.Course_Code    
-- order by T.Course_Code    
    
    
    
    
    
--select sum(Amount) from #FeeCategoryTable    
--declare @vza decimal(18,2)    
    
--(select sum(Amount)as NonCurrent from #FeeCategoryTable)    
--select sum(Amount)as CurrentMonth from #FeeCategoryTable where datepart(mm,convert(datetime,(Duedate),103))=datepart(month,dateadd(month,0,getdate()))    
--and datepart(yyyy,convert(datetime,(Duedate),103))=datepart(year,dateadd(year,0,getdate()))    
  --datepart(dd,convert(datetime,(Duedate),103))=datepart(dd,dateadd(dd,0,getdate()))    
    
 End  
 --select * from Get_Fee_Arrear_Student_Report
    ')
END

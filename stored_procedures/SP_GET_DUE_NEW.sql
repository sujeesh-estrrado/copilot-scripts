IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_DUE_NEW]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GET_DUE_NEW] --11829,804  --11829,275  
(@IntakeId bigint,@CandidateId bigint)        
        
as begin        
Create table #FeeCategorys (Cat_ID int IDENTITY(1,1) primary key,FeeCategory varchar(100))--- Temporary Table Fee Category Creation  
Create table #FeeCategoryTable (duedate varchar(100),balance int,Amount decimal(18,2))--- Temporary Table All Fee Categorys Creation  
  
declare @Counts int  
declare @LoopCount int   ----For While loop Itration  
Declare @Category_Name varchar(100)  
set @LoopCount=1   
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
  
  
while(@LoopCount<=@Counts)---- Begin While Loop   
begin  
set @Category_Name=(select T.FeeCategory from #FeeCategorys as T where T.Cat_ID=@LoopCount)  
print @Category_Name  
------------------------------------------------------------------------------BEGIN  
  
  
--due date for PTPN fees category        
if(@Category_Name=''PTPTN FEES'')        
begin        
insert into #FeeCategoryTable (duedate,balance,Amount) select --'''' as ItemDescription,'''' as FeeHeadId,        
distinct convert(varchar(50),PP.Payment_Due_Date,103) as duedate,     
--CASE FEM.typ WHEN ''MISC'' THEN  Miscellaneous_due_date      
 (select Balance from dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and  
 IntakeId=@IntakeId and FeeHeadId=FSD.Feehead_Id and ItemDescription=FSD.ItemDescription)as balance,      
FSD.Amount from dbo.Tbl_PTPN_Payment PP        
inner join dbo.Tbl_PTPN_Child PC on PC.PTPN_Setting_Id=PP.PTPN_Setting_Id        
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=PC.Batch_Id        
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=IFM.FeeCode        
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id        
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code        
where PC.Batch_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId        
    
    
UNION     
    
SELECT DISTINCT     
convert(varchar(50),(FEM.Miscellaneous_due_date),103) as duedate,      
FEM.Balance as balance,FEM.Amount           
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC            
on FC.CourseId=FSMP.Course_Id            
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id           
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId  and FEM.Miscellaneous_due_date is not null        
    
      
union               
select distinct  --FEM.ItemDescription,FEM.FeeHeadId,        
convert(varchar(50),dateadd(day,FCD.PeriodInDays,CBD.Batch_From),103) as duedate,            
FEM.Balance as balance,FCD.Amount           
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC            
on FC.CourseId=FSMP.Course_Id            
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id           
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId          
      
 END    
    
        
--due date for semester wise fee collection        
else if(@Category_Name=''SEMESTER FEES'')            
begin        
insert into #FeeCategoryTable (duedate,balance,Amount) select convert(varchar(50),cdp.Duration_Period_To,103) as duedate,        
(select Balance from dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and   
IntakeId=@IntakeId and FeeHeadId=FSD.Feehead_Id and ItemDescription=FSD.ItemDescription)as balance,      
FSD.Amount       
from dbo.Tbl_Course_Duration_PeriodDetails cdp        
inner join dbo.Tbl_Course_Semester cs on cs.Semester_Id=cdp.Semester_Id        
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=cdp.Batch_Id        
inner join dbo.Tbl_Fee_Settings fs on fs.Scheme_Code=IFM.FeeCode        
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id and FSD.SemesterCode=cs.Semester_Code        
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code        
where cdp.Batch_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId        
       
    
UNION    
      
SELECT DISTINCT     
convert(varchar(50),(FEM.Miscellaneous_due_date),103) as duedate,      
FEM.Balance as balance,FEM.Amount           
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC            
on FC.CourseId=FSMP.Course_Id            
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id           
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId and FEM.Miscellaneous_due_date is not null     
        
    
union               
select distinct  --FEM.ItemDescription,FEM.FeeHeadId,        
convert(varchar(50),dateadd(day,FCD.PeriodInDays,CBD.Batch_From),103) as duedate,            
FEM.Balance as balance,FCD.Amount            
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC            
on FC.CourseId=FSMP.Course_Id            
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id           
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId         
    
    
end        
        
--due date for all other category of fees        
else         
begin        
insert into #FeeCategoryTable(duedate,balance,Amount) select distinct --FEM.ItemDescription,FEM.FeeHeadId,          
convert(varchar(50),dateadd(day,FSD.Period_In_Days,CBD.Batch_From),103) as duedate,            
FEM.Balance as balance, FSD.Amount           
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Settings FS            
on FS.Scheme_Code=FSMP.Feecode            
inner join dbo.TBL_FeeSettingsDetails FSD on FS.Fee_Settings_Id=FSD.Fee_Settings_Id             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id            
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId          
        
        
UNION     
SELECT DISTINCT     
convert(varchar(50),(FEM.Miscellaneous_due_date),103) as duedate,      
FEM.Balance as balance,FEM.Amount           
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC            
on FC.CourseId=FSMP.Course_Id            
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id           
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId  and FEM.Miscellaneous_due_date is not null       
     
            
union            
            
select distinct --FEM.ItemDescription,FEM.FeeHeadId,        
convert(varchar(50),dateadd(day,FCD.PeriodInDays,CBD.Batch_From),103) as duedate,            
FEM.Balance as balance,FCD.Amount             
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Compulsory FC            
on FC.CourseId=FSMP.Course_Id            
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FC.CompulsoryFeeId=FCD.CumpulsoryFeeId             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id           
where FSMP.Intake_Id=@IntakeId and FSMP.Candidate_Id=@CandidateId          
    
    
  END    
  
  
---------------------------------------------------------------------------------END  
  
set @LoopCount=@LoopCount+1  
End            ----End While   
select * from #FeeCategoryTable  
END
   ');
END;

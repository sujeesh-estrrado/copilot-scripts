IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_BALANCE_DUE_TUITION]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_GET_BALANCE_DUE_TUITION] --11830,157,''tuition'',''FULL CASH''    
    
(@Intake bigint,@Candidate_Id bigint,@Itemdesc varchar(100),@FeeCat VARCHAR(50))    
    
as begin    
    
    
    
declare @cnt bigint    
set @cnt=(select count(Fee_Entry_Id)from dbo.Tbl_Fee_Entry_Main where Candidate_Id=@Candidate_Id and IntakeId=@Intake and  FeeHeadId=3 and ItemDescription=@Itemdesc and ActiveStatus is null)    
    
if(@cnt>0)    
begin    
    
if(@FeeCat=''PTPTN FEES'')    
begin    
    
select FSD.ItemDescription,FSD.Feehead_Id,    
datediff(day,convert(datetime,PP.Payment_Due_Date,103),getdate()) as datedifference,convert(varchar(50),PP.Payment_Due_Date,103) as duedate,     
FEM.balance as balance, FSD.Amount    
from dbo.Tbl_PTPN_Payment PP        
inner join dbo.Tbl_PTPN_Child PC on PC.PTPN_Setting_Id=PP.PTPN_Setting_Id        
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=PC.Batch_Id        
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=IFM.FeeCode        
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id        
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code     
inner join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id and FEM.ActiveStatus is null and FEM.ItemDescription=FSD.ItemDescription            
where FSMP.Intake_Id=@Intake and FSMP.Candidate_Id=@Candidate_Id --and FSD.Feehead_Id=3
 and FSD.ItemDescription=@Itemdesc    
    
end    
else if(@FeeCat=''SEMESTER FEES'')    
begin    
    
select FSD.ItemDescription,FSD.Feehead_Id,    
 datediff(day,convert(datetime,cdp.Duration_Period_To,103),getdate()) as datedifference,convert(varchar(50),cdp.Duration_Period_To,103) as duedate,    
FEM.balance as balance, FSD.Amount    
from dbo.Tbl_Course_Duration_PeriodDetails cdp        
inner join dbo.Tbl_Course_Semester cs on cs.Semester_Id=cdp.Semester_Id        
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=cdp.Batch_Id        
inner join dbo.Tbl_Fee_Settings fs on fs.Scheme_Code=IFM.FeeCode        
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id and FSD.SemesterCode=cs.Semester_Code        
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code     
inner join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id and FEM.ActiveStatus is null and FEM.ItemDescription=FSD.ItemDescription            
where cdp.Batch_Id=@Intake and FSMP.Candidate_Id=@Candidate_Id 
--and FSD.Feehead_Id=3
 and FSD.ItemDescription=@Itemdesc       
    
end    
else    
begin    
select  FSD.ItemDescription,FSD.Feehead_Id,          
datediff(day,convert(datetime,dateadd(day,FSD.Period_In_Days,CBD.Batch_From),103),getdate()) as datedifference,convert(varchar(50),dateadd(day,FSD.Period_In_Days,CBD.Batch_From),103) as duedate,            
FEM.balance as balance,    
 FSD.Amount           
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Settings FS            
on FS.Scheme_Code=FSMP.Feecode            
inner join dbo.TBL_FeeSettingsDetails FSD on FS.Fee_Settings_Id=FSD.Fee_Settings_Id             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
inner join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id and FEM.ActiveStatus is null and FEM.ItemDescription=FSD.ItemDescription            
where FSMP.Intake_Id=@Intake and FSMP.Candidate_Id=@Candidate_Id --and FSD.Feehead_Id=3 
and FSD.ItemDescription=@Itemdesc    
end    
end    
    
else    
begin    
    
if(@FeeCat=''PTPTN FEES'')    
begin    
select FSD.ItemDescription,FSD.Feehead_Id,    
datediff(day,convert(datetime,PP.Payment_Due_Date,103),getdate()) as datedifference,convert(varchar(50),PP.Payment_Due_Date,103) as duedate,     
FSD.Amount as balance, FSD.Amount    
from dbo.Tbl_PTPN_Payment PP        
inner join dbo.Tbl_PTPN_Child PC on PC.PTPN_Setting_Id=PP.PTPN_Setting_Id        
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=PC.Batch_Id        
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=IFM.FeeCode        
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id        
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code     
inner join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=FSMP.Candidate_Id and FEM.ActiveStatus is null and FEM.ItemDescription=FSD.ItemDescription            
where FSMP.Intake_Id=@Intake and FSMP.Candidate_Id=@Candidate_Id --and FSD.Feehead_Id=3 
and 
FSD.ItemDescription=@Itemdesc    
    
    
end    
else if(@FeeCat=''SEMESTER FEES'')    
begin    
select FSD.ItemDescription,FSD.Feehead_Id,    
 datediff(day,convert(datetime,cdp.Duration_Period_To,103),getdate()) as datedifference,convert(varchar(50),cdp.Duration_Period_To,103) as duedate,    
FSD.Amount as balance, FSD.Amount    
from dbo.Tbl_Course_Duration_PeriodDetails cdp        
inner join dbo.Tbl_Course_Semester cs on cs.Semester_Id=cdp.Semester_Id        
inner join dbo.Tbl_IntakeFeecodeMap IFM on IFM.IntakeId=cdp.Batch_Id        
inner join dbo.Tbl_Fee_Settings fs on fs.Scheme_Code=IFM.FeeCode        
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id and FSD.SemesterCode=cs.Semester_Code        
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Feecode=FS.Scheme_Code     
where cdp.Batch_Id=@Intake and FSMP.Candidate_Id=@Candidate_Id --and FSD.Feehead_Id=3
 and FSD.ItemDescription=@Itemdesc       
    
end    
else    
    
begin    
select  FSD.ItemDescription,FSD.Feehead_Id,          
datediff(day,convert(datetime,dateadd(day,FSD.Period_In_Days,CBD.Batch_From),103),getdate()) as datedifference,convert(varchar(50),dateadd(day,FSD.Period_In_Days,CBD.Batch_From),103) as duedate,            
FSD.Amount as balance,    
 FSD.Amount           
from dbo.Tbl_FeecodeStudentMap FSMP inner  join dbo.Tbl_Fee_Settings FS            
on FS.Scheme_Code=FSMP.Feecode            
inner join dbo.TBL_FeeSettingsDetails FSD on FS.Fee_Settings_Id=FSD.Fee_Settings_Id             
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id            
where FSMP.Intake_Id=@Intake and FSMP.Candidate_Id=@Candidate_Id --and FSD.Feehead_Id=3  
and FSD.ItemDescription=@Itemdesc    
end    
end    
end
   ')
END;

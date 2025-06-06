IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DUE_REPORT_CAMPUS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
         
-- exec SP_DUE_REPORT_CAMPUS '''',''''                          
CREATE procedure [dbo].[SP_DUE_REPORT_CAMPUS] --1,3 914,17 --259,11830                     
                          
(@Department_Id bigint,@Batch_Id bigint)                          
                          
as begin                          
                          
                          
                          
select B.CandidateName,B.Candidate_Id,sum(B.Amountobepaid) AS Amounttobepaid,                          
B.Batch_Id,B.AdharNumber,B.Department_Name,isnull(B.paid,0) as paid,isnull(sum(B.Amountobepaid)-B.paid,0) as Balance,                          
B.Batch_Code, --from                
isnull(C.balance,0) as dueamount ,B.Department_Id from                           
                          
                          
(select A.Candidate_Id,A.CandidateName,A.AdharNumber,A.Batch_Code,A.Batch_Id,sum(A.Amountobepaid) as Amountobepaid,A.Department_Name,A.Department_Id                          
,(select sum(Paid) as paid from dbo.Tbl_Fee_Entry_Main FE where FE.Candidate_Id=A.Candidate_Id and FE.IntakeId=A.Batch_Id and FE.ActiveStatus is null) as paid                          
,sum(A.Amountobepaid)- (select isnull(Sum(paid),0) as paid from dbo.Tbl_Fee_Entry FE  where FE.Candidate_Id=A.Candidate_Id and FE.IntakeId=A.Batch_Id) as Balance  from (                          
                          
(select CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                          
CPD.AdharNumber,CBD.Batch_Code,Sum(FSD.Amount) as Amountobepaid,CBD.Batch_Id,                          
--FEM.Paid,FSD.Feehead_Id,                          
D.Department_Name,D.Department_Id                          
--,FSD.Period_In_Days,convert(varchar(50),dateadd(dd,FSD.Period_In_Days,CBD.Batch_From),103) as duedate                          
--,sum(FSD.Amount)-Paid as balance                          
                          
from dbo.Tbl_Candidate_Personal_Det CPD                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
inner join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id                          
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id                          
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id                          
--inner join dbo.Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id                          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                          
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=FSMP.Feecode                          
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id                          
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.typ=''Normal''                          
 and FEM.ActiveStatus is null and FEM.ItemDescription=FSD.ItemDescription       
WHERE SS.Student_Semester_Current_Status=1 group by CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname,                          
CPD.AdharNumber,CBD.Batch_Code ,D.Department_Name,CBD.Batch_Id,D.Department_Id                      
--,FSD.Period_In_Days,CBD.Batch_From                          
)                          
union                          
(                          
select   CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                          
CPD.AdharNumber,CBD.Batch_Code,sum(FCD.Amount)as Amountobepaid,CBD.Batch_Id,                          
--FEM.Paid,FCD.FeeHeadId as Feehead_Id,                
--FCD.FeeHeadId as Feehead_Id,FCD.ItemDescription,                         
D.Department_Name,D.Department_Id                          
--,FCD.PeriodInDays,convert(varchar(50),dateadd(dd,FCD.PeriodInDays,CBD.Batch_From),103) as duedate                          
--,sum(FSD.Amount)-Paid as balance                          
                          
from dbo.Tbl_Candidate_Personal_Det CPD                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
inner join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id                          
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id                          
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id                 
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                                   
--inner join dbo.Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id                          
inner join dbo.Tbl_Fee_Compulsory FC on   FC.TypeOfStudent=CPD.TypeOfStudent and FC.CourseId=FSMP.Course_Id                          
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FCD.CumpulsoryFeeId=FC.CompulsoryFeeId                          
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.typ=''Compulsory'' and FEM.ActiveStatus is null                 
and FEM.ItemDescription=FCD.ItemDescription  WHERE SS.Student_Semester_Current_Status=1                    
--where     CPD.Candidate_Id=157                       
     group by CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname,                          
CPD.AdharNumber,CBD.Batch_Code,D.Department_Name,CBD.Batch_Id,D.Department_Id--,FCD.FeeHeadId,FCD.ItemDescription                   
--,FCD.PeriodInDays,CBD.Batch_From                           
)                          
union                          
(select DISTINCT CPD.Candidate_Id, CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                          
CPD.AdharNumber,                          
CBD.Batch_Code,                          
sum(FEM.Amount) as Amountobepaid,CBD.Batch_Id,                          
--FEM.Paid,FEM.FeeHeadId as Feehead_Id,                          
D.Department_Name,D.Department_Id                          
--,''0'' AS PeriodInDays,''0'' as duedate                          
--,sum(FSD.Amount)-Paid as balance                          
                          
from dbo.Tbl_Fee_Entry_Main FEM INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD                           
ON FEM.Candidate_Id=CPD.Candidate_Id                          
                          
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=FEM.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
                          
inner join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=FEM.Candidate_Id                          
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id                          
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id                          
where FEM.typ=''MISC'' and FEM.ActiveStatus is null AND  SS.Student_Semester_Current_Status=1                           
group by CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname,                          
CPD.AdharNumber,CBD.Batch_Code ,FEM.Paid,D.Department_Name,CBD.Batch_Id,D.Department_Id                          
))A group by A.Candidate_Id,A.CandidateName,A.AdharNumber,A.Batch_Code,A.Amountobepaid,A.Department_Name,A.Batch_Id,A.Department_Id)B                           
                          
-- group by B.CandidateName,                          
--B.Candidate_Id,B.AdharNumber,B.Department_Name,B.paid,B.Batch_Code,B.Batch_Id,B.Department_Id                              
--                          
left join                           
                          
                               
(select sum(balance) balance,A.Candidate_Id,A.Batch_Code from(select CPD.Candidate_Id,                          
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                          
CPD.AdharNumber,CBD.Batch_Code,FSD.Amount as Amountobepaid,FSD.ItemDescription,                          
isnull(FEM.Paid,0) as Paid,                          
FSD.Feehead_Id,                          
FSD.Amount -isnull(FEM.Paid,0) as balance,                          
D.Department_Name,FSD.Period_In_Days,convert(varchar(50),dateadd(dd,FSD.Period_In_Days,CBD.Batch_From),103) as duedate,D.Department_Id                          
--,sum(FSD.Amount)-Paid as balance                          
                          
from dbo.Tbl_Candidate_Personal_Det CPD                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                   
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=FSMP.Feecode                          
--inner join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id                          
--inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id                          
--inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id                          
--inner join dbo.Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id                          
                          
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id                          
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.ItemDescription=FSD.ItemDescription                           
and FEM.FeeHeadId=FSD.Feehead_Id and FEM.Amount=FSD.Amount and FEM.typ=''Normal'' and FEM.ActiveStatus is null                           
--inner join Tbl_Fee_Entry FE on FE.Candidate_Id=FSMP.Candidate_Id and FE.FeeHeadId=FSD.Feehead_Id and FE.Amount=FSD.Amount and FE.typ=''Normal''                          
where  convert(datetime,dateadd(dd,FSD.Period_In_Days,CBD.Batch_From),103)<getdate() and FS.Fee_Category<>10 and FS.Fee_Category<>3                        
      
      
group by FSD.Feehead_Id, CPD.Candidate_Id,CPD.Candidate_Fname,CPD.Candidate_Mname,CPD.Candidate_Lname,CPD.AdharNumber                          
,CBD.Batch_Code,FSD.Amount,D.Department_Name,FSD.Period_In_Days,CBD.Batch_From,FSD.ItemDescription,FEM.Paid,D.Department_Id                          
                      
union                      
                      
select distinct CPD.Candidate_Id,                          
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                          
CPD.AdharNumber,CBD.Batch_Code,FSD.Amount as Amountobepaid,FSD.ItemDescription,                          
isnull(FEM.Paid,0) as Paid,                        
FSD.Feehead_Id,                          
FSD.Amount -isnull(FEM.Paid,0) as balance,                          
D.Department_Name,FSD.Period_In_Days,          
          
--commented on 2/06/2017          
--(select convert(varchar(50),PP.Payment_Due_Date,103) from dbo.Tbl_PTPN_Payment PP                       
-- inner join dbo.Tbl_PTPN_Child PC on PC.PTPN_Setting_Id=PP.PTPN_Setting_Id and PC.Batch_Id =  CBD.Batch_Id                      
--and convert(nvarchar(50),PP.Payment_No) in (select item from  SplitString(FSD.ItemDescription,''-'')) )                      
--  as duedate ,          
'''' duedate,          
            
  D.Department_Id                         
--,sum(FSD.Amount)-Paid as balance                     
                          
from dbo.Tbl_Candidate_Personal_Det CPD                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                          
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=FSMP.Feecode                          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id                        
--inner join dbo.Tbl_PTPN_Child PC on PC.Batch_Id =  CBD.Batch_Id                      
--inner join dbo.Tbl_PTPN_Payment PP on PC.PTPN_Setting_Id=PP.PTPN_Setting_Id          
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id                          
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.ItemDescription=FSD.ItemDescription                           
and FEM.FeeHeadId=FSD.Feehead_Id and FEM.Amount=FSD.Amount and FEM.typ=''Normal'' and FEM.ActiveStatus is null                           
--inner join Tbl_Fee_Entry FE on FE.Candidate_Id=FSMP.Candidate_Id and FE.FeeHeadId=FSD.Feehead_Id and FE.Amount=FSD.Amount and FE.typ=''Normal''                          
where   FS.Fee_Category=10  and FSD.ItemDescription like ''PTP%''           
--and                       
--(select PP.Payment_Due_Date from dbo.Tbl_PTPN_Payment PP                       
-- inner join dbo.Tbl_PTPN_Child PC on PC.PTPN_Setting_Id=PP.PTPN_Setting_Id and PC.Batch_Id =  CBD.Batch_Id                      
--and convert(nvarchar(50),PP.Payment_No) in (select item from  SplitString(FSD.ItemDescription,''-'')))<getdate()                      
--group by FSD.Feehead_Id, CPD.Candidate_Id,CPD.Candidate_Fname,CPD.Candidate_Mname,CPD.Candidate_Lname,CPD.AdharNumber                          
--,CBD.Batch_Code,FSD.Amount,D.Department_Name,CBD.Batch_From,FSD.ItemDescription,FEM.Paid,CBD.Batch_Id,D.Department_Id,FSD.Period_In_Days--,PP.Payment_Due_Date,                      
                      
                      
                      
union                       
                      
                      
select CPD.Candidate_Id,                          
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                          
CPD.AdharNumber,CBD.Batch_Code,FSD.Amount as Amountobepaid,FSD.ItemDescription,                          
isnull(FEM.Paid,0) as Paid,                          
FSD.Feehead_Id,                          
FSD.Amount -isnull(FEM.Paid,0) as balance,                          
D.Department_Name,FSD.Period_In_Days,convert(varchar(50),cdp.Duration_Period_To,103) as duedate,D.Department_Id                          
--,sum(FSD.Amount)-Paid as balance                          
                          
from dbo.Tbl_Candidate_Personal_Det CPD                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                          
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=FSMP.Feecode                            
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id                          
inner join dbo.Tbl_Course_Duration_PeriodDetails cdp on cdp.Batch_Id = CBD.Batch_Id                         
                          
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id                  
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.ItemDescription=FSD.ItemDescription                           
and FEM.FeeHeadId=FSD.Feehead_Id and FEM.Amount=FSD.Amount and FEM.typ=''Normal'' and FEM.ActiveStatus is null                           
--inner join Tbl_Fee_Entry FE on FE.Candidate_Id=FSMP.Candidate_Id and FE.FeeHeadId=FSD.Feehead_Id and FE.Amount=FSD.Amount and FE.typ=''Normal''                          
where cdp.Duration_Period_To<getdate() and  FS.Fee_Category=3                       
group by FSD.Feehead_Id, CPD.Candidate_Id,CPD.Candidate_Fname,CPD.Candidate_Mname,CPD.Candidate_Lname,CPD.AdharNumber                          
,CBD.Batch_Code,FSD.Amount,D.Department_Name,FSD.Period_In_Days,CBD.Batch_From,FSD.ItemDescription,FEM.Paid,D.Department_Id,convert(varchar(50),cdp.Duration_Period_To,103)                          
                      
                      
                      
union                      
                      
                         
select CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                          
CPD.AdharNumber,CBD.Batch_Code,--sum(FCD.Amount) as Amountobepaid,                          
FCD.Amount as Amountobepaid,                          
FCD.ItemDescription,                          
isnull(FEM.Paid,0) as Paid,                 
--FE.Paid as Paid,                          
FCD.FeeHeadId,                          
FCD.Amount-isnull(FEM.Paid,0) as balance,                          
D.Department_Name                          
,FCD.PeriodInDays,convert(varchar(50),dateadd(dd,FCD.PeriodInDays,CBD.Batch_From),103) as duedate,D.Department_Id                          
--,sum(FSD.Amount)-Paid as balance                          
                          
from dbo.Tbl_Candidate_Personal_Det CPD                    
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
inner join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id and Student_Semester_Current_Status=1                          
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id                          
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id                          
--inner join dbo.Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id                          
inner join dbo.Tbl_Fee_Compulsory FC on FC.CourseId=D.Department_Id and FC.TypeOfStudent=CPD.TypeOfStudent                          
inner join dbo.Tbl_Fee_CompulsoryDetails FCD on FCD.CumpulsoryFeeId=FC.CompulsoryFeeId                          
--inner join Tbl_Fee_Entry FE on FE.Candidate_Id=CPD.Candidate_Id and FE.FeeHeadId=FCD.FeeHeadId and FE.Amount=FCD.Amount and FE.typ=''Compulsory''                          
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.ItemDescription=FCD.ItemDescription                           
and FEM.FeeHeadId=FCD.FeeHeadId and FEM.Amount=FCD.Amount and FEM.typ=''Compulsory'' and FEM.ActiveStatus is null                           
                          
where convert(datetime,dateadd(dd,FCD.PeriodInDays,CBD.Batch_From),103)<getdate() AND  SS.Student_Semester_Current_Status=1                          
group by CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname,                          
CPD.AdharNumber,CBD.Batch_Code,D.Department_Name,CBD.Batch_Id,FCD.PeriodInDays,CBD.Batch_From,                          
FCD.FeeHeadId,FCD.ItemDescription,FCD.Amount,FEM.Paid,D.Department_Id                          
                          
union                
                
SELECT CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS CandidateName,                
CPD.AdharNumber,CBD.Batch_Code,FEM.Amount,FEM.ItemDescription,ISNULL((FEM.Paid),0) as Paid,                
FEM.FeeHeadId,FEM.Amount-isnull(FEM.Paid,0) as balance,D.Department_Name,                
''0'' as PeriodInDays,convert(varchar(50),FEM.Miscellaneous_due_date,103) as duedate,D.Department_Id                 
--FEM.typ                 
                
from dbo.Tbl_Candidate_Personal_Det CPD                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                          
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                          
inner join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id and Student_Semester_Current_Status=1                          
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id                          
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id                
inner join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.typ=''MISC'' and FEM.ActiveStatus is null                           
                          
where FEM.Miscellaneous_due_date <getdate()  AND  SS.Student_Semester_Current_Status=1                         
group by CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname,                          
CPD.AdharNumber,CBD.Batch_Code,D.Department_Name,CBD.Batch_Id,CBD.Batch_From,                          
FEM.FeeHeadId,FEM.ItemDescription,FEM.Amount,FEM.Paid,D.Department_Id,FEM.Miscellaneous_due_date                          
                       
                     
                     
)A group by A.Candidate_Id,A.Batch_Code                          
                      
                              
)C on B.Candidate_Id=C.Candidate_Id and B.Batch_Code=C.Batch_Code                           
                          
where (B.Department_Id=@Department_Id or @Department_Id=0  )and(B.Batch_Id=@Batch_Id or @Batch_Id=0)                          
group by B.CandidateName,                          
B.Candidate_Id,B.AdharNumber,B.Department_Name,B.paid,isnull(C.balance,0),B.Batch_Code,C.Batch_Code,B.Batch_Id,B.Department_Id                          
order by Candidate_Id                          
                          
                    
end 
    ')
END

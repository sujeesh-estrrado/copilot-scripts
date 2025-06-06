IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[IndividualFeeCollectionReport_demo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
              
CREATE procedure [dbo].[IndividualFeeCollectionReport_demo] --277,11850                   
 @CandidateId bigint,@intake bigint                        
as                 
begin             
            
--select Amount,Candidate_Id,Intake_Id,Feehead_Id,FeeHeadName,Currency,CurrencyCode,            
--CANDIDNAME,Course_Code,Batch_Code,Study_Mode,ItemDesc,Department_Name from(            
               
select  DISTINCT             
            
--tabMain.*                
 tabMain.Amount,tabMain.Candidate_Id,tabMain.ItemDescription,               
tabMain.Intake_Id ,tabMain.Feehead_Id,tabMain.Amount,tabMain.FeeHeadName,                
tabMain.Currency,tabMain.CurrencyCode,                      
tabMain.CANDIDNAME,tabMain.Course_Code,tabMain.Batch_Code,tabMain.Study_Mode,                
tabMain.ItemDesc ,sum(tabSub.Paid) as Paid,        
        
tabMain.Department_Name                
from (              
              
select  A.Candidate_Id ,A.ItemDescription,A.Intake_Id ,A.Feehead_Id, A.FeeHeadName,A.Currency,A.CurrencyCode,A.CANDIDNAME,A.Course_Code,            
A.Department_Name,A.Batch_Code,A.Study_Mode,A.ItemDesc ,            
Amount  from(            
                       
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,C.CurrencyCode,            
CPD.Candidate_Fname+ '' ''+ CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS                      
CANDIDNAME,D.Course_Code,D.Department_Name,''Normal'' typ,fd.ItemDescription,CBD.Batch_Code,CBD.Study_Mode,                
fh1.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode as ItemDesc from TBL_FeeSettingsDetails FD                         
inner join Tbl_Fee_Settings F on F.Fee_Settings_Id=FD.Fee_Settings_Id                    
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                         
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code                  
INNER join  dbo.Tbl_Fee_Entry FM ON  FD.Feehead_Id=FM.FeeHeadId               
INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD                      
ON CPD.Candidate_Id=fc.Candidate_Id                
inner join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                
inner join Tbl_Currency C on C.Currency_Id=fd.Currency                
inner join  Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=fc.Intake_Id                
inner join Tbl_Department D on D.Department_Id=SR.Department_Id                
where fc.Candidate_Id=@CandidateId and fc.Intake_Id=@intake              
              
union                 
                   
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,            
fcomd.CurrencyId Currency,C.CurrencyCode                
,CPD.Candidate_Fname+ '' ''+ CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS                      
CANDIDNAME,D.Course_Code,D.Department_Name,''Compulsory'' typ,fcomd.ItemDescription,CBD.Batch_Code,CBD.Study_Mode,                
fh2.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode as ItemDesc                
 from Tbl_Fee_Compulsory fcom                        
 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                  
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                    
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId                
 inner join  Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FCM.Intake_Id                
 inner join Tbl_Currency C on C.Currency_Id=fcomd.CurrencyId                
 INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD                
ON CPD.Candidate_Id=FCM.Candidate_Id                
inner join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                
inner join Tbl_Department D on D.Department_Id=SR.Department_Id                
where  FCM.Candidate_Id=@CandidateId and FCM.Intake_Id=@intake                 
and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=@CandidateId)               
             
union                
             
select FM.Candidate_Id,FM.IntakeId as Intake_Id,FM.FeeHeadId,FM.Amount,fh3.Fee_Head_Name FeeHeadName,FM.Currency,            
C.CurrencyCode,CPD.Candidate_Fname+ '' ''+ CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS                      
CANDIDNAME,D.Course_Code,D.Department_Name,FM.typ,FM.ItemDescription,CBD.Batch_Code,CBD.Study_Mode,fh3.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode as ItemDesc                
 from Tbl_Fee_Entry_Main FM                
inner join Tbl_Fee_Head fh3 on fh3.Fee_Head_Id=FM.FeeHeadId                
INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FM.Candidate_Id                
inner join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                
inner join  Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FM.IntakeId                
 inner join Tbl_Currency C on C.Currency_Id=FM.Currency                
inner join Tbl_Department D on D.Department_Id=SR.Department_Id where                 
FM.typ=''MISC'' and FM.Candidate_Id=@CandidateId and FM.IntakeId=@intake)            
            
A                
group by A.Amount,A.Candidate_Id ,A.ItemDescription,A.Intake_Id ,A.Feehead_Id, A.FeeHeadName,A.Currency,                
A.CurrencyCode,A.CANDIDNAME,A.Course_Code,A.Batch_Code,A.Study_Mode,A.ItemDesc,A.Department_Name) TabMain                
                
inner join                 
    (            
select distinct FE.FeeHeadId as Feehead_Id ,FE.Amount ,FEM.ItemDescription,                
FH.Fee_Head_Name+''-''+ case PD.Payment_Details_Mode                    
                    
when ''1'' then ''CASH-Payment''                    
when ''2'' then ''CHEQUE-Payment''                    
when ''3'' then ''DD-Payment''                    
when ''7'' then ''RTGS-Payment''                    
end as ItemDesc,Fe.Currency,FE.Paid,FE.[Date],C.CurrencyCode                
,FE.Candidate_Id,FE.IntakeId as Intake_Id                
from Tbl_Fee_Entry FE                
inner join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=FE.FeeHeadId                 
inner join Tbl_Currency C on C.Currency_Id=FE.Currency                 
inner join dbo.Tbl_Payment_Details PD on PD.Payment_Details_Particulars_Id=FE.Feeid                
inner join Tbl_Fee_Entry_Main FEM on FE.Feeid=FEM.Feeid and FE.Amount=FEM.Amount --and FE.ItemDescription=FEM.ItemDescription         
--and FEM.FeeHeadId=FE.FeeHeadId           
--and FEM.Balance=FE.Balance         
where FE.Candidate_Id=@CandidateId                
and FE.IntakeId=@intake )            
            
 tabSub on TabMain.Candidate_Id=tabSub.Candidate_Id                
and  TabMain.FeeHead_id=tabSub.FeeHead_id           
group by tabMain.Amount,tabMain.Candidate_Id,tabMain.ItemDescription,                
tabMain.Intake_Id,tabMain.Feehead_Id,tabMain.Amount,tabMain.FeeHeadName,                
tabMain.Currency,tabMain.CurrencyCode,                      
tabMain.CANDIDNAME,tabMain.Course_Code,tabMain.Batch_Code,tabMain.Study_Mode,                
tabSub.Paid,tabMain.ItemDesc,tabMain.Department_Name                
                
--    )TableFinal group by             
--    Amount,Candidate_Id,Intake_Id,Feehead_Id,FeeHeadName,Currency,CurrencyCode,            
--CANDIDNAME,Course_Code,Batch_Code,Study_Mode,ItemDesc,Department_Name            
 end
    ')
END

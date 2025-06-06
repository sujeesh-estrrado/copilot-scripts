-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Indidvidual_Fee_ByStudent_Main]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Indidvidual_Fee_ByStudent_Main] --327,11829                  
(@candidateId bigint,                
@intake bigint,
@Feehead_Id bigint )                
as                
begin                
select distinct tabSub.* ,tabSub.Paid as Paid1,tabSub.Date as Date1, tabMain.Amount from (select A.Candidate_Id ,A.Intake_Id ,A.Feehead_Id, A.FeeHeadName,A.Currency,        
A.CurrencyCode,A.CANDIDNAME,A.Course_Code,A.Batch_Code,A.Study_Mode,A.ItemDesc,ISNULL (A.Discount,0) AS Discount,        
ISNULL (A.Refund,0) as Refund,sum(Amount) Amount from(                   
            
select fc.Candidate_Id,fc.Intake_Id ,fd.Feehead_Id,fd.Amount,fh1.Fee_Head_Name FeeHeadName,fd.Currency,C.CurrencyCode,CPD.Candidate_Fname+ '' ''+ CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS                      
CANDIDNAME,D.Course_Code,''Normal'' typ,fd.ItemDescription,FM.Discount,FM.Refund,CBD.Batch_Code,CBD.Study_Mode,               
fh1.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode as ItemDesc from TBL_FeeSettingsDetails FD                         
inner join Tbl_Fee_Settings F on F.Fee_Settings_Id=FD.Fee_Settings_Id           
INNER join  dbo.Tbl_Fee_Entry FM ON  FD.Feehead_Id=FM.FeeHeadId               
inner join Tbl_Fee_Head fh1 on fh1.Fee_Head_Id=fd.Feehead_Id                         
inner join Tbl_FeecodeStudentMap FC on fc.Feecode=f.Scheme_Code                  
INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD                      
ON CPD.Candidate_Id=fc.Candidate_Id                
inner join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                
inner join Tbl_Currency C on C.Currency_Id=fd.Currency                
inner join  Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=fc.Intake_Id                
inner join Tbl_Department D on D.Department_Id=SR.Department_Id                
where fc.Candidate_Id=@candidateId and fd.Feehead_Id IS NOT NULL AND fc.Intake_Id=@intake and fd.Feehead_Id=@Feehead_Id                 
union              
          
                    
          
select FCM.Candidate_Id,FCM.Intake_Id,fcomd.FeeHeadId Feehead_Id,fcomd.Amount,fh2.Fee_Head_Name FeeHeadName,        
fcomd.CurrencyId Currency,C.CurrencyCode                
,CPD.Candidate_Fname+ '' ''+ CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS                      
CANDIDNAME,D.Course_Code,''Compulsory'' typ,fcomd.ItemDescription,ISNULL (FM.Discount,0) AS Discount,ISNULL (FM.Refund,0) as Refund,        
CBD.Batch_Code,CBD.Study_Mode,          
fh2.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode as ItemDesc                
 from Tbl_Fee_Compulsory fcom                        
 inner join Tbl_Fee_CompulsoryDetails fcomd on fcom.CompulsoryFeeId=fcomd.CumpulsoryFeeId                  
 inner join Tbl_Fee_Head fh2 on fh2.Fee_Head_Id=fcomd.FeeHeadId                    
 inner join Tbl_FeecodeStudentMap FCM on FCM.Course_Id=fcom.CourseId                
 inner join  Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FCM.Intake_Id                
 inner join Tbl_Currency C on C.Currency_Id=fcomd.CurrencyId                
 INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD                
ON CPD.Candidate_Id=FCM.Candidate_Id            
inner join dbo.Tbl_Fee_Entry FM ON FM.Candidate_Id =CPD.Candidate_Id          
inner join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                
inner join Tbl_Department D on D.Department_Id=SR.Department_Id           
                
where  FCM.Candidate_Id=@candidateId and fcomd.FeeheadId IS NOT NULL AND FCM.Intake_Id=@intake  and fcomd.FeeHeadId=@Feehead_Id                
and  fcom.TypeOfStudent=(select TypeOfStudent from Tbl_Candidate_Personal_Det cp where cp.Candidate_Id=@candidateId)                
union                
          
           
select FM.Candidate_Id,FM.IntakeId as Intake_Id,FM.FeeHeadId,FM.Amount,fh3.Fee_Head_Name FeeHeadName,FM.Currency,C.CurrencyCode,CPD.Candidate_Fname+ '' ''+ CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS                      
CANDIDNAME,D.Course_Code,FM.typ,FM.ItemDescription,ISNULL (FE.Discount,0) AS Discount,ISNULL (FE.Refund,0) as Refund,CBD.Batch_Code,CBD.Study_Mode,  ----------              
fh3.Fee_Head_Name+''-''+D.Course_Code+''-''+CBD.Batch_Code+''-''+CBD.Study_Mode as ItemDesc          
 from Tbl_Fee_Entry_Main FM            
  -----------------          
inner join Tbl_Fee_Head fh3 on fh3.Fee_Head_Id=FM.FeeHeadId                
INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FM.Candidate_Id                
inner join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                
inner join  Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FM.IntakeId              
 inner join Tbl_Currency C on C.Currency_Id=FM.Currency                
inner join Tbl_Department D on D.Department_Id=SR.Department_Id           
INNER JOIN  dbo.Tbl_Fee_Entry FE ON  fe.Fee_Entry_Id=FM.Fee_Entry_Id where                 
FM.typ=''MISC'' and FM.Candidate_Id=@candidateId and FM.FeeHeadId IS NOT NULL AND FM.IntakeId=@intake and FM.FeeHeadId=@Feehead_Id )A                
group by A.Candidate_Id ,A.Intake_Id ,A.Feehead_Id, A.FeeHeadName,A.Currency,                
A.CurrencyCode,A.CANDIDNAME,A.Course_Code,A.Batch_Code,A.Study_Mode,A.ItemDesc,A.Discount,A.Refund) TabMain              
                
inner join (                
                
select distinct             
FE.FeeHeadId as Feehead_Id ,            
FE.Amount,            
FEM.ItemDescription,          
ISNULL (FE.Discount,0) AS Discount,ISNULL (FE.Refund,0) as Refund, ----------               
FH.Fee_Head_Name+''-''+ case PD.Payment_Details_Mode                    
                    
when ''1'' then ''CASH-Payment''                    
when ''2'' then ''CHEQUE-Payment''                    
when ''3'' then ''DD-Payment''                    
when ''7'' then ''RTGS-Payment''                    
end as ItemDesc,Fe.Currency,isnull(FE.Paid,0)as Paid,FE.[Date],C.CurrencyCode                
,FE.Candidate_Id,FE.IntakeId as Intake_Id                
from Tbl_Fee_Entry FE      -----          
left join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=FE.FeeHeadId                 
left join Tbl_Currency C on C.Currency_Id=FE.Currency                 
left join dbo.Tbl_Payment_Details PD on PD.Payment_Details_Particulars_Id=FE.Feeid                
left join Tbl_Fee_Entry_Main FEM on FE.Feeid=FEM.Feeid and FE.Amount=FEM.Amount  -------------------              
where FE.Candidate_Id=@candidateId AND FE.FeeHeadId IS NOT NULL              
and FE.IntakeId=@intake and  FE.FeeHeadId=@Feehead_Id )  tabSub on TabMain.Candidate_Id=tabSub.Candidate_Id                
and  TabMain.FeeHead_id=tabSub.FeeHead_id   and tabSub.Date is not null            
end  
    ')
END;
GO

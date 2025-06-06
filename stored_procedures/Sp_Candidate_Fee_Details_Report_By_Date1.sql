IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Candidate_Fee_Details_Report_By_Date1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                        
CREATE procedure [dbo].[Sp_Candidate_Fee_Details_Report_By_Date1] --''01-03-2017'' , ''05-07-2017''                                          
(@FromDate datetime,@ToDate datetime)                                          
                                          
AS                                          
BEGIN             
       if(@FromDate=@ToDate)            
  begin        
--declare @From varchar(max)            
--declare @To varchar(max)            
--set @From=convert(varchar(50),@FromDate,103)            
--set @To=convert(varchar(50),@ToDate,103)            
            
select                                            
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                        
cpd.AdharNumber ,convert(varchar(50),fe.Date,103) as Date,fh.Fee_Head_Name,                                                                        
D.Course_Code+''-''+cbd.Batch_Code as Batch ,                                                       
fe.MOP,fe.Feeid,fe.Remarks ,fe.ReceiptNo                 
,fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,fe.Amount-sum(fe.Paid) as  Balance                                                                              
from dbo.Tbl_Fee_Entry  fe                                          
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                           
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                           
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=fe.Candidate_Id                                           
inner join  Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=fe.IntakeId                                          
inner join dbo.Tbl_Department as d on d.Department_Id =SR.Department_Id                                           
--inner join dbo.Tbl_Payment_Details  pd on pd.Payment_Details_Particulars_Id=fe.Feeid and                                           
--pd.Payment_Details_Particulars=''FEES''                              
where --convert(varchar(50),fe.Date,103) >= @From and convert(varchar(50),fe.Date,103)<=@To  
  
 datepart(mm,fe.Date)=datepart(mm,@FromDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@FromDate) and datepart(dd,fe.Date)=datepart(dd,@FromDate)                  
                   
  and datepart(mm,fe.Date)=datepart(mm,@ToDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@ToDate) and datepart(dd,fe.Date)=datepart(dd,@ToDate)       
  
           
and fe.Paid<>0--and fe.TagDescription is null or fe.TagDescription=''Transfer In''              
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP ,  
 fe.Feeid,fe.TagDescription,fe.Remarks,fe.ReceiptNo,Amount,Itemdesc                      
union                                           
select                                             
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103)as Date,fh.Fee_Head_Name,                         
                                         
--(select sum(Amount) from dbo.Tbl_Fee_Entry where Feeid=fed.Fee_Entry_Details_Id) as AmounttobePaid,                                          
--(select distinct Payment_Details_Amount from dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'')as AmountPaid,                                        
--(select Remarks from  dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'') as Remarks,                                 
D.Course_Code+''-''+cbd.Batch_Code as Batch ,                                    
--case(PD. Payment_Details_Mode)                                        
--when ''1'' then''CASH''                                        
--when ''2'' then ''CHEQUE''                                        
--when ''3'' then ''CREDIT CARD''                                        
--WHEN ''4'' THEN ''EMGS''                                        
--when ''5'' then ''PTPTN Direct Debit''                                        
--when ''6'' then ''SALARY DEDUCTION''                                        
--when ''7'' then ''TELEGRAPHIC TRANSFER''                            
--when ''8'' then ''TRANSFER''                                      
--  END AS MOP ,                  
fe.MOP,fe.Feeid,fe.Remarks  ,fe.ReceiptNo                  
--,pd.Temporary_ReceiptNo                  
,fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,fe.Amount-sum(fe.Paid) as  Balance                                        
                                          
                                          
from dbo.Tbl_Fee_Entry  fe                                       
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                           
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                     
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                           
inner join dbo.tbl_New_Admission NA on NA.New_Admission_Id=cpd.New_Admission_Id                                          
inner join Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                          
inner join dbo.Tbl_Department as d on d.Department_Id =NA.Department_Id                                           
--inner join dbo.Tbl_Payment_Details  pd on pd.Payment_Details_Particulars_Id=fe.Feeid and                                           
--pd.Payment_Details_Particulars=''FEES''                                                  
where         
        
 datepart(mm,fe.Date)=datepart(mm,@FromDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@FromDate) and datepart(dd,fe.Date)=datepart(dd,@FromDate)                  
                   
  and datepart(mm,fe.Date)=datepart(mm,@ToDate) and                  
 datepart(yyyy,fe.Date)=datepart(yyyy,@ToDate) and datepart(dd,fe.Date)=datepart(dd,@ToDate)           
 --convert(varchar(50),fe.Date,103) >= @From and convert(varchar(50),fe.Date,103)<=@To           
and fe.Paid<>0--and fe.TagDescription is null or fe.TagDescription=''Transfer In''                              
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP ,  
 fe.Feeid,fe.Remarks,                  
fe.TagDescription,fe.ReceiptNo,Amount,Itemdesc                                        
  
end  
else  
begin  
          
select                                            
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                        
cpd.AdharNumber ,convert(varchar(50),fe.Date,103) as Date,fh.Fee_Head_Name,                                        
                                          
--(select sum(Amount) from dbo.Tbl_Fee_Entry where Feeid=fed.Fee_Entry_Details_Id) as AmounttobePaid,                                          
--(select distinct Payment_Details_Amount from dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'')as AmountPaid,                                          
--(select Remarks from  dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'') as Remarks,                                        
D.Course_Code+''-''+cbd.Batch_Code as Batch ,                                        
--case(PD. Payment_Details_Mode)                                        
--when ''1'' then''CASH''                                        
--when ''2'' then ''CHEQUE''                                        
--when ''3'' then ''CREDIT CARD''                                        
--WHEN ''4'' THEN ''EMGS''                                        
--when ''5'' then ''PTPTN Direct Debit''                                        
--when ''6'' then ''SALARY DEDUCTION''                                        
--when ''7'' then ''TELEGRAPHIC TRANSFER''                             
--when ''8'' then ''TRANSFER''                          
--                                     
--  END AS MOP,                  
fe.MOP,fe.Feeid,fe.Remarks ,fe.ReceiptNo                 
--,pd.Temporary_ReceiptNo                  
,fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,fe.Amount-sum(fe.Paid) as  Balance                                      
--PD.Payment_Details_Amount as AmountPaid                                        
                                          
from dbo.Tbl_Fee_Entry  fe                                          
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                           
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                           
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=fe.Candidate_Id                                           
inner join  Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=fe.IntakeId                                          
inner join dbo.Tbl_Department as d on d.Department_Id =SR.Department_Id                                           
--inner join dbo.Tbl_Payment_Details  pd on pd.Payment_Details_Particulars_Id=fe.Feeid and                                           
--pd.Payment_Details_Particulars=''FEES''                              
where --convert(varchar(50),fe.Date,103) >= @From and convert(varchar(50),fe.Date,103)<=@To  
fe.Date between @FromDate and @ToDate      
  
           
and fe.Paid<>0--and fe.TagDescription is null or fe.TagDescription=''Transfer In''              
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP ,  
 fe.Feeid,fe.TagDescription,fe.Remarks,fe.ReceiptNo,Amount,Itemdesc                      
union                                           
select                                             
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103)as Date,fh.Fee_Head_Name,                         
                                         
--(select sum(Amount) from dbo.Tbl_Fee_Entry where Feeid=fed.Fee_Entry_Details_Id) as AmounttobePaid,                                          
--(select distinct Payment_Details_Amount from dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'')as AmountPaid,                                        
--(select Remarks from  dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'') as Remarks,                                 
D.Course_Code+''-''+cbd.Batch_Code as Batch ,                                    
--case(PD. Payment_Details_Mode)                                        
--when ''1'' then''CASH''                                        
--when ''2'' then ''CHEQUE''                                        
--when ''3'' then ''CREDIT CARD''                                        
--WHEN ''4'' THEN ''EMGS''                                        
--when ''5'' then ''PTPTN Direct Debit''                                        
--when ''6'' then ''SALARY DEDUCTION''                                        
--when ''7'' then ''TELEGRAPHIC TRANSFER''                            
--when ''8'' then ''TRANSFER''                                      
--  END AS MOP ,                  
fe.MOP,fe.Feeid,fe.Remarks  ,fe.ReceiptNo                  
--,pd.Temporary_ReceiptNo                  
,fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,fe.Amount-sum(fe.Paid) as  Balance                                        
                                          
                                          
from dbo.Tbl_Fee_Entry  fe                                       
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                           
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                     
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                           
inner join dbo.tbl_New_Admission NA on NA.New_Admission_Id=cpd.New_Admission_Id                                          
inner join Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                          
inner join dbo.Tbl_Department as d on d.Department_Id =NA.Department_Id                                           
--inner join dbo.Tbl_Payment_Details  pd on pd.Payment_Details_Particulars_Id=fe.Feeid and                                           
--pd.Payment_Details_Particulars=''FEES''                                                  
where         
 fe.Date between @FromDate and @ToDate          
 --convert(varchar(50),fe.Date,103) >= @From and convert(varchar(50),fe.Date,103)<=@To           
and fe.Paid<>0--and fe.TagDescription is null or fe.TagDescription=''Transfer In''                              
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP ,  
 fe.Feeid,fe.Remarks,                  
--pd.Temporary_ReceiptNo,                  
fe.TagDescription,fe.ReceiptNo,Amount,Itemdesc   
  
union   
     
select                                            
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                        
cpd.AdharNumber ,convert(varchar(50),fe.Date,103) as Date,fh.Fee_Head_Name,                                        
                                          
--(select sum(Amount) from dbo.Tbl_Fee_Entry where Feeid=fed.Fee_Entry_Details_Id) as AmounttobePaid,                                          
--(select distinct Payment_Details_Amount from dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'')as AmountPaid,                                          
--(select Remarks from  dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'') as Remarks,                                        
D.Course_Code+''-''+cbd.Batch_Code as Batch ,                                        
--case(PD. Payment_Details_Mode)                                        
--when ''1'' then''CASH''                                        
--when ''2'' then ''CHEQUE''                                        
--when ''3'' then ''CREDIT CARD''                                        
--WHEN ''4'' THEN ''EMGS''                                        
--when ''5'' then ''PTPTN Direct Debit''                                        
--when ''6'' then ''SALARY DEDUCTION''                                        
--when ''7'' then ''TELEGRAPHIC TRANSFER''                             
--when ''8'' then ''TRANSFER''                          
--                                     
--  END AS MOP,                  
fe.MOP,fe.Feeid,fe.Remarks ,fe.ReceiptNo                 
--,pd.Temporary_ReceiptNo                  
,fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,fe.Amount-sum(fe.Paid) as  Balance                                      
--PD.Payment_Details_Amount as AmountPaid                                        
                                          
from dbo.Tbl_Fee_Entry  fe                                          
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                           
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                           
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                           
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=fe.Candidate_Id                                           
inner join  Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=fe.IntakeId                                          
inner join dbo.Tbl_Department as d on d.Department_Id =SR.Department_Id                                           
--inner join dbo.Tbl_Payment_Details  pd on pd.Payment_Details_Particulars_Id=fe.Feeid and                                           
--pd.Payment_Details_Particulars=''FEES''                              
 --convert(varchar(50),fe.Date,103) >= @From and convert(varchar(50),fe.Date,103)<=@To  
             
WHERE datepart(yyyy,fe.Date)=datepart(yyyy,@ToDate) and datepart(dd,fe.Date)=datepart(dd,@ToDate)            
and datepart(mm,fe.Date)=datepart(mm,@ToDate)     
  
           
and fe.Paid<>0--and fe.TagDescription is null or fe.TagDescription=''Transfer In''              
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP   
 ,fe.Feeid,fe.TagDescription,fe.Remarks,fe.ReceiptNo,Amount,Itemdesc                        
union                                           
select                                             
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103)as Date,fh.Fee_Head_Name,                         
                                         
--(select sum(Amount) from dbo.Tbl_Fee_Entry where Feeid=fed.Fee_Entry_Details_Id) as AmounttobePaid,                                          
--(select distinct Payment_Details_Amount from dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'')as AmountPaid,                                        
--(select Remarks from  dbo.Tbl_Payment_Details where Payment_Details_Particulars_Id= fe.Feeid and                                           
--Payment_Details_Particulars=''FEES'') as Remarks,                                 
D.Course_Code+''-''+cbd.Batch_Code as Batch ,                                    
--case(PD. Payment_Details_Mode)                                        
--when ''1'' then''CASH''                                        
--when ''2'' then ''CHEQUE''                                        
--when ''3'' then ''CREDIT CARD''                                        
--WHEN ''4'' THEN ''EMGS''                                        
--when ''5'' then ''PTPTN Direct Debit''                                        
--when ''6'' then ''SALARY DEDUCTION''                                        
--when ''7'' then ''TELEGRAPHIC TRANSFER''                            
--when ''8'' then ''TRANSFER''                                      
--  END AS MOP ,                  
fe.MOP,fe.Feeid,fe.Remarks  ,fe.ReceiptNo                  
--,pd.Temporary_ReceiptNo                  
,fe.TagDescription,fe.Itemdesc,fe.Amount as Amounttobepaid,sum(fe.Paid) as AmountPaid,fe.Amount-sum(fe.Paid) as  Balance                                        
                                          
                                          
from dbo.Tbl_Fee_Entry  fe                                       
--inner join dbo.Tbl_Fee_Entry_Details  fed on fed.Fee_Entry_Details_Id=fe.Feeid                                           
inner join  dbo.Tbl_Candidate_Personal_Det  cpd on  cpd.Candidate_Id=fe.Candidate_Id                                     
inner join dbo.Tbl_Fee_Head  fh on fh.Fee_Head_Id=fe.FeeHeadId                                           
inner join dbo.tbl_New_Admission NA on NA.New_Admission_Id=cpd.New_Admission_Id                                          
inner join Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                          
inner join dbo.Tbl_Department as d on d.Department_Id =NA.Department_Id                                           
--inner join dbo.Tbl_Payment_Details  pd on pd.Payment_Details_Particulars_Id=fe.Feeid and                                           
--pd.Payment_Details_Particulars=''FEES''                                                  
        
 WHERE datepart(yyyy,fe.Date)=datepart(yyyy,@ToDate) and datepart(dd,fe.Date)=datepart(dd,@ToDate)                  
and datepart(mm,fe.Date)=datepart(mm,@ToDate)           
 --convert(varchar(50),fe.Date,103) >= @From and convert(varchar(50),fe.Date,103)<=@To           
and fe.Paid<>0--and fe.TagDescription is null or fe.TagDescription=''Transfer In''                              
group by cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname,                                          
 cpd.AdharNumber ,convert(varchar(50),fe.Date,103),fh.Fee_Head_Name,D.Course_Code+''-''+cbd.Batch_Code,fe.MOP ,  
 fe.Feeid,fe.Remarks,                  
--pd.Temporary_ReceiptNo,                  
fe.TagDescription,fe.ReceiptNo,Amount,Itemdesc   
  
end                       
END 

    ')
END

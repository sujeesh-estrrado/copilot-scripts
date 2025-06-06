IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[IndividualFeeCollectionReport_new1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[IndividualFeeCollectionReport_new1]-- 9,14    
           
  @CandidateId bigint,@intake bigint                          
as                    
begin           
           
select distinct FE.Amount,FE.Candidate_Id,FE.IntakeId as Intake_Id,FE.FeeHeadId as Feehead_Id ,FE.Amount AS AMT2,          
 FH.Fee_Head_Name FeeHeadName,          
 Fe.Currency,          
 C.CurrencyCode,FE.ItemDesc,          
 CPD.Candidate_Fname+ '' ''+ CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS    CANDIDNAME,          
D.Course_Code,TBD.Batch_Code,TBD.Study_Mode,          
FE.ItemDesc,0 as Paid,          
--FE.[Date]             
D.Department_Name               
,FE.Amount           
                  
from Tbl_Fee_Entry_Main FEM inner join          
Tbl_Fee_Entry FE on     FE.FeeHeadId=FEM.FeeHeadId  and FEM.ItemDescription=FE.ItemDesc and FE.Paid is not null          
and FE.Candidate_Id=FEM.Candidate_Id and FE.IntakeId=FEM.IntakeId                 
inner join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=FE.FeeHeadId                   
inner join Tbl_Currency C on C.Currency_Id=FE.Currency                   
--inner join dbo.Tbl_Payment_Details PD on PD.Payment_Details_Particulars_Id=FE.Feeid           
inner join Tbl_Course_Batch_Duration TBD on TBD.BATCH_ID=FE.IntakeId          
INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FEM.Candidate_Id          
inner join Tbl_Student_Registration SR on SR.Candidate_Id=FEM.Candidate_Id                  
       inner join Tbl_Department D on D.Department_Id=SR.Department_Id          
--inner join Tbl_Fee_Entry_Main FEM on FE.Feeid=FEM.Feeid and FE.Amount=FEM.Amount                  
               
where FE.Candidate_Id=@CandidateId                  
and FE.IntakeId=@intake           
          
END 
    ')
END

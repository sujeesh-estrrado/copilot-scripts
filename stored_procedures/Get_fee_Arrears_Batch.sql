
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_fee_Arrears_Batch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  
CREATE procedure [dbo].[Get_fee_Arrears_Batch]  
  
@IntakeId bigint  
as  
begin      
      
      
select distinct a.Batch_Id,A.BatchSemester,A.Batch_Code,SUM(A.Amountobepaid) as Amountobepaid,      
SUM(A.Paid) as paid,      
--isnull(sum(A.Amountobepaid)-A.paid,0) as Balance,                                            
SUM(A.balance) as dueamount from      
      
(      
select distinct CPD.Candidate_Id,                                
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                                
CPD.AdharNumber,CBD.Batch_Code,FSD.Amount as Amountobepaid,FSD.ItemDescription,                                
isnull(FEM.Paid,0) as Paid,D.Course_Code,                                
FSD.Feehead_Id,                                
FSD.Amount -isnull(FEM.Paid,0) as balance,CBD.Batch_Id,                                
D.Department_Name,D.Course_Code+''-''+CBD.Batch_Code+''-''+ CS.Semester_Code as BatchSemester ,convert(varchar(50),CBD.Batch_From,103) as Batch_From,      
FSD.Period_In_Days,convert(varchar(50),dateadd(dd,FSD.Period_In_Days,CBD.Batch_From),103) as duedate,      
D.Department_Id                                
--,sum(FSD.Amount)-Paid as balance                                
                                
from dbo.Tbl_Candidate_Personal_Det CPD                                 
inner join dbo.Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id                                
inner join  dbo.Tbl_Department D on SR.Department_Id=D.Department_Id                                
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                         
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=FSMP.Feecode                                
inner join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id                                
--inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id                                
--inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                                
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id                                
--inner join dbo.Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id                                
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id           
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                                   
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id        
                                
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id                                
left join dbo.Tbl_Fee_Entry_Main FEM on FEM.Candidate_Id=CPD.Candidate_Id and FEM.ItemDescription=FSD.ItemDescription                                 
and FEM.FeeHeadId=FSD.Feehead_Id and FEM.Amount=FSD.Amount  and FEM.ActiveStatus is null                                 
--inner join Tbl_Fee_Entry FE on FE.Candidate_Id=FSMP.Candidate_Id and FE.FeeHeadId=FSD.Feehead_Id and FE.Amount=FSD.Amount and FE.typ=''Normal''                                
where  convert(datetime,dateadd(dd,FSD.Period_In_Days,CBD.Batch_From),103)<getdate()      
and  FEM.IntakeId=@IntakeId      
       
group by FSD.Feehead_Id, CPD.Candidate_Id,CPD.Candidate_Fname,      
CPD.Candidate_Mname,CPD.Candidate_Lname,CPD.AdharNumber                                
,CBD.Batch_Code,FSD.Amount,D.Department_Name,FSD.Period_In_Days,CBD.Batch_From,      
FSD.ItemDescription,FEM.Paid,D.Department_Id,CS.Semester_Code,cdm.Duration_Mapping_Id,CBD.Batch_Id,D.Course_Code      
      
)       
      
A group by      
A.Batch_Id,A.BatchSemester,A.Batch_Code  
end
    ')
END;
GO

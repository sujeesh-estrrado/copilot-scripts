IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GET_REFUND_APPROVAL_DETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[GET_REFUND_APPROVAL_DETAILS]--''''ARUN Z''''         
          
(@Username varchar(50))          
          
          
as begin     
  
select distinct tabSub.* ,tabMain.Paid  as Paid,tabMain.Amount from         
    
(select A.Candidate_Id ,A.CandidateName ,A.Feecode, A.Course_Code,A.Batch_Code,                            
A.Fee_Head_Name,A.FeeHeadId,A.ItemDesc,A.RefundAmount,A.Amount,A.Paid,A.Balance  from(                                       
                       
          
select DA.Candidate_Id,CPD.Candidate_Fname+''''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,          
FSMP.Feecode,D.Course_Code,CBD.Batch_Code,FH.Fee_Head_Name,DA.FeeHeadId,          
DA.ItemDesc,DA.RefundAmount,FM.Amount,FM.Paid,FM.Balance          
 from dbo.Tbl_Refund_Approval DA          
inner join  dbo.Tbl_Approval_Hierarchy AH on AH.AuthorityUserId=DA.AuthorityUserId          
inner join dbo.Tbl_Candidate_Personal_Det CPD  on DA.Candidate_Id=CPD.Candidate_Id          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id          
inner join dbo.Tbl_Department D  on D.Department_Id=FSMP.Course_Id          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id          
inner join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=DA.FeeHeadId          
inner join dbo.Tbl_Fee_Entry_Main FM on FM.Candidate_Id=DA.Candidate_Id and          
FM.ActiveStatus is null and FM.ItemDescription=DA.ItemDesc          
where AH.Name=@Username and DA.Status=0 and DA.PriorityStatus=1 and FM.Paid<>0         
and DA.FinalStatus<>2          
       -- union  
)A                                    
) TabMain        
    
right join (  
  
select DA.Candidate_Id,CPD.Candidate_Fname+''''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,          
FSMP.Feecode,D.Course_Code,CBD.Batch_Code,FH.Fee_Head_Name,DA.FeeHeadId,          
DA.ItemDesc,DA.RefundAmount,FSD.Amount,isnull(FM.Paid,0) as Paid,isnull(FM.Balance,FSD.Amount)  as Balance          
 from dbo.Tbl_Refund_Approval DA          
inner join  dbo.Tbl_Approval_Hierarchy AH on AH.AuthorityUserId=DA.AuthorityUserId          
inner join dbo.Tbl_Candidate_Personal_Det CPD  on DA.Candidate_Id=CPD.Candidate_Id          
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id          
inner join dbo.Tbl_Department D  on D.Department_Id=FSMP.Course_Id          
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id          
inner join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=DA.FeeHeadId          
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=FSMP.Feecode          
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id and FSD.ItemDescription=DA.ItemDesc          
inner join dbo.Tbl_Fee_Entry_Main FM on FM.Candidate_Id=DA.Candidate_Id and          
FM.ActiveStatus is null and FM.ItemDescription=DA.ItemDesc          
where AH.Name=@Username and DA.Status=0 and DA.PriorityStatus=1        
and DA.FinalStatus<>2          
)tabSub on tabMain.Candidate_Id=tabSub.Candidate_Id                                    
  
end 
    ')
END

IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_WAIVE_FINE]')
    AND type = N'P'
)
BEGIN
    EXEC('
              
  create procedure [dbo].[SP_GET_WAIVE_FINE] --159,''tuition'',3          
          
(@Candidate_Id bigint,@ItemDesc varchar(100),              
@FeeHead bigint)--,@AuthorityUserId bigint)            
AS          
BEGIN          
          
          
          
          
select DA.WaiveAmount,DA.FineAmount              
 from dbo.Tbl_Fine_Approval DA                  
inner join  dbo.Tbl_Approval_Hierarchy AH on AH.AuthorityUserId=DA.AuthorityUserId                  
inner join dbo.Tbl_Candidate_Personal_Det CPD  on DA.Candidate_Id=CPD.Candidate_Id                  
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                  
inner join dbo.Tbl_Department D  on D.Department_Id=FSMP.Course_Id                  
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id                  
inner join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=DA.FeeHeadId                  
inner join dbo.Tbl_Fee_Entry_Main FM on FM.Candidate_Id=DA.Candidate_Id and                  
FM.ActiveStatus is null and FM.ItemDescription=DA.ItemDesc                  
where DA.Candidate_Id=@Candidate_Id and DA.ItemDesc=@ItemDesc and DA.FeeHeadId =@FeeHead and FinalStatus=1  
-- and PaidStatus=0        
          
        UNION          
select DA.WaiveAmount,DA.FineAmount              
--isnull(FM.Paid,0) as Paid,isnull(FM.Balance,FSD.Amount)  as Balance                 
 from dbo.Tbl_Fine_Approval DA                  
inner join  dbo.Tbl_Approval_Hierarchy AH on AH.AuthorityUserId=DA.AuthorityUserId                  
inner join dbo.Tbl_Candidate_Personal_Det CPD  on DA.Candidate_Id=CPD.Candidate_Id                  
inner join dbo.Tbl_FeecodeStudentMap FSMP on FSMP.Candidate_Id=CPD.Candidate_Id                  
inner join dbo.Tbl_Department D  on D.Department_Id=FSMP.Course_Id                  
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=FSMP.Intake_Id                  
inner join dbo.Tbl_Fee_Head FH on FH.Fee_Head_Id=DA.FeeHeadId                  
inner join dbo.Tbl_Fee_Settings FS on FS.Scheme_Code=FSMP.Feecode                  
inner join dbo.TBL_FeeSettingsDetails FSD on FSD.Fee_Settings_Id=FS.Fee_Settings_Id and   
FSD.ItemDescription=DA.ItemDesc                  
where DA.Candidate_Id=@Candidate_Id and DA.ItemDesc=@ItemDesc and DA.FeeHeadId =@FeeHead and FinalStatus=1  
-- and PaidStatus=0          
          
          
end




    ')
END
GO

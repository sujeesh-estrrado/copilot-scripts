IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CommissionReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Get_CommissionReport]-- 6,2
    -- Add the parameters for the stored procedure here
    
    @Employee_Id bigint,
    @Status bigint
AS
BEGIN
if(@Status=1)
begin
    select distinct [Commission_Setting_Id],[Candidate_Fname]+'' ''+[Candidate_Mname]+'' ''+[Candidate_Lname] As
 

Student_name,AdharNumber as ICorPasssport,[Tbl_Fee_Entry_Main].Paid as AmountFeesPaid,[Commission_Amount],
Tbl_Commission_Settings.Remarks
from Tbl_Commission_Settings
inner join [dbo].[Tbl_Candidate_Personal_Det] on Tbl_Commission_Settings.Employee_Id=[Tbl_Candidate_Personal_Det].[CounselorEmployee_id]
inner join Tbl_Employee on Tbl_Employee.Employee_Id=[Tbl_Candidate_Personal_Det].[CounselorEmployee_id]
inner join [dbo].[Tbl_Fee_Settings] on [dbo].[Tbl_Commission_Settings].fee_code_id=[dbo].[Tbl_Fee_Settings].[Fee_Settings_Id] 
inner join [Tbl_Fee_Entry_Main] on [Tbl_Fee_Entry_Main].Candidate_Id=[Tbl_Candidate_Personal_Det].[Candidate_Id]
and Tbl_Fee_Entry_Main.Commision_Settings_Id=Tbl_Commission_Settings.[Commission_Setting_Id]
inner join [dbo].[Tbl_Fee_Head] on [Tbl_Commission_Settings].Feehead_Id=[dbo].[Tbl_Fee_Head].Fee_Head_Id
        and [Tbl_Commission_Settings].[ItemDescription]=[Tbl_Fee_Entry_Main].ItemDescription

--inner join Tbl_Department on [Tbl_Commission_Settings].IntakeId=Tbl_Department.Department_ID


inner join [Tbl_FeecodeStudentMap] on [Tbl_Commission_Settings].IntakeId=[Tbl_FeecodeStudentMap].Intake_Id
inner join Tbl_Course_Batch_Duration on [Tbl_FeecodeStudentMap].Intake_Id=Tbl_Course_Batch_Duration.Batch_Id
inner join [Tbl_Candidate_ContactDetails] on [Tbl_Candidate_Personal_Det].Candidate_Id=[Tbl_Candidate_ContactDetails].Candidate_Id
 and   [Tbl_Commission_Settings].ItemDescription=[Tbl_Fee_Entry_Main].ItemDescription 
where  [Tbl_Fee_Entry_Main].balance<=0 and Tbl_Commission_Settings.Employee_Id=@Employee_Id
 
end
else
begin
select distinct [Commission_Setting_Id],[Candidate_Fname]+'' ''+[Candidate_Mname]+'' ''+[Candidate_Lname] As Student_name,AdharNumber as ICorPasssport,[Tbl_Fee_Entry_Main].Paid as AmountFeesPaid,[Commission_Amount],
Tbl_Commission_Settings.Remarks
from Tbl_Commission_Settings
inner join [dbo].[Tbl_Candidate_Personal_Det] on Tbl_Commission_Settings.[Agent_ID]=[Tbl_Candidate_Personal_Det].[Agent_ID]
inner join [dbo].[Tbl_Agent] on [dbo].[Tbl_Agent].[Agent_ID]=Tbl_Candidate_Personal_Det.[Agent_ID]
inner join [dbo].[Tbl_Fee_Settings] on [dbo].[Tbl_Commission_Settings].fee_code_id=[dbo].[Tbl_Fee_Settings].[Fee_Settings_Id] 
inner join [Tbl_Fee_Entry_Main] on [Tbl_Fee_Entry_Main].Candidate_Id=[Tbl_Candidate_Personal_Det].[Candidate_Id]
and Tbl_Fee_Entry_Main.Commision_Settings_Id=Tbl_Commission_Settings.[Commission_Setting_Id]
inner join [dbo].[Tbl_Fee_Head] on [Tbl_Commission_Settings].Feehead_Id=[dbo].[Tbl_Fee_Head].Fee_Head_Id 
      and [Tbl_Commission_Settings].[ItemDescription]=[Tbl_Fee_Entry_Main].ItemDescription

--inner join Tbl_Department on [Tbl_Commission_Settings].IntakeId=Tbl_Department.Department_ID



inner join [Tbl_FeecodeStudentMap] on [Tbl_Commission_Settings].IntakeId=[Tbl_FeecodeStudentMap].Intake_Id
inner join Tbl_Course_Batch_Duration on [Tbl_FeecodeStudentMap].Intake_Id=Tbl_Course_Batch_Duration.Batch_Id
inner join [Tbl_Candidate_ContactDetails] on [Tbl_Candidate_Personal_Det].Candidate_Id=[Tbl_Candidate_ContactDetails].Candidate_Id
and [Tbl_Commission_Settings].ItemDescription=[Tbl_Fee_Entry_Main].ItemDescription 
where [Tbl_Fee_Entry_Main].balance<=0 and Tbl_Commission_Settings.Agent_ID=@Employee_Id 
end
END
    ');
END;

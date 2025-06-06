IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_All_EventStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Get_All_EventStatus]-- 3,1

@Event_Id bigint,
@flag bigint=0

as

begin
 if(@flag=0)
 Begin
 select CONCAT(E.Employee_FName,'' '',E.Employee_LName)as EmployeeName,convert(varchar, EL.Action_Date, 105) as ApproveDate,Status,Remark  
 from Tbl_Event_StatusLog EL 
 left join Tbl_Employee E on E.Employee_Id=EL.Employee_Id where EL.Event_Id=@Event_Id
 end
  if(@flag=1)
 Begin
select Count(*) as Counts from Tbl_Candidate_Personal_Det where  Event_Id=@Event_Id
 end
  if(@flag=2)
 Begin
select * FROM Tbl_Budget_Approvals WHERE MarketingManagerApproval=1 and Event_Id=@Event_Id
 end
end
    ')
END

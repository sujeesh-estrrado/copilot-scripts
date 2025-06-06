IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_PaymentDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Get_All_PaymentDetails]-- 3,1  
@flag bigint=0,  
@Event_Id bigint=0  
  
as  
  
begin  
  
if(@flag=0)  
Begin  


 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,Ed.TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,International_or_Local as location,  
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Sales,  
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed''and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Activation,  
 (select Count(*) from Tbl_Candidate_Personal_Det where CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Total_Enquiry,  
 convert(varchar, BP.DateOfSubmit, 105) as DateOfSubmit,(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as TeamName,BP.ApprovedBudget,BP.TotalExpense,BP.Paid,BP.BalanceToPay  
from Tbl_BudgetPayment BP   
left join Tbl_Event_Details ED on ED.Event_Id=BP.Event_Id  
left join Tbl_Employee E on E.Employee_Id=ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader  where BP.BalanceToPay!=0
  
end  
  
if(@flag=1)  
Begin  
 select distinct ED.Event_Id,ED.Inside_Outside,ED.TargetedStudent,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,Ed.TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,International_or_Local as location,  
(select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending'' and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Sales,  
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed''  
  and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Activation,  
(select Count(*) from Tbl_Candidate_Personal_Det where  CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Total_Enquiry,  
convert(varchar, BP.DateOfSubmit, 105) as DateOfSubmit,(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as TeamName,BP.ApprovedBudget,BP.TotalExpense,BP.Paid,BP.BalanceToPay,ED.EventLeader  
from  Tbl_Event_Details ED   
left join Tbl_BudgetPayment BP  on BP.Event_Id=ED.Event_Id  
left join Tbl_Employee E on E.Employee_Id=ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where BP.Event_Id=@Event_Id  
  
end  
if(@flag=2)  
Begin  
 select distinct ED.Event_Id,ED.Inside_Outside,ED.TargetedStudent,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,Ed.TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,International_or_Local as location,  
(select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Sales,  
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed''  
  and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Activation,Bp.Edit_Req,  
(select Count(*) from Tbl_Candidate_Personal_Det where  CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Total_Enquiry,  
convert(varchar, BP.DateOfSubmit, 105) as DateOfSubmit,(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as TeamName,BP.ApprovedBudget,BP.TotalExpense,BP.Paid,BP.BalanceToPay,ED.EventLeader  
from  Tbl_Event_Details ED   
left join Tbl_BudgetPayment BP  on BP.Event_Id=ED.Event_Id  
left join Tbl_Employee E on E.Employee_Id=ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where BP.Event_Id=@Event_Id and Bp.Edit_Req=0  
  
end  
if(@flag=3)  
Begin  
   
 select * from  Tbl_BudgetPayment Where Event_Id=@Event_Id  
  
  
end  
if(@flag=4)  
Begin  
 select distinct ED.Event_Id,ED.Inside_Outside,ED.TargetedStudent,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,Ed.TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,International_or_Local as location,  
(select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending'' and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Sales,  
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed''  
  and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Activation,  
(select Count(*) from Tbl_Candidate_Personal_Det where  CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Total_Enquiry,  
convert(varchar, BP.DateOfSubmit, 105) as DateOfSubmit,(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as TeamName,BP.ApprovedBudget,BP.TotalExpense,BP.Paid,BP.BalanceToPay,ED.EventLeader  
from  Tbl_Event_Details ED   
left join Tbl_BudgetPayment BP  on BP.Event_Id=ED.Event_Id  
left join Tbl_Employee E on E.Employee_Id=ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where Bp.Edit_Req=1  
  
end  
  
  if(@flag=5)  
Begin  


 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,Ed.TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,International_or_Local as location,  
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Sales,  
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed''and CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Conversion_to_Activation,  
 (select Count(*) from Tbl_Candidate_Personal_Det where CounselorEmployee_id=ED.EventLeader and Event_Id=ED.Event_id)as Total_Enquiry,  
 convert(varchar, BP.DateOfSubmit, 105) as DateOfSubmit,(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as TeamName,BP.ApprovedBudget,BP.TotalExpense,BP.Paid,BP.BalanceToPay  
from Tbl_BudgetPayment BP   
left join Tbl_Event_Details ED on ED.Event_Id=BP.Event_Id  
left join Tbl_Employee E on E.Employee_Id=ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader 
where BalanceToPay=0
  
end  
  
end  

    ');
END

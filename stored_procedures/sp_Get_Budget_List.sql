IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Budget_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Get_Budget_List]-- 3,1  
@flag bigint=0  
  
as  
  
begin  
  
if(@flag=0)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,''-NA-'' As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.MarketingManagerApproval=0  
  
  
end  
if(@flag=1)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,BA.MarketingManagerApproval_Remark As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.MarketingManagerApproval=1 And BA.PsoApproval=0  
  
  
end  
if(@flag=2)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,BA.PsoApproval_Remark As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.PsoApproval=1 and  BA.DirectorApproval=0  
  
  
end  
if(@flag=3)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,BA.DirectorApproval_Remark As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.DirectorApproval=3 And BA.MD_Approval=0  
  
  
end  
if(@flag=4)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,''-NA-'' As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.MarketingManagerApproval=2 or BA.PsoApproval=2 or BA.DirectorApproval=2 or BA.MD_Approval=2  
  
select * from Tbl_Budget_Approvals  
end  
if(@flag=5)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,BA.MarketingManagerApproval_Remark As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.PsoApproval=2 or BA.DirectorApproval=2 or BA.MD_Approval=2  
  
  
end  
  
if(@flag=6)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,BA.PsoApproval_Remark As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.DirectorApproval=2 or BA.MD_Approval=2  
  
  
end  
if(@flag=7)  
Begin  
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,  
convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,  
''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status ,BA.DirectorApproval_Remark As Approval_Remark,  
(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name  
from Tbl_Event_Details ED  
left join tbl_Employee E on E.Employee_Id= ED.EventLeader  
left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader   
left join Tbl_Budget_Approvals BA on BA.Event_Id=ED.Event_Id where BA.MD_Approval=2  
  
  
end  
  
  
end
    ');
END

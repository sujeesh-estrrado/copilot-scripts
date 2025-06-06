IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Event_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Event_List] --23,0,1445 3,1        
@flag bigint=0,        
@Event_Id bigint=0,        
@Employee_Id bigint=0,    
@Searchkey Varchar(50)='''',    
@CurrentPage int=null,        
@pagesize bigint null    
as        
        
begin        
        
 if(@flag=0)        
 Begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,        
  (case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent        
  ,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
     convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,        
  (case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
     (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending'' and Event_Id=ED.Event_id)as Conversion_to_Sales,        
     (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
             
     convert(varchar, ED.CreatedDate, 105) as CreatedDate,        
     (case when DA.Approval_Status=1 then ''Approved By Director'' when BA.Approval_Status=1 then ''Approved by MD'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or         
  BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status,T.Team_Name        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Teams T On T.Team_Id=ED.Team_Id  where ED.Del_Status=0     
 and (MA.Approval_Status<>2)    
 and (PA.Approval_Status<>2)    
 and (DA.Approval_Status!=2 or BA.Approval_Status!=2) and ED.EventLeader=@Employee_Id     
 and ((ED.EventName like  ''%''+ @Searchkey +''%'')         
    or (Agent like  ''%''+ @Searchkey +''%'')          
    or(concat(Employee_FName,'' '',Employee_LName) like ''%''+ @Searchkey +''%'' )        
    or (Ed.TypeOfEvent like ''%''+ @Searchkey +''%'' )         
    or(International_or_Local like ''%''+ @Searchkey +''%'' )        
    or (T.Team_Name like ''%''+ @Searchkey +''%'' )          
       
    or @Searchkey='''')    
  order by EventName        
  OFFSET @PageSize * (@CurrentPage - 1) ROWS        
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);       
 end        
         
 if(@flag=1)        
 begin        
        
 select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent        
 ,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,''-NA-'' as Conversion_to_Sales,        
 ''-NA-'' as Total_Enquiry,convert(varchar, ED.CreatedDate, 105) as CreatedDate,''-NA-'' as Status, (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where MA.Approval_Status=0        
 end        
        
 if(@flag=2)        
 begin        
        
 select distinct *,concat(Employee_FName,'' '',Employee_LName) As EventLead,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Times,CONVERT(VARCHAR(10),  ED.Start_Date, 21)  AS Start_Date,        
 CONVERT(VARCHAR(10),  ED.End_Date, 21)  AS End_Date,ED.International_or_Local,(Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where ED.Event_id=@Event_Id        
        
 end        
 if(@flag=3)        
 begin        
        
 select * from  Tbl_Particulars_Detailss where Del_status=0 and Event_id=@Event_Id        
        
 end        
 if(@flag=4)        
 begin        
        
 select * from  Tbl_Marketing_ManangerApproval MM left join Tbl_Pso_Approval  PA on PA.Event_Id=MM.Event_Id where (MM.Approval_Status=2 or PA.Approval_Status=2) and MM.Event_id=@Event_Id        
        
 end        
 if(@flag=5)        
 begin        
        
        
 delete from Tbl_Particulars_Detailss where Event_ID=@Event_Id        
        
 end        
        
 if(@flag=6)        
 begin        
 Select ES.EventID,ES.OtherStaff,concat(E.Employee_FName,'' '',E.Employee_LName)As Employee_Name from  Tbl_Event_Staff ES        
 left join Tbl_Employee E on E.Employee_Id=ES.OtherStaff where EventID=@Event_Id        
         
        
        
 end        
 if(@flag=7)        
 begin        
 delete from  Tbl_Event_Staff where EventID=@Event_Id        
        
        
 end        
 if(@flag=8)        
 begin        
 Update Tbl_Marketing_ManangerApproval set Approval_Status=0 where Event_id=@Event_Id        
 Update Tbl_Pso_Approval set Approval_Status=0 where Event_id=@Event_Id        
        
        
 end        
 if(@flag=9)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or BA
  
    
      
        
        
        
.        
 Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, MA.Approval_Remark As ApprovalRemark,ED.EventVennu,ED.BoothNo,ED.BoothCount        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where MA.Approval_Status=1 and PA.Approval_Status=0 and DA.Approval_Status=0        
        
 end        
 if(@flag=10)        
 begin     
 select  * from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id where MA.Approval_Status=0  and ED.Event_Id=@Event_Id        
        
 end        
 if(@flag=11)        
 begin         
 select  distinct ED.Event_Id,ED.EventName,ED.EventLeader as Employee_Id,ED.International_or_Local,concat(Employee_FName,'' '',Employee_LName) As EventLead  from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id where  ED.Event_Id=@Event_Id        
        
 end        
 if(@flag=12)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or   
 BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, PA.Approval_Remark As ApprovalRemark        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where MA.Approval_Status=1 and PA.Approval_Status=1 and DA.Approval_Status=0        
        
 end        
        
 if(@flag=13)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or BA.        
 Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, DA.Approval_Remark As ApprovalRemark        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader  where MA.Approval_Status=1 and PA.Approval_Status=1 and DA.Approval_Status=3 and BA.Approval_Status=0        
 end        
 if(@flag=14)        
 begin        
 select * from  Tbl_MD_Approval where Event_ID=@Event_Id        
 end        
 if(@flag=15)        
 begin        
        
 select * from  Tbl_Budget_Approvals  where (MarketingManagerApproval=2 or PsoApproval=2 or DirectorApproval=2 or MD_Approval=2) and Event_id=@Event_Id        
        
 end        
 if(@flag=16)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or   
  
    
     
  BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, MA.Approval_Remark As ApprovalRemark        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader        
        
   where ED.Del_Status=0 and  MA.Approval_Status=0        
 end        
 if(@flag=17)        
 begin         
 select  * from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id where (DA.Approval_Status=1 or BA.Approval_Status=1 or  MA.Approval_Status=1)  and ED.Event_Id=@Event_Id and ED.EventLeader=@Employee_Id        
        
 end        
 if(@flag=18)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or BA
  
    
      
        
        
        
.        
 Approval_Status=2 then ''Reject''  else ''Pending'' end) as status,ED.Inside_Outside,         
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 MA.Approval_Remark As ApprovalRemark,C.Country,S.State_Name,CC.City_Name,ED.ExpiredDate,ED.EventVennu,ED.BoothNo,ED.BoothCount,ED.TargetedStudent        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader        
 left join Tbl_Country C on C.Country_Id=ED.Country        
 left join [[Tbl_State]]] S on S.State_Id=ED.State        
 left join Tbl_City CC on CC.City_Id=ED.City where ED.Event_Id=@Event_Id         
        
 end        
 if(@flag=19)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or BA
  
.        
 Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, MA.Approval_Remark As ApprovalRemark        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader        
        
   where MA.Approval_Status=2 or PA.Approval_Status=2 or DA.Approval_Status=2 or BA.Approval_Status=2        
 end        
 if(@flag=20)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or   
 BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, MA.Approval_Remark As ApprovalRemark        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where PA.Approval_Status=2 or DA.Approval_Status=2 or BA.Approval_Status=2        
        
 end        
 if(@flag=21)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or BA
  
    
      
        
        
        
.        
 Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, MA.Approval_Remark As ApprovalRemark        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader where DA.Approval_Status=2 or BA.Approval_Status=2        
        
 end        
 if(@flag=22)        
 begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
  convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
  (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
  (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
  (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
  convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2     
 
     
  or BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, DA.Approval_Remark As ApprovalRemark        
  from Tbl_Event_Details ED        
  left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
  left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
  left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
  left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
  left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
  left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
  left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
  left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader  where  BA.Approval_Status=2        
 end        
 if(@flag=23)        
 begin        
  select T.Team_Id from Tbl_Counsellor_Teamforming CT        
  left join Tbl_Teams T on T.Team_Id=CT.Team_Id where (CT.TeamMembers=@Employee_Id or CT.TeamLead=@Employee_Id) And CT.DelStatus=0        
 end        
 if(@flag=24)        
 begin        
  select * from Tbl_BudgetPayment where Event_Id=@Event_Id        
 end        
 if(@flag=25)        
 Begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,        
  (case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent        
  ,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
     convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,        
  (case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
     (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
     (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
             
     convert(varchar, ED.CreatedDate, 105) as CreatedDate,        
     (case when DA.Approval_Status=1 then ''Approved By Director'' when BA.Approval_Status=1 then ''Approved by MD'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or         
  BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status,T.Team_Name        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Teams T On T.Team_Id=ED.Team_Id  where  (PA.Approval_Status=2 or  MA.Approval_Status=2 or DA.Approval_Status=2 or BA.Approval_Status=2) and ED.EventLeader=@Employee_Id        
   and ((ED.EventName like  ''%''+ @Searchkey +''%'')         
    or (Agent like  ''%''+ @Searchkey +''%'')          
    or(concat(Employee_FName,'' '',Employee_LName) like ''%''+ @Searchkey +''%'' )        
    or (Ed.TypeOfEvent like ''%''+ @Searchkey +''%'' )         
    or(International_or_Local like ''%''+ @Searchkey +''%'' )        
    or (T.Team_Name like ''%''+ @Searchkey +''%'' )          
       
    or @Searchkey='''')    
  order by EventName        
  OFFSET @PageSize * (@CurrentPage - 1) ROWS        
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
     
 end        
        
  if(@flag=26)        
 Begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,        
  (case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent        
  ,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
     convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,        
  (case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
     (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending'' and Event_Id=ED.Event_id)as Conversion_to_Sales,        
     (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
             
     convert(varchar, ED.CreatedDate, 105) as CreatedDate,        
     (case when DA.Approval_Status=1 then ''Approved By Director'' when BA.Approval_Status=1 then ''Approved by MD'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or         
  BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status,T.Team_Name        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Teams T On T.Team_Id=ED.Team_Id  where ED.Del_Status=0 and (DA.Approval_Status=1 or BA.Approval_Status=1)        
 end      
     
  if(@flag=27)        
 begin        
  select distinct  T.Team_Id,T.Team_Name  from  Tbl_Teams T    
  left join Tbl_Counsellor_Teamforming CT on T.Team_Id=CT.Team_Id where CT.DelStatus=0  
 end    
         
    if(@flag=28)        
 Begin        
  select distinct ED.Event_Id,ED.EventName,ED.Agent,concat(Employee_FName,'' '',Employee_LName) As EventLead,        
  (case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent        
  ,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
     convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,        
  (case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
     (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending'' and Event_Id=ED.Event_id)as Conversion_to_Sales,        
     (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
             
     convert(varchar, ED.CreatedDate, 105) as CreatedDate,        
     (case when DA.Approval_Status=1 then ''Approved By Director'' when BA.Approval_Status=1 then ''Approved by MD'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or         
  BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status,T.Team_Name,ED.EventVennu,ED.BoothNo,ED.BoothCount       
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join tbl_Employee E on E.Employee_Id= ED.EventLeader        
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Teams T On T.Team_Id=ED.Team_Id  where ED.Del_Status=0 and (DA.Approval_Status=1 or BA.Approval_Status=1)    
      
 end      
 if(@flag=29)        
 Begin        
 select distinct ED.EventLeader, ED.Event_Id,ED.EventName,ED.Agent,UPPER(r.role_Name) As EventLead,--concat(Employee_FName,'' '',Employee_LName) As EventLead,  r.      
  (case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent        
  ,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
     convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,        
  (case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
     (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending'' and Event_Id=ED.Event_id)as Conversion_to_Sales,        
     (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
             
     convert(varchar, ED.CreatedDate, 105) as CreatedDate,        
     (case when DA.Approval_Status=1 then ''Approved By Director'' when BA.Approval_Status=1 then ''Approved by MD'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or         
  BA.Approval_Status=2 then ''Reject''  else ''Pending'' end) as status,T.Team_Name        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join Tbl_User E on E.user_Id= ED.EventLeader      
 left join tbl_Role r on r.role_Id= e.role_Id
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Teams T On T.Team_Id=ED.Team_Id  where ED.Del_Status=0     
 and (MA.Approval_Status<>2)    
 and (PA.Approval_Status<>2)    
 --and (DA.Approval_Status!=2 or BA.Approval_Status!=2) 
 and ED.EventLeader=@Employee_Id     and BA.Approval_Status=0 
 and ((ED.EventName like  ''%''+ @Searchkey +''%'')         
    or (Agent like  ''%''+ @Searchkey +''%'')          
    or(r.role_Name like ''%''+ @Searchkey +''%'' )        
    or (Ed.TypeOfEvent like ''%''+ @Searchkey +''%'' )         
    or(International_or_Local like ''%''+ @Searchkey +''%'' )        
    or (T.Team_Name like ''%''+ @Searchkey +''%'' )          
       
    or @Searchkey='''')    
  order by EventName        
  OFFSET @PageSize * (@CurrentPage - 1) ROWS        
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);       
 end        
    
  if(@flag=30)        
 Begin        
 select distinct ED.Event_Id,ED.EventName,ED.Agent,UPPER(r.role_Name) As EventLead,(case when  Ed.TypeOfEvent=''--Select--'' then ''-NA-'' else Ed.TypeOfEvent end) TypeOfEvent,convert(varchar, Ed.Start_Date, 105) as Start_Date,        
 convert(varchar,Ed.End_Date, 105) as End_Date,FORMAT(CAST(ED.Time AS DATETIME),''hh:mm tt'') as Time,(case when International_or_Local=''--Select--'' then ''-NA-'' else International_or_Local end) as location,        
 (select Count(*) from Tbl_Candidate_Personal_Det where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' and ApplicationStatus!=''Pending''  and Event_Id=ED.Event_id)as Conversion_to_Sales,        
 (select Count(*) from Tbl_Candidate_Personal_Det where Event_Id=ED.Event_id)as Total_Enquiry,        
 (Select Team_Name from Tbl_Teams where Team_Id=ED.Team_Id ) as Team_Name,        
 convert(varchar, ED.CreatedDate, 105) as CreatedDate,(case when DA.Approval_Status=1 or BA.Approval_Status=1 then ''Approved'' when MA.Approval_Status=2 or PA.Approval_Status=2  then ''You Event Has Been Rejected. Re-Submit '' when DA.Approval_Status=2 or BA.        
 Approval_Status=2 then ''Reject''  else ''Pending'' end) as status, DA.Approval_Remark As ApprovalRemark        
 from Tbl_Event_Details ED        
 left join Tbl_Particulars_Detailss PD on ED.Event_Id=PD.Event_ID        
 left join Tbl_Event_Staff ES on PD.Event_ID=ES.EventID        
 left join Tbl_User E on E.user_Id= ED.EventLeader      
 left join tbl_Role r on r.role_Id= e.role_Id     
 left join Tbl_Pso_Approval PA on PA.Event_ID=ED.Event_Id        
 left join Tbl_Marketing_ManangerApproval MA on MA.Marketing_ManagerApproval_ID=ED.MarketingMangerApproval_ID        
 left join Tbl_Director_Approvals DA on DA.Event_ID=ED.Event_Id        
 left join Tbl_MD_Approval BA on BA.Event_ID=ED.Event_Id        
 left join Tbl_Counsellor_Teamforming CT on CT.TeamMembers=ED.EventLeader  where   ED.EventLeader=1       and BA.Approval_Status=0
 --and ((ED.EventName like  ''%''+ @Searchkey +''%'')         
 --   or (Agent like  ''%''+ @Searchkey +''%'')          
 --   or(r.role_Name like ''%''+ @Searchkey +''%'' )        
 --   or (Ed.TypeOfEvent like ''%''+ @Searchkey +''%'' )         
 --   or(International_or_Local like ''%''+ @Searchkey +''%'' )        
 --  -- or (T.Team_Name like ''%''+ @Searchkey +''%'' )          
       
 --   or @Searchkey='''')    
 -- order by EventName        
 -- OFFSET @PageSize * (@CurrentPage - 1) ROWS        
 -- FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);       
 end        
    
        
        
end 
    ')
END

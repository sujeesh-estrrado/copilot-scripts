IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_CounselorTeams]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE pROCEDURE [dbo].[SP_Insert_CounselorTeams] --'''',1441,'''',5
    @TeamName varchar(100)='''',
    @TeamLead_id bigint='''',
    @Employee_Id bigint='''',
    @Team_Id bigint='''',
    @flag bigint=0
AS
BEGIN
if(@flag=0)
begin
if NOT Exists(select * from Tbl_Counsellor_Teamforming where TeamMembers=@Employee_Id and DelStatus=0)
    insert into Tbl_Counsellor_Teamforming (Team_Id,TeamName,TeamLead,TeamMembers,DelStatus)values
    (@Team_Id,@TeamName,@TeamLead_id,@Employee_Id,0)
end
if(@flag=1)
begin
select TeamMembers from Tbl_Counsellor_Teamforming where TeamLead=@TeamLead_id and DelStatus=0
end
if(@flag=2)
begin
select Distinct TeamName,concat(Employee_FName,'' '',Employee_LName) as LeadName,TeamLead,T.Team_Id from Tbl_Counsellor_Teamforming CT 
left join Tbl_Employee E on E.Employee_Id=CT.TeamLead
left join Tbl_Teams T on T.Team_Id=CT.Team_Id where DelStatus=0
end 
if(@flag=3)
begin
update Tbl_Counsellor_Teamforming set DelStatus=1 where TeamLead=@TeamLead_id
end
if(@flag=4)
begin
select TeamName,TeamLead,TeamMembers from Tbl_Counsellor_Teamforming where TeamLead=@TeamLead_id and DelStatus=0
end
if(@flag=5)
begin
 select  TeamName,concat(E.Employee_FName,'' '',E.Employee_LName) as TeamMemberName,CT.TeamMembers,CT.TeamLead,
 concat(EM.Employee_FName,'' '',EM.Employee_LName) as LeadName,TeamMembers from Tbl_Counsellor_Teamforming CT 
 left join Tbl_Employee E on E.Employee_Id=CT.TeamMembers
 left join Tbl_Employee EM on EM.Employee_Id=CT.TeamLead where DelStatus=0 and (TeamLead=@TeamLead_id )


end
if(@flag=10)
begin
 select  TeamName,concat(E.Employee_FName,'' '',E.Employee_LName) as TeamMemberName,CT.TeamMembers,CT.TeamLead,
 concat(EM.Employee_FName,'' '',EM.Employee_LName) as LeadName,TeamMembers from Tbl_Counsellor_Teamforming CT 
 left join Tbl_Employee E on E.Employee_Id=CT.TeamMembers
 left join Tbl_Employee EM on EM.Employee_Id=CT.TeamLead where DelStatus=0 --and (TeamLead=@TeamLead_id or @Team_Id=0) and ct.TeamMembers<>0
 union select 
 '''' TeamName,concat(E.Employee_FName,'' '',E.Employee_LName) as TeamMemberName,E.Employee_Id TeamMembers,0 TeamLead,
 '''' as LeadName,'''' TeamMembers 
 from Tbl_Employee E left join tbl_employee_user EU on EU.Employee_Id = E.employee_id
 left join tbl_user u on u.user_id = Eu.user_id where u.role_id=14

end
if(@flag=6)
begin
delete from  Tbl_Counsellor_Teamforming  where TeamLead=@TeamLead_id 

end
if(@flag=7)
begin


  select count(CT.TeamMembers) as counts from Tbl_Counsellor_Teamforming CT 
 left join Tbl_Employee E on E.Employee_Id=CT.TeamMembers
 left join Tbl_Employee EM on EM.Employee_Id=CT.TeamLead where DelStatus=0 and TeamLead=@TeamLead_id
end
if(@flag=8)
begin
 select  count(CT.TeamMembers) as counts from Tbl_Counsellor_Teamforming CT 
 left join Tbl_Employee E on E.Employee_Id=CT.TeamMembers
 left join Tbl_Employee EM on EM.Employee_Id=CT.TeamLead where DelStatus=0 and TeamLead=@TeamLead_id


end



END');
END;

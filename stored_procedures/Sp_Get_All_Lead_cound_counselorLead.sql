IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Lead_cound_counselorLead]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Sp_Get_All_Lead_cound_counselorLead] --3,3
(@id bigint,@emp_id bigint)

as
begin

  if(@id=1)
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where 
     ApplicationStatus=''Preactivated'' and (counselorEmployee_id=@emp_id or @emp_id=0)) m
     
    -- union all
     
    --select Candidate_Id from Tbl_Student_NewApplication where 
    --(ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved'' or ApplicationStatus=''rejected''
    --or ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Preactivated'')) m
  end
  else if(@id=2)---Total enquiey
  begin
    
      
  select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where (ApplicationStatus=''approved'' ) 
    and (counselorEmployee_id=@emp_id or @emp_id=0))s
    --union all

    --select Candidate_Id from Tbl_Student_NewApplication where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' ) 
    --and counselorEmployee_id=@emp_id)s

  end
  else if(@id=3) --Verified count
  begin



  select count(*) from (SELECT CPD.Candidate_Id FROM dbo.Tbl_Candidate_Personal_Det AS CPD where (CounselorEmployee_id=@emp_id or @emp_id =0)
    and ( CPD.ApplicationStatus=''Verified''  ) and CPD.Candidate_DelStatus=0 )h
  --union all
  
  --  SELECT Candidate_Id FROM dbo.Tbl_Student_NewApplication  where (CounselorEmployee_id=@emp_id)
 --   and (ApplicationStatus=''approved'' or ApplicationStatus=''Verified''  
 --   or  ApplicationStatus=''Conditional_Admission'' or  ApplicationStatus=''Preactivated'') and Candidate_DelStatus=0)h


  end
  else if(@id=4)
  begin
    
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'' and (CounselorEmployee_id=@emp_id or @emp_id=0))t 
    --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=5)--Approved candidate Count
  begin
    select count (*) from(select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Approved'' and  (CounselorEmployee_id=@emp_id or @emp_id=0)) l
    --union all 
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Approved'' and CounselorEmployee_id=@emp_id) l
  end
  else if(@id=6) 
  begin
    select count(*) from Tbl_Lead_Personal_Det where  ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'' and  (CounselorEmployee_id=@emp_id or @emp_id=0)
    --union all
    --select Candidate_Id from Tbl_Candidate_Personal_Det where counselorEmployee_id=@emp_id)m
  end
  else if(@id=7)--Total paid candidate Count
  begin
    select count(distinct Candidate_Id)as paidcount from Tbl_Lead_Personal_Det D 
 where ApplicationStatus=''rejected'' and (CounselorEmployee_id=@emp_id or @emp_id=0)
 
  
  end
  else if(@id=8)--On Hold candidate Count
  begin
  SELECT COUNT(DISTINCT CPD.Candidate_Id) AS StudentCount
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing m ON m.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id  
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id    
LEFT JOIN (
  SELECT Candidate_Id, Next_Date, Respond_Type
  FROM Tbl_FollowUpLead_Detail
  WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
      SELECT MAX(Follow_Up_Detail_Id)
      FROM Tbl_FollowUpLead_Detail
      WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
      GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
WHERE  
 CPD.ApplicationStatus = ''Lead'' AND m.status = ''Hold'' AND
 (CPD.CounselorEmployee_id=@emp_id or @emp_id=0)
--    select Count(distinct M.Candidate_Id) as holdcount from Tbl_LeadStatus_Change_by_Marketing M
--left join Tbl_Lead_Personal_Det D on M.Candidate_Id=D.candidate_Id
--where  (CounselorEmployee_id=@emp_id or @emp_id=0) and M.status=''Hold''
  end
  else if(@id=9)--Pending Followups candidate Count
  begin
    
--    select count(Distinct F.Candidate_Id) as Followcount from Tbl_FollowUp_Detail F 
--Left join Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.candidate_Id
--left join tbl_employee e on e.employee_id =F.counselor_employee
--where FORMAT(Next_Date, ''yyyy-MM-dd'')>=FORMAT(GetDate(), ''yyyy-MM-dd'') and e.employee_status=0 and (CounselorEmployee_id=@emp_id or @emp_id = 0) and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'')
  
  select count(Distinct cpd.Candidate_Id) as Followcount from tbl_Lead_personal_det cpd 
  left  join Tbl_FollowUpLead_Detail f on f.candidate_id = cpd.candidate_id
  where (f.Next_Date is null or f.Next_Date<=  convert(date,getdate())) and (cpd.ApplicationStatus=''Lead'') and (cpd.counseloremployee_id=@emp_id or @emp_id=0 or cpd.counseloremployee_id=0)end
  else if(@id=10)--rejected candidate Count
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''rejected'' and  (CounselorEmployee_id=@emp_id or @emp_id=0))k 
  --union all
  --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''rejected'' and  CounselorEmployee_id=@emp_id)k
  end
  else if(@id=11)--New candidate Count
  begin
  with level1 as(
select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'') and
CounselorEmployee_id=@emp_id)-
(select count(distinct CandidateID) from Tbl_EnquiryAttendence
inner join Tbl_Candidate_Personal_Det on CandidateID=Candidate_Id
where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'') and (CouncellorID = @emp_id or @emp_id=0) and CandidateID!=0 ) as count)
select case when count>0 then count else 0 end as counts from level1

  
  --select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@emp_id)- (select count(distinct CandidateID) from Tbl_EnquiryAttendence where CouncellorID = @emp_id and CandidateID!=0 );
  end
  else if(@id=12)--Approved candidate Count for admission
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Approved'')e
  --union all
  --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Approved'')e
  end
  else if(@id=13) --verified count admission
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' 
    or ApplicationCategory=''Preactivated'')g
    --union all
  --  select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'')g

  end
  else if(@id=14)
begin
  select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'')r
  --union all
  --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'')r
end

else if(@id=15)--Total paid candidate Count
  begin
    select count(distinct Candidate_Id)as paidcount from Tbl_Candidate_Personal_Det D left join student_bill b on D.Candidate_Id=b.studentid
 where ( ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved'' or 
 ApplicationStatus=''rejected'' or ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission''
 or ApplicationStatus=''Preactivated'' or ApplicationStatus=''Completed'')  
 and (ApplicationStage=''Submit without payment'' or ApplicationStage=''Submited with payment'')
  and billgroupid  in  
(select billgroupid from student_transaction where semesterno = -1 and outstandingbalance>0 
and studentid=Candidate_Id and billcancel = 0)
  
  end

  else if(@id=16)--On Hold candidate Count
  begin
    select Count(distinct M.Candidate_Id) as holdcount from Tbl_Status_change_by_Marketing M
left join Tbl_Candidate_Personal_Det D on M.Candidate_Id=D.candidate_Id
where   M.status=''Hold''
  end

  else if(@id=17)--Pending Followups candidate Count
  begin
    select count(Distinct F.Candidate_Id) as Followcount from Tbl_FollowUp_Detail F 
Left join Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.candidate_Id
where FORMAT(Next_Date, ''yyyy-MM-dd'')>=FORMAT(GetDate(), ''yyyy-MM-dd'')  and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'')
  end
  else if(@id=18)
  begin
    
    select count(Candidate_Id) from Tbl_Lead_Personal_Det where (CounselorEmployee_id='''' or CounselorEmployee_id=0) and Moved_id is Null and ApplicationStatus=''Lead''
    --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=19)
  begin
    
    select count(*) from Tbl_Lead_Personal_Det where  ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'' and  (Agent_ID=@emp_id or @emp_id=0)
    --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=20)
  begin
    
    select count(Candidate_Id) from Tbl_Lead_Personal_Det where (Agent_ID='''' or Agent_ID=0) and Moved_id is Null and ApplicationStatus=''Lead''
    --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=21)
  begin
    
select count(distinct Candidate_Id)as paidcount from Tbl_Lead_Personal_Det D 
 where ApplicationStatus=''rejected'' and (Agent_ID=@emp_id or @emp_id=0)   --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=22)
  begin
    
select Count(distinct M.Candidate_Id) as holdcount from Tbl_LeadStatus_Change_by_Marketing M
left join Tbl_Lead_Personal_Det D on M.Candidate_Id=D.candidate_Id
where  (Agent_ID=@emp_id or @emp_id=0) and M.status=''Hold''  --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=23)
  begin
    
select count(Distinct cpd.Candidate_Id) as Followcount from tbl_Lead_personal_det cpd 
  left  join Tbl_FollowUpLead_Detail f on f.candidate_id = cpd.candidate_id
  where (f.Next_Date is null or f.Next_Date<=  convert(date,getdate())) and (cpd.ApplicationStatus=''Lead'') and (cpd.Agent_ID=@emp_id or @emp_id=0 or cpd.Agent_ID=0)
  --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
end
    ')
END

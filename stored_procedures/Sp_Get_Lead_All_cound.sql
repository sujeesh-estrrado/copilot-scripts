IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Lead_All_cound]')
    AND type = N'P'
)
BEGIN
    EXEC('
  
CREATE procedure [dbo].[Sp_Get_Lead_All_cound] --3,3
(@id bigint,@emp_id bigint)

as
begin

    if(@id=1)
    begin
        select count(*) from Tbl_Lead_Personal_Det where CAST(RegDate AS DATE) = CAST(GETDATE() AS DATE) and ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'' and 
        (CounselorEmployee_id=@emp_id or @emp_id=0)
        -- union all
         
        --select Candidate_Id from Tbl_Student_NewApplication where 
        --(ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved'' or ApplicationStatus=''rejected''
        --or ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Preactivated'')) m
    end
    else if(@id=2)---Total enquiey
    begin
        select count(*) from Tbl_Lead_Personal_Det where  ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'' and 
        (CounselorEmployee_id=@emp_id or @emp_id=0)
            
    --select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' ) 
    --  and counselorEmployee_id=@emp_id)s
        --union all

        --select Candidate_Id from Tbl_Student_NewApplication where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' ) 
        --and counselorEmployee_id=@emp_id)s

    end
    else if(@id=3) --Verified count
    begin



    select count(*) from (SELECT CPD.Candidate_Id FROM dbo.Tbl_Candidate_Personal_Det AS CPD where (CounselorEmployee_id=@emp_id)
    and (CPD.ApplicationStatus=''approved'' or CPD.ApplicationStatus=''Verified''  
    or  CPD.ApplicationStatus=''Conditional_Admission'' or  CPD.ApplicationStatus=''Preactivated'') and CPD.Candidate_DelStatus=0)h
    --union all
    
    --  SELECT Candidate_Id FROM dbo.Tbl_Student_NewApplication  where (CounselorEmployee_id=@emp_id)
 --   and (ApplicationStatus=''approved'' or ApplicationStatus=''Verified''  
 --   or  ApplicationStatus=''Conditional_Admission'' or  ApplicationStatus=''Preactivated'') and Candidate_DelStatus=0)h


    end
    else if(@id=4)
    begin
        
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
        --union all
        --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
    end
    else if(@id=5)--Approved candidate Count
    begin
        select count (*) from(select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Approved'' and CounselorEmployee_id=@emp_id) l
        --union all 
        --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Approved'' and CounselorEmployee_id=@emp_id) l
    end
    else if(@id=6) 
    begin
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where counselorEmployee_id=@emp_id)m
        --union all
        --select Candidate_Id from Tbl_Candidate_Personal_Det where counselorEmployee_id=@emp_id)m
    end
    else if(@id=7)--Total paid candidate Count
    begin
        select count(distinct Candidate_Id)as paidcount from Tbl_Candidate_Personal_Det D left join student_bill b on D.Candidate_Id=b.studentid
 where ( ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved'' or 
 ApplicationStatus=''rejected'' or ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission''
 or ApplicationStatus=''Preactivated'' or ApplicationStatus=''Completed'') and CounselorEmployee_id=@emp_id  
 and (ApplicationStage=''Submit without payment'' or ApplicationStage=''Submited with payment'')
  and billgroupid  in  
(select billgroupid from student_transaction where semesterno = -1 and outstandingbalance>0 
and studentid=Candidate_Id and billcancel = 0)
  
  end
    else if(@id=8)--On Hold candidate Count
    begin
        select Count(distinct M.Candidate_Id) as holdcount from Tbl_Status_change_by_Marketing M
left join Tbl_Candidate_Personal_Det D on M.Candidate_Id=D.candidate_Id
where  CounselorEmployee_id=@emp_id and M.status=''Hold''
    end
    else if(@id=9)--Pending Followups candidate Count
    begin
        
        --select count(Distinct F.Candidate_Id) as Followcount from Tbl_FollowUp_Detail F 
        --Left join Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.candidate_Id
        --where FORMAT(Next_Date, ''yyyy-MM-dd'')>=FORMAT(GetDate(), ''yyyy-MM-dd'') and CounselorEmployee_id=@emp_id and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'')
            select count(Distinct cpd.Candidate_Id) as Followcount from tbl_Lead_personal_det cpd 
    left  join (
    SELECT FD.*
    FROM Tbl_FollowUpLead_Detail FD
    WHERE FD.Follow_Up_Detail_Id = (
        SELECT MAX(Follow_Up_Detail_Id) 
        FROM Tbl_FollowUpLead_Detail 
        WHERE candidate_id = FD.candidate_id
    )
) f  on f.candidate_id = cpd.candidate_id
    where (f.Next_Date is null or f.Next_Date<=  convert(date,getdate())) and (cpd.ApplicationStatus=''Lead'') and (cpd.counseloremployee_id=@emp_id or @emp_id=0 )

    end
    --select (select count(*) from Tbl_Lead_Personal_Det where  ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'' and (CounselorEmployee_id=@emp_id or @emp_id=0))-
    --(select count(Tbl_FollowUpLead_Detail.Candidate_Id) from Tbl_FollowUpLead_Detail join Tbl_Lead_Personal_Det on Tbl_FollowUpLead_Detail.Candidate_Id=Tbl_Lead_Personal_Det.Candidate_Id 
    --where (Tbl_Lead_Personal_Det.CounselorEmployee_id=@emp_id or @emp_id=0) and Tbl_FollowUpLead_Detail.Next_Date<=cast(GETDATE() as date)) as Pending_Followups  end
    else if(@id=10)--rejected candidate Count
    begin
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''rejected'' and  CounselorEmployee_id=@emp_id)k 
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
where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'') and CouncellorID = @emp_id and CandidateID!=0 ) as count)
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

    else if(@id=18) --verified count admission
    begin
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Verified'' and CounselorEmployee_id=@emp_id)g
        
    end
    else if(@id=19) --verified count admission
    begin
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Preactivated'' and CounselorEmployee_id=@emp_id)g
        
    end
    else if(@id=20) --verified count admission
    begin
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''rejected'' and CounselorEmployee_id=@emp_id)g
        
    end
    else if(@id=21) --verified count admission
    begin
select Count(distinct M.Candidate_Id) as holdcount from Tbl_Status_change_by_Marketing M
left join Tbl_Candidate_Personal_Det D on M.Candidate_Id=D.candidate_Id
where  CounselorEmployee_id=@emp_id and M.status=''Hold''       
    end
    else if(@id=22) --verified count admission
    begin
        select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)g
        
    end
end
    ')
END

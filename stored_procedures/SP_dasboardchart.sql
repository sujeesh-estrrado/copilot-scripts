IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_dasboardchart]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_dasboardchart] --1
(@employeeid bigint)
as
begin

declare @totalcount bigint
declare @enquirycount bigint
declare @verifiedcount bigint
declare @students bigint
declare @approved bigint
--set @totalcount=(select count(Candidate_Id)-(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' ) and counselorEmployee_id=@employeeid)- 
--(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' or ApplicationCategory=''Preactivated'')-(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'')
---(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Approved'')from Tbl_Candidate_Personal_Det );
set @enquirycount=(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' ) and counselorEmployee_id=@employeeid);
set @verifiedcount=(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' or ApplicationCategory=''Preactivated'');
set @students=(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'');
set @approved=(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Approved'');
--if exists (select * from #tempchart)
--begin
--drop table #tempchart
--end
Create table #tempchart(valuetype varchar(Max),value bigint)
insert into #tempchart
--select''Count'',@totalcount as totalenquiry union all
select''My Enquiries'',@enquirycount as enquirycount union all
select'' Student'',@students as studentcount union all
select''Approved'',@approved as totalapproved union all
select ''Verified'',@verifiedcount as  verified

select * from #tempchart where value!=0
  end
    ')
END

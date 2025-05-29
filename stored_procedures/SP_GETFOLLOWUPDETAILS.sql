IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GETFOLLOWUPDETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GETFOLLOWUPDETAILS] --105   
(@Candidate_Id bigint=0,
@Flag bigint =0
)    
as begin   
if(@Flag=0)
Begin 
	select distinct concat(cpd.Candidate_Fname,'' '',cpd.Candidate_Lname) as CandidateName,    
	cpd.AdharNumber,ccd.Candidate_PermAddress,ccd.Candidate_Mob1,ccd.Candidate_Email,    
	cpd.RegDate,
	fd.Follow_Up_Detail_Id,    
	--fd.Counselor_Employee,
	concat(E.Employee_fname,'' '',E.Employee_Lname) as Counselor_Employee,
	convert(varchar(50),fd.Followup_Date,103)as Followup_Date ,fd.Followup_time,fd.Remarks,    
	fd.Respond_Type,fd.Action_to_Be_Taken,fd.Action_Taken,convert(varchar(50),fd.Next_Date,103)as Next_Date,fd.Medium,D.Department_Name,fd.call_duration    
    
	from dbo.Tbl_Candidate_Personal_Det cpd left join dbo.Tbl_Candidate_ContactDetails ccd    
	on ccd.Candidate_Id=cpd.Candidate_Id   
	inner join dbo.Tbl_FollowUp_Detail fd on fd.Candidate_Id=cpd.Candidate_Id
	left join dbo.tbl_New_Admission na on na.New_Admission_Id=cpd.New_Admission_Id
	left join dbo.Tbl_Department D on D.Department_Id=na.Department_Id
	left join Tbl_Employee E on E.Employee_Id=fd.Counselor_Employee
	where cpd.Candidate_Id= @Candidate_Id   and (fd.Delete_Status=0 or fd.Delete_Status is null) 
 end
 if(@Flag=1) --Hold Status
 begin
 select * from Tbl_Status_change_by_Marketing where status=''Hold'' and (delete_status=0 or delete_status is null)and Candidate_id=@Candidate_Id
 end   
 
 if(@Flag=2)
	 begin
		 select distinct cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname as CandidateName,    
		cpd.AdharNumber,ccd.Candidate_PermAddress,ccd.Candidate_Mob1,ccd.Candidate_Email,    
		NP.RegDate,
		fd.Follow_Up_Detail_Id,    
		fd.Counselor_Employee,convert(varchar(50),fd.Followup_Date,103)as Followup_Date ,fd.Followup_time,fd.Remarks,    
		fd.Respond_Type,fd.Action_to_Be_Taken,fd.Action_Taken,convert(varchar(50),fd.Next_Date,103)as Next_Date,fd.Medium,D.Department_Name    
    
		from Tbl_Student_NewApplication NP inner join dbo.Tbl_Candidate_Personal_Det cpd on NP.Candidate_Id=cpd.Candidate_Id
		left join dbo.Tbl_Candidate_ContactDetails ccd on ccd.Candidate_Id=NP.Candidate_Id    
		inner join dbo.Tbl_FollowUp_Detail fd on fd.Candidate_Id=NP.Candidate_Id
		left join dbo.tbl_New_Admission na on na.New_Admission_Id=NP.New_Admission_Id
		left join dbo.Tbl_Department D on D.Department_Id=na.Department_Id
		where cpd.Candidate_Id= @Candidate_Id and (fd.Delete_Status=0 or fd.Delete_Status is null)
	 end

 if(@Flag=3)
	 begin
		 Update dbo.Tbl_FollowUp_Detail  set Delete_Status=1 where Candidate_Id= @Candidate_Id
	 end
 if(@Flag=4)
begin
	Update Tbl_Status_change_by_Marketing set delete_status=1 where Candidate_id=@Candidate_Id
end
end
');
END;
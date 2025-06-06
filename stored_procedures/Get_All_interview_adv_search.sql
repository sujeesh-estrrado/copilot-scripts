IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_interview_adv_search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_All_interview_adv_search]
(@SearchTerm varchar(max),
@result varchar(100))
as
begin
if(@result!=''--Select--'' )begin
select count(dbo.Tbl_Candidate_Personal_Det.Candidate_Id) as counts
FROM              dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Employee_User INNER JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                         dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
						 where Tbl_Interview_Schedule_Log.Interview_status=@result or   dbo.Tbl_Candidate_Personal_Det.Candidate_Fname like ''%'' +@SearchTerm+ ''% ''or 
						 dbo.Tbl_Candidate_ContactDetails.Candidate_Email like ''%'' +@SearchTerm+ ''%'' or   Tbl_Interview_Schedule_Log.Interview_status like ''%'' +@SearchTerm+ ''% '' ;
						 end
						 else
						 begin
						 select count(dbo.Tbl_Candidate_Personal_Det.Candidate_Id)as counts
FROM           dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Employee_User INNER JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                         dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
						  where Tbl_Interview_Schedule_Log.Interview_status=@result or   dbo.Tbl_Candidate_Personal_Det.Candidate_Fname like ''%'' +@SearchTerm+ ''% ''or 
						 dbo.Tbl_Candidate_ContactDetails.Candidate_Email like ''%'' +@SearchTerm+ ''% '' or   Tbl_Interview_Schedule_Log.Interview_status like ''%'' +@SearchTerm+ ''% '' ;
end
end
    ')
END
ELSE
BEGIN
EXEC('ALTER procedure [dbo].[Get_All_interview_adv_search]
(@SearchTerm varchar(max),
@result varchar(100))
as
begin
if(@result!=''--Select--'' )begin
select count(dbo.Tbl_Candidate_Personal_Det.Candidate_Id) as counts
FROM              dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Employee_User INNER JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                         dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
						 where Tbl_Interview_Schedule_Log.Interview_status=@result or   dbo.Tbl_Candidate_Personal_Det.Candidate_Fname like ''%'' +@SearchTerm+ ''% ''or 
						 dbo.Tbl_Candidate_ContactDetails.Candidate_Email like ''%'' +@SearchTerm+ ''%'' or   Tbl_Interview_Schedule_Log.Interview_status like ''%'' +@SearchTerm+ ''% '' ;
						 end
						 else
						 begin
						 select count(dbo.Tbl_Candidate_Personal_Det.Candidate_Id)as counts
FROM           dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Employee_User INNER JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                         dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
						  where Tbl_Interview_Schedule_Log.Interview_status=@result or   dbo.Tbl_Candidate_Personal_Det.Candidate_Fname like ''%'' +@SearchTerm+ ''% ''or 
						 dbo.Tbl_Candidate_ContactDetails.Candidate_Email like ''%'' +@SearchTerm+ ''% '' or   Tbl_Interview_Schedule_Log.Interview_status like ''%'' +@SearchTerm+ ''% '' ;
end
end


')
END

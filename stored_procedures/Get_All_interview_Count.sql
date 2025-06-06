IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_interview_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_All_interview_Count]
(@SearchTerm varchar(max))

as
begin
select count(dbo.Tbl_Candidate_Personal_Det.Candidate_Id)as counts
FROM          dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Employee_User INNER JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                         dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
                        
                         end

    ')
END
ELSE
BEGIN
EXEC('ALTER procedure [dbo].[Get_All_interview_Count]
(@SearchTerm varchar(max))

as
begin
select count(dbo.Tbl_Candidate_Personal_Det.Candidate_Id)as counts
FROM          dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id LEFT OUTER JOIN
                         dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id LEFT OUTER JOIN
                         dbo.Tbl_Employee_User INNER JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id ON 
                         dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
						
						 end


')
END
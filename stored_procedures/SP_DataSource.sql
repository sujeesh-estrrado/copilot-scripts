IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_dasboardchart]') 
    AND type = N'P'
)
BEGIN
    EXEC('CREATE procedure [dbo].[SP_DataSource] 
AS
BEGIN

select distinct  Agent_Name as CounselorName,Agent_ID as Id from Tbl_Agent
union
select distinct Enquiry_From as CounselorName,Candidate_Id as Id from Tbl_Candidate_Personal_Det
where Enquiry_From is not null
union
select distinct  E.Employee_FName+'' ''+Employee_LName as CounselorName,E.employee_id from Tbl_Employee E
left join  [dbo].[Tbl_RoleAssignment] RA on RA.employee_id=E.Employee_Id
left join [dbo].[tbl_Role] R on  RA.role_id=R.role_Id
where RA.role_Id=7 
END 
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Aproved_By]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_Aproved_By]--151474
(@candidate_id bigint)
as
begin
SELECT        dbo.tbl_approval_log.candidate_id, concat(dbo.Tbl_Employee.Employee_FName,'' '',dbo.Tbl_Employee.Employee_LName) as Approved_by
FROM            dbo.Tbl_Employee_User INNER JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id INNER JOIN
                         dbo.Tbl_Employee_User AS Tbl_Employee_User_1 ON dbo.Tbl_Employee.Employee_Id = Tbl_Employee_User_1.Employee_Id INNER JOIN
                         dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.tbl_approval_log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.tbl_approval_log.candidate_id ON 
                         Tbl_Employee_User_1.User_Id = dbo.tbl_approval_log.Approved_by where tbl_approval_log.candidate_id=@candidate_id;
end
    ');
END

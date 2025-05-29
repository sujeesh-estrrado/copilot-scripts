IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Delete_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Delete_request]


AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SELECT      Distinct(  dbo.Tbl_Candidate_Personal_Det.Candidate_Id) as ID, dbo.Tbl_Candidate_ContactDetails.Candidate_Email, concat(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname,'' '',dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) as Candidate_Name, 
    dbo.Tbl_Candidate_Personal_Det.AdharNumber, Remarks,
                         dbo.Tbl_Candidate_Personal_Det.EnrollBy, dbo.Tbl_Employee.Employee_FName, dbo.Tbl_Candidate_Personal_Det.Candidate_Id, dbo.Tbl_Delete_Request.Delete_request_status 
                        
FROM          dbo.Tbl_Candidate_Personal_Det    INNER JOIN
                    dbo.Tbl_Candidate_ContactDetails     ON dbo.Tbl_Candidate_ContactDetails.Candidate_Id = dbo.Tbl_Candidate_Personal_Det.Candidate_Id left JOIN
                         dbo.Tbl_Delete_Request ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Delete_Request.Candidate_id Left JOIN
                         dbo.Tbl_Employee_User ON dbo.Tbl_Delete_Request.Requested_by = dbo.Tbl_Employee_User.User_Id LEFT JOIN
                         dbo.Tbl_Employee ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id where Tbl_Candidate_Personal_Det.Candidate_DelStatus=0 and Tbl_Delete_Request.Delete_status=0

END
	');
END;

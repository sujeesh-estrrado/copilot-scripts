IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Employee_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Employee_Details] --18,
	(
	@Candidate_Id bigint,
	@type varchar(50)
	)
AS
BEGIN
	select Counselor_id from Tbl_Student_Tc_request where Candidate_id=@Candidate_Id and Request_type=@type and Delete_status=0
END

'

);
END;

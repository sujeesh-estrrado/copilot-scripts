IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetCandidateDetailsById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[GetCandidateDetailsById]
    @CandidateId INT,@flag bigint=0
AS
BEGIN
    -- Select the required columns with a JOIN operation
    if(@flag=0)
        begin  
    SELECT 
        tu.user_id,
        cpd.adharnumber,
        tu.lms_userid,
        tcc.candidate_email
    FROM 
        Tbl_Student_User tsu
    JOIN 
        Tbl_Candidate_Personal_Det cpd ON cpd.Candidate_Id = tsu.Candidate_Id
    JOIN 
        Tbl_user tu ON tu.user_Id = tsu.User_Id
    JOIN 
        Tbl_Candidate_ContactDetails tcc ON tcc.Candidate_Id = cpd.Candidate_Id
    WHERE 
        tsu.Candidate_Id = @CandidateId   and  cpd.active=''3'';
        end

        if(@flag=1)
        begin
             SELECT  tu.user_id,tu.lms_userid,Employee_FName,Employee_Mail
    FROM Tbl_Employee_User tsu
    join  Tbl_Employee TE  on TE.employee_id = tsu.employee_id
    join Tbl_user tu on tu.user_Id = tsu.User_Id
    WHERE tsu.user_id =@CandidateId;
        end
END;
    ')
END

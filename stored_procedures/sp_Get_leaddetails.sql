IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_leaddetails]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[sp_Get_leaddetails]
@Candidate_Id bigint
as
begin
select Candidate_Email as Candidate_Email from Tbl_Lead_ContactDetails where Candidate_Id=@Candidate_Id
end
    ')
END

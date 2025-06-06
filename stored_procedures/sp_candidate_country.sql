IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_candidate_country]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_candidate_country](@id bigint,@name varchar(max))
as
begin
update Tbl_Candidate_ContactDetails set Candidate_ContAddress_Country=(select Country_Id from Tbl_Country where Country = @name) where Candidate_ContAddress_Country=@id;
update Tbl_Candidate_ContactDetails set Candidate_Guardian_Country=(select Country_Id from Tbl_Country where Country = @name) where Candidate_Guardian_Country=@id;
update Tbl_Candidate_ContactDetails set Candidate_PermAddress_Country=(select Country_Id from Tbl_Country where Country = @name) where Candidate_PermAddress_Country=@id;
--update Tbl_Candidate_Personal_Det set Candidate_Nationality=(select Nationality_Id from Tbl_Nationality where Nationality like ''%''+@name+''%'')
update Tbl_Candidate_ContactDetails set Candidate_Country=(select Country_Id from Tbl_Country where Country = @name) where Candidate_Country=@id;

end
    ')
END

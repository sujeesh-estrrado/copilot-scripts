IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Migrate_tbl_student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Migrate_tbl_student](@studentid bigint,@nationality bigint,@campusid bigint)
as
declare @nationalitname varchar(max),@nationalityid bigint
begin
set @nationalitname=(select cntry from tbl_Country_barracuda where id=106)
set @nationalityid=(select Nationality_Id  from Tbl_Nationality where Nationality like ''%''+@nationalitname+''%'')
update Tbl_Candidate_Personal_Det set Candidate_Nationality=@nationalityid,Campus=@campusid where Candidate_Id=@studentid;

end');
END
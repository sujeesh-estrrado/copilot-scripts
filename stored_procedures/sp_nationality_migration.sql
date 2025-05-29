IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_nationality_migration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_nationality_migration](@country varchar(500))
as
begin
if not exists
(select Nationality from tbl_Nationality where Nationality like ''%''+@country+''%'')
begin
insert into Tbl_Nationality(Nationality) values(@country);
end
end');
END
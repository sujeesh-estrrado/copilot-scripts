IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CountryId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CountryId] --India
(
@Country Varchar(MAX)
) 
as  
begin   
select * from Tbl_Country where Country=@Country
end
    ');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_identification_no]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_Get_identification_no] (@identification varchar(max))
as
begin
select * from tbl_candidate_personal_det where IdentificationNo=@identification;

end
    ')
END;

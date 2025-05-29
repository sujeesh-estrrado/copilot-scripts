IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ReleaseVisa]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_ReleaseVisa](@Candidate_Id bigint,@id bigint)
as
begin

update tbl_visa_details set passportcollectsts=null,holdingletterissuests=null,passport_return_date=null where Candidate_id=@Candidate_Id and delete_status=0
update tbl_passportcollect set Return_status=1 where candidate_id=@Candidate_Id and id=@id

end
    ')
END;

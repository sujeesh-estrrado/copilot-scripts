IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_certificate_maping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_insert_certificate_maping](@certificate_id int,@program_code varchar(mAX),@status varchar(100))
as
begin

insert into tbl_certificate_maping values(@certificate_id, @program_code,@status,0);
end');
END;

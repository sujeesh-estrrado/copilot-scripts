IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_gettempplaate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_gettempplaate](@id bigint)
as
begin
select * from Tbl_Template_generation where Template_id=@id;
END 
    ');
END;

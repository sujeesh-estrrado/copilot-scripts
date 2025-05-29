IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_LogipayResponse]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_LogipayResponse]
(
@response varchar(max)=''''
)
as
begin
    insert into tbl_iPayResponse ([IpayResponse],[datetime]) values(@response,GETDATE())
end

    ')
END;

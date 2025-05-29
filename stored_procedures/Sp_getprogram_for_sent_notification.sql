IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_getprogram_for_sent_notification]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_getprogram_for_sent_notification](@flag bigint)
AS
declare @day datetime
set	@day=dateadd(mm, 6, getdate());
BEGIN
	if(@flag=0)
	begin
	
	 select * from Tbl_Department where Expiry_Date=  CAST(FLOOR(CAST(@day as float)) as datetime);
	end
	else
	if(@flag=1)
	begin
	
	 select *from Tbl_Department where Renewal_Date=  CAST(FLOOR(CAST(@day as float)) as datetime);
	
	end
END
');
END;
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_FinancePrintlog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_FinancePrintlog] 
	(
	@Flag bigint=0,
	@Doc_Id  bigint=0,
	@User_Id bigint=0 )
      
AS
BEGIN 
	if(@Flag=0)
	begin
		insert into Tbl_FinancePrintlog (Doc_Id,Printed_Date,Printed_By)
		values(@Doc_Id,GETDATE(),@User_Id )
end
if(@Flag=1)
	begin
		select * from Tbl_FinancePrintlog  where Doc_Id=@Doc_Id
end

END');
END;
